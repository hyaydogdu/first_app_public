namespace FirstApp.Api.Contracts;

public class CreateWeeklyPlanRequest
{
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
}