namespace FirstApp.Api.Contracts;

public class UpdateWeeklyPlanDayRequest
{
    public string DayName { get; set; } = null!;
    public int? WorkoutId { get; set; }
}