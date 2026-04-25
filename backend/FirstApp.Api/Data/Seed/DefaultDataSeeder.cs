using System.Text.Json;
using FirstApp.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FirstApp.Api.Data.Seed;

public static class DefaultDataSeeder
{
    private static readonly JsonSerializerOptions JsonOptions = new()
    {
        PropertyNameCaseInsensitive = true,
    };

    public static async Task SeedAsync(AppDbContext db, string contentRootPath)
    {
        var seedPath = Path.Combine(contentRootPath, "Data", "Seed");
        var workoutSpecs = await ReadJsonAsync<DefaultWorkoutSpec>(
            Path.Combine(seedPath, "default-workouts.json"));
        var planSpecs = await ReadJsonAsync<DefaultWeeklyPlanSpec>(
            Path.Combine(seedPath, "default-weekly-plans.json"));

        if (workoutSpecs.Count == 0 && planSpecs.Count == 0)
            return;

        ValidateUniqueKeys(workoutSpecs.Select(w => w.Key), "default workout");
        ValidateUniqueKeys(planSpecs.Select(p => p.Key), "default weekly plan");

        var exerciseIds = await db.Exercises
            .AsNoTracking()
            .Select(e => e.Id)
            .ToListAsync();
        var exerciseIdSet = exerciseIds.ToHashSet();

        foreach (var workoutSpec in workoutSpecs)
        {
            ValidateWorkoutSpec(workoutSpec, exerciseIdSet);
            await UpsertWorkoutAsync(db, workoutSpec);
        }

        await db.SaveChangesAsync();

        var workoutIdsByKey = await db.Workouts
            .AsNoTracking()
            .Where(w => w.isDefault && w.DefaultKey != null)
            .ToDictionaryAsync(w => w.DefaultKey!, w => w.Id);

        foreach (var planSpec in planSpecs)
        {
            ValidateWeeklyPlanSpec(planSpec, workoutIdsByKey);
            await UpsertWeeklyPlanAsync(db, planSpec, workoutIdsByKey);
        }

        await db.SaveChangesAsync();
    }

    private static async Task<List<T>> ReadJsonAsync<T>(string path)
    {
        if (!File.Exists(path))
            return new List<T>();

        await using var stream = File.OpenRead(path);
        return await JsonSerializer.DeserializeAsync<List<T>>(stream, JsonOptions)
            ?? new List<T>();
    }

    private static async Task UpsertWorkoutAsync(AppDbContext db, DefaultWorkoutSpec spec)
    {
        var workout = await db.Workouts
            .Include(w => w.WorkoutExercises)
                .ThenInclude(we => we.Sets)
            .FirstOrDefaultAsync(w => w.DefaultKey == spec.Key);

        if (workout == null)
        {
            workout = new Workout
            {
                CreatedAt = DateTime.UtcNow,
                DefaultKey = spec.Key,
            };
            db.Workouts.Add(workout);
        }
        else
        {
            db.WorkoutExercises.RemoveRange(workout.WorkoutExercises);
            workout.WorkoutExercises.Clear();
        }

        workout.Name = spec.Name;
        workout.Description = spec.Description;
        workout.isDefault = true;

        workout.WorkoutExercises = spec.Exercises
            .OrderBy(e => e.OrderIndex)
            .Select(exercise => new WorkoutExercise
            {
                ExerciseId = exercise.ExerciseId,
                OrderIndex = exercise.OrderIndex,
                Sets = exercise.Sets
                    .OrderBy(s => s.SetIndex)
                    .Select(set => new WorkoutSet
                    {
                        SetIndex = set.SetIndex,
                        WeightKg = set.WeightKg,
                        Reps = set.Reps,
                        RestSeconds = set.RestSeconds,
                    })
                    .ToList(),
            })
            .ToList();
    }

    private static async Task UpsertWeeklyPlanAsync(
        AppDbContext db,
        DefaultWeeklyPlanSpec spec,
        Dictionary<string, int> workoutIdsByKey)
    {
        var plan = await db.WeeklyPlans
            .FirstOrDefaultAsync(p => p.DefaultKey == spec.Key);

        if (plan == null)
        {
            plan = new WeeklyPlan
            {
                CreatedAt = DateTime.UtcNow,
                DefaultKey = spec.Key,
                Week = new Week(),
            };
            db.WeeklyPlans.Add(plan);
        }

        plan.Name = spec.Name;
        plan.Description = spec.Description;
        plan.isDefault = true;
        plan.Week ??= new Week();
        plan.Week.MondayWorkoutId = GetWorkoutId(spec.Days.Monday, workoutIdsByKey);
        plan.Week.TuesdayWorkoutId = GetWorkoutId(spec.Days.Tuesday, workoutIdsByKey);
        plan.Week.WednesdayWorkoutId = GetWorkoutId(spec.Days.Wednesday, workoutIdsByKey);
        plan.Week.ThursdayWorkoutId = GetWorkoutId(spec.Days.Thursday, workoutIdsByKey);
        plan.Week.FridayWorkoutId = GetWorkoutId(spec.Days.Friday, workoutIdsByKey);
        plan.Week.SaturdayWorkoutId = GetWorkoutId(spec.Days.Saturday, workoutIdsByKey);
        plan.Week.SundayWorkoutId = GetWorkoutId(spec.Days.Sunday, workoutIdsByKey);
    }

    private static int? GetWorkoutId(string? workoutKey, Dictionary<string, int> workoutIdsByKey)
    {
        if (string.IsNullOrWhiteSpace(workoutKey))
            return null;

        return workoutIdsByKey[workoutKey];
    }

    private static void ValidateWorkoutSpec(DefaultWorkoutSpec spec, HashSet<int> exerciseIds)
    {
        if (string.IsNullOrWhiteSpace(spec.Key))
            throw new InvalidOperationException("Default workout key cannot be empty.");

        if (string.IsNullOrWhiteSpace(spec.Name))
            throw new InvalidOperationException($"Default workout '{spec.Key}' name cannot be empty.");

        if (spec.Exercises.Count == 0)
            throw new InvalidOperationException($"Default workout '{spec.Key}' must have at least one exercise.");

        foreach (var exercise in spec.Exercises)
        {
            if (!exerciseIds.Contains(exercise.ExerciseId))
                throw new InvalidOperationException(
                    $"Default workout '{spec.Key}' references missing exercise id {exercise.ExerciseId}.");

            if (exercise.Sets.Count == 0)
                throw new InvalidOperationException(
                    $"Default workout '{spec.Key}' exercise {exercise.ExerciseId} must have at least one set.");
        }
    }

    private static void ValidateWeeklyPlanSpec(
        DefaultWeeklyPlanSpec spec,
        Dictionary<string, int> workoutIdsByKey)
    {
        if (string.IsNullOrWhiteSpace(spec.Key))
            throw new InvalidOperationException("Default weekly plan key cannot be empty.");

        if (string.IsNullOrWhiteSpace(spec.Name))
            throw new InvalidOperationException($"Default weekly plan '{spec.Key}' name cannot be empty.");

        foreach (var workoutKey in spec.Days.WorkoutKeys)
        {
            if (!workoutIdsByKey.ContainsKey(workoutKey))
                throw new InvalidOperationException(
                    $"Default weekly plan '{spec.Key}' references missing workout key '{workoutKey}'.");
        }
    }

    private static void ValidateUniqueKeys(IEnumerable<string> keys, string label)
    {
        var duplicates = keys
            .Where(key => !string.IsNullOrWhiteSpace(key))
            .GroupBy(key => key)
            .Where(group => group.Count() > 1)
            .Select(group => group.Key)
            .ToList();

        if (duplicates.Count > 0)
            throw new InvalidOperationException(
                $"Duplicate {label} keys: {string.Join(", ", duplicates)}.");
    }

    private sealed class DefaultWorkoutSpec
    {
        public string Key { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public List<DefaultWorkoutExerciseSpec> Exercises { get; set; } = new();
    }

    private sealed class DefaultWorkoutExerciseSpec
    {
        public int ExerciseId { get; set; }
        public int OrderIndex { get; set; }
        public List<DefaultWorkoutSetSpec> Sets { get; set; } = new();
    }

    private sealed class DefaultWorkoutSetSpec
    {
        public int SetIndex { get; set; }
        public float WeightKg { get; set; }
        public int Reps { get; set; }
        public int RestSeconds { get; set; }
    }

    private sealed class DefaultWeeklyPlanSpec
    {
        public string Key { get; set; } = null!;
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public DefaultWeeklyPlanDaysSpec Days { get; set; } = new();
    }

    private sealed class DefaultWeeklyPlanDaysSpec
    {
        public string? Monday { get; set; }
        public string? Tuesday { get; set; }
        public string? Wednesday { get; set; }
        public string? Thursday { get; set; }
        public string? Friday { get; set; }
        public string? Saturday { get; set; }
        public string? Sunday { get; set; }

        public IEnumerable<string> WorkoutKeys
        {
            get
            {
                var keys = new[] { Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday };
                return keys.Where(key => !string.IsNullOrWhiteSpace(key)).Select(key => key!);
            }
        }
    }
}
