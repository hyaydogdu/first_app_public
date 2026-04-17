namespace FirstApp.Api.Models;

public class Workout
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    // WORKOUT = EXERCISE LIST
    public List<WorkoutExercise> WorkoutExercises { get; set; } = new();
}
