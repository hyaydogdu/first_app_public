namespace FirstApp.Api.Dtos;

public class WorkoutResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }

    public List<WorkoutExerciseResponse> WorkoutExercises { get; set; } = new();
}

public class WorkoutExerciseResponse
{
    public int Id { get; set; }
    public int ExerciseId { get; set; }
    public string ExerciseName { get; set; } = null!;

    public string? ExerciseVideoUrl { get; set; }
    public string? ExerciseImageUrl { get; set; }

    public int OrderIndex { get; set; }

    public List<WorkoutSetResponse> Sets { get; set; } = new();
}

public class WorkoutSetResponse
{
    public int SetIndex { get; set; }
    public float WeightKg { get; set; }
    public float Reps { get; set; }
    public int RestSeconds { get; set; }
}
