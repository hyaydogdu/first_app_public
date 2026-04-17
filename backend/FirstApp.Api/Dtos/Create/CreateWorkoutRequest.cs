namespace FirstApp.Api.Dtos;

public class CreateWorkoutRequest
{
    public string Name { get; set; } = null!;
    public string? Description { get; set; }

    public List<CreateWorkoutExerciseRequest> WorkoutExercises { get; set; } = new();
}

public class CreateWorkoutExerciseRequest
{
    public int ExerciseId { get; set; }

    // Workout içindeki sırası
    public int OrderIndex { get; set; }

    // Setler
    public List<CreateWorkoutSetRequest> Sets { get; set; } = new();

}

public class CreateWorkoutSetRequest
{
    public int SetIndex { get; set; }      // 1,2,3...
    public float WeightKg { get; set; }    // +60, 0, -20
    public int Reps { get; set; }
    public int RestSeconds { get; set; }   // 60, 90, 120...
}
