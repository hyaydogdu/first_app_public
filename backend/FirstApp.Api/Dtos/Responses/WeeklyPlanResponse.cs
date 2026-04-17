namespace FirstApp.Api.Dtos;

public class WeeklyPlanResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    public DateTime CreatedAt { get; set; }
    public WeekResponse Week { get; set; } = new();
}

public class WeekResponse
{
    public WorkoutSummaryResponse? Monday { get; set; }
    public WorkoutSummaryResponse? Tuesday { get; set; }
    public WorkoutSummaryResponse? Wednesday { get; set; }
    public WorkoutSummaryResponse? Thursday { get; set; }
    public WorkoutSummaryResponse? Friday { get; set; }
    public WorkoutSummaryResponse? Saturday { get; set; }
    public WorkoutSummaryResponse? Sunday { get; set; }
}

public class WorkoutSummaryResponse
{
    public int Id { get; set; }
    public string Name { get; set; } = null!;
}