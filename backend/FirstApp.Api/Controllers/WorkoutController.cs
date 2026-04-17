using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FirstApp.Api.Data;
using FirstApp.Api.Models;
using FirstApp.Api.Dtos;

namespace FirstApp.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WorkoutController : ControllerBase
    {
        private readonly AppDbContext _context;

        public WorkoutController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ CREATE WORKOUT
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateWorkoutRequest request)
        {

            // 🔧 VALIDATION
            var validation = ValidateWorkoutExercises(
                request.WorkoutExercises,
                we => we.Sets,
                s => s.SetIndex,
                s => s.Reps,
                s => s.RestSeconds
            );

            if (validation != null)
                return validation;

            var workout = new Workout
            {
                Name = request.Name,
                Description = request.Description,
                CreatedAt = DateTime.UtcNow,
                WorkoutExercises = request.WorkoutExercises.Select(we =>
                    new WorkoutExercise
                    {
                        ExerciseId = we.ExerciseId,
                        OrderIndex = we.OrderIndex,
                        Sets = we.Sets.Select(s => new WorkoutSet
                        {
                            SetIndex = s.SetIndex,
                            WeightKg = s.WeightKg,
                            Reps = s.Reps,
                            RestSeconds = s.RestSeconds
                        }).ToList()
                    }).ToList()
            };

            _context.Workouts.Add(workout);
            await _context.SaveChangesAsync();

            var response = await BuildWorkoutResponse(workout.Id);

            return Ok(response);
        }

        // ✅ GET ALL WORKOUTS
        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var workouts = await _context.Workouts
                .AsNoTracking()
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Exercise)
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Sets)
                .ToListAsync();

            var response = workouts.Select(BuildWorkoutResponseFromEntity).ToList();
            return Ok(response);
        }

        // ✅ GET WORKOUT BY ID
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var workout = await _context.Workouts
                .AsNoTracking()
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Exercise)
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Sets)
                .FirstOrDefaultAsync(w => w.Id == id);

            if (workout == null)
                return NotFound();

            var response = BuildWorkoutResponseFromEntity(workout);

            return Ok(response);
        }


        // ✅ UPDATE WORKOUT (name / desc)
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(
            int id,
            [FromBody] UpdateWorkoutRequest request)
        {
            var workout = await _context.Workouts.FindAsync(id);
            if (workout == null)
                return NotFound();

            workout.Name = request.Name;
            workout.Description = request.Description;

            await _context.SaveChangesAsync();
            return NoContent();
        }


        // ✅ UPDATE WORKOUT EXERCISES (SET REPLACE MANTIĞI)
        [HttpPut("{id}/exercises")]
        public async Task<IActionResult> UpdateExercises(
            int id,
            [FromBody] UpdateWorkoutExercisesRequest request)
        {
            var workout = await _context.Workouts
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Sets)
                .FirstOrDefaultAsync(w => w.Id == id);

            if (workout == null)
                return NotFound();

            // 🔧 VALIDATION
            var validation = ValidateWorkoutExercises(
                request.WorkoutExercises,
                we => we.Sets,
                s => s.SetIndex,
                s => s.Reps,
                s => s.RestSeconds
   );

            if (validation != null)
                return validation;


            // 🔥 Eski her şeyi sil
            _context.WorkoutExercises.RemoveRange(workout.WorkoutExercises);
            workout.WorkoutExercises.Clear();

            // 🔥 Baştan ekle
            foreach (var we in request.WorkoutExercises)
            {
                workout.WorkoutExercises.Add(new WorkoutExercise
                {
                    WorkoutId = workout.Id,
                    ExerciseId = we.ExerciseId,
                    OrderIndex = we.OrderIndex,
                    Sets = we.Sets.Select(s => new WorkoutSet
                    {
                        SetIndex = s.SetIndex,
                        WeightKg = s.WeightKg,
                        Reps = s.Reps,
                        RestSeconds = s.RestSeconds
                    }).ToList()
                });
            }

            await _context.SaveChangesAsync();
            return NoContent();
        }

        // ✅ DELETE WORKOUT EXERCISE
        [HttpDelete("{workoutId}/exercises/{workoutExerciseId}")]
        public async Task<IActionResult> DeleteExercise(
    int workoutId,
    int workoutExerciseId)
        {
            var workoutExercise = await _context.WorkoutExercises
                .FirstOrDefaultAsync(we =>
                    we.Id == workoutExerciseId &&
                    we.WorkoutId == workoutId);

            if (workoutExercise == null)
                return NotFound();

            _context.WorkoutExercises.Remove(workoutExercise);
            await _context.SaveChangesAsync();

            return NoContent();
        }


        // ✅ DELETE WORKOUT
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var workout = await _context.Workouts.FindAsync(id);
            if (workout == null)
                return NotFound();

            _context.Workouts.Remove(workout);
            await _context.SaveChangesAsync();
            return NoContent();
        }

        // =========================
        // 🔧 RESPONSE BUILDER
        // =========================
        private async Task<WorkoutResponse> BuildWorkoutResponse(int workoutId)
        {
            var workout = await _context.Workouts
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Exercise)
                .Include(w => w.WorkoutExercises)
                    .ThenInclude(we => we.Sets)
                .FirstAsync(w => w.Id == workoutId);

            return BuildWorkoutResponseFromEntity(workout);
        }

        private WorkoutResponse BuildWorkoutResponseFromEntity(Workout workout)
        {
            return new WorkoutResponse
            {
                Id = workout.Id,
                Name = workout.Name,
                Description = workout.Description,
                WorkoutExercises = workout.WorkoutExercises
                    .OrderBy(we => we.OrderIndex)
                    .Select(we => new WorkoutExerciseResponse
                    {
                        Id = we.Id,
                        ExerciseId = we.ExerciseId,
                        ExerciseName = we.Exercise.Name,
                        ExerciseImageUrl = we.Exercise.ImageUrl,
                        OrderIndex = we.OrderIndex,
                        Sets = we.Sets
                            .OrderBy(s => s.SetIndex)
                            .Select(s => new WorkoutSetResponse
                            {
                                SetIndex = s.SetIndex,
                                WeightKg = s.WeightKg,
                                Reps = s.Reps,
                                RestSeconds = s.RestSeconds
                            }).ToList()
                    }).ToList()
            };
        }

        private IActionResult? ValidateWorkoutExercises<TExercise, TSet>(
    IEnumerable<TExercise> exercises,
    Func<TExercise, IEnumerable<TSet>> getSets,
    Func<TSet, int> getSetIndex,
    Func<TSet, int> getReps,
    Func<TSet, int> getRestSeconds)
        {
            if (!exercises.Any())
                return BadRequest("Workout must have at least one exercise.");

            foreach (var exercise in exercises)
            {
                var sets = getSets(exercise).ToList();

                if (!sets.Any())
                    return BadRequest("Each exercise must have at least one set.");

                if (sets.Any(s => getRestSeconds(s) < 0))
                    return BadRequest("Rest must be 0 or greater.");

                if (sets.Any(s => getReps(s) < 0))
                    return BadRequest("Reps must be 0 or greater.");

                if (sets.Select(getSetIndex).Distinct().Count() != sets.Count)
                    return BadRequest("SetIndex values must be unique.");
            }

            return null;
        }
    }
}

