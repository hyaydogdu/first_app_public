using FirstApp.Api.Data;
using FirstApp.Api.Dtos;
using FirstApp.Api.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace FirstApp.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class WeeklyPlansController : ControllerBase
{
    private readonly AppDbContext _context;

    public WeeklyPlansController(AppDbContext context)
    {
        _context = context;
    }

    // GET ALL
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var plans = await _context.WeeklyPlans
            .Include(x => x.Week.Monday)
            .Include(x => x.Week.Tuesday)
            .Include(x => x.Week.Wednesday)
            .Include(x => x.Week.Thursday)
            .Include(x => x.Week.Friday)
            .Include(x => x.Week.Saturday)
            .Include(x => x.Week.Sunday)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();

        return Ok(plans.Select(ToResponse));
    }

    // GET BY ID
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var plan = await _context.WeeklyPlans
            .Include(x => x.Week.Monday)
            .Include(x => x.Week.Tuesday)
            .Include(x => x.Week.Wednesday)
            .Include(x => x.Week.Thursday)
            .Include(x => x.Week.Friday)
            .Include(x => x.Week.Saturday)
            .Include(x => x.Week.Sunday)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (plan == null)
            return NotFound();

        return Ok(ToResponse(plan));
    }

    // CREATE
    [HttpPost]
    public async Task<IActionResult> Create(WeeklyPlan plan)
    {
        plan.CreatedAt = DateTime.UtcNow;

        _context.WeeklyPlans.Add(plan);
        await _context.SaveChangesAsync();

        return Ok(plan);
    }

    // UPDATE DAY WORKOUT
    [HttpPut("{id}/assign")]
    public async Task<IActionResult> AssignWorkout(
        int id,
        [FromBody] AssignWorkoutRequest request)
    {
        var plan = await _context.WeeklyPlans
            .Include(x => x.Week)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (plan == null)
            return NotFound();

        switch (request.Day.ToLowerInvariant())
        {
            case "monday":
                plan.Week.MondayWorkoutId = request.WorkoutId;
                break;

            case "tuesday":
                plan.Week.TuesdayWorkoutId = request.WorkoutId;
                break;

            case "wednesday":
                plan.Week.WednesdayWorkoutId = request.WorkoutId;
                break;

            case "thursday":
                plan.Week.ThursdayWorkoutId = request.WorkoutId;
                break;

            case "friday":
                plan.Week.FridayWorkoutId = request.WorkoutId;
                break;

            case "saturday":
                plan.Week.SaturdayWorkoutId = request.WorkoutId;
                break;

            case "sunday":
                plan.Week.SundayWorkoutId = request.WorkoutId;
                break;

            default:
                return BadRequest("Invalid day");
        }

        await _context.SaveChangesAsync();

        return Ok(plan);
    }

    // DELETE
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var plan = await _context.WeeklyPlans.FindAsync(id);

        if (plan == null)
            return NotFound();

        _context.WeeklyPlans.Remove(plan);
        await _context.SaveChangesAsync();

        return Ok();
    }

    private static WeeklyPlanResponse ToResponse(WeeklyPlan plan)
    {
        return new WeeklyPlanResponse
        {
            Id = plan.Id,
            Name = plan.Name,
            Description = plan.Description,
            CreatedAt = plan.CreatedAt,
            Week = new WeekResponse
            {
                Monday = ToWorkoutSummary(plan.Week.Monday),
                Tuesday = ToWorkoutSummary(plan.Week.Tuesday),
                Wednesday = ToWorkoutSummary(plan.Week.Wednesday),
                Thursday = ToWorkoutSummary(plan.Week.Thursday),
                Friday = ToWorkoutSummary(plan.Week.Friday),
                Saturday = ToWorkoutSummary(plan.Week.Saturday),
                Sunday = ToWorkoutSummary(plan.Week.Sunday),
            },
        };
    }

    private static WorkoutSummaryResponse? ToWorkoutSummary(Workout? workout)
    {
        if (workout == null)
            return null;

        return new WorkoutSummaryResponse
        {
            Id = workout.Id,
            Name = workout.Name,
        };
    }
}

public class AssignWorkoutRequest
{
    public string Day { get; set; } = null!;
    public int? WorkoutId { get; set; }
}
