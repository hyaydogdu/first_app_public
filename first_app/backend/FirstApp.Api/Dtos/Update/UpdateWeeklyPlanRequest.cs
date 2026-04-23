public class UpdateWeeklyPlanRequest
{
    public string Name { get; set; } = null!;
    public string? Description { get; set; }

    public int? MondayWorkoutId { get; set; }
    public int? TuesdayWorkoutId { get; set; }
    public int? WednesdayWorkoutId { get; set; }
    public int? ThursdayWorkoutId { get; set; }
    public int? FridayWorkoutId { get; set; }
    public int? SaturdayWorkoutId { get; set; }
    public int? SundayWorkoutId { get; set; }
}