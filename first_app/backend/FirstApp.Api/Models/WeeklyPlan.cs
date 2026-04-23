namespace FirstApp.Api.Models;

public class WeeklyPlan
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public Week Week { get; set; } = null!;
}

public class Week
{
    public int? MondayWorkoutId { get; set; }
    public Workout? Monday { get; set; }

    public int? TuesdayWorkoutId { get; set; }
    public Workout? Tuesday { get; set; }

    public int? WednesdayWorkoutId { get; set; }
    public Workout? Wednesday { get; set; }

    public int? ThursdayWorkoutId { get; set; }
    public Workout? Thursday { get; set; }

    public int? FridayWorkoutId { get; set; }
    public Workout? Friday { get; set; }

    public int? SaturdayWorkoutId { get; set; }
    public Workout? Saturday { get; set; }

    public int? SundayWorkoutId { get; set; }
    public Workout? Sunday { get; set; }
}
