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

    // CREATE
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateWeeklyPlanRequest request)
    {
        var plan = new WeeklyPlan
        {
            Name = request.Name,
            Description = request.Description,
            CreatedAt = DateTime.UtcNow,
            Week = new Week(),
        };

        _context.WeeklyPlans.Add(plan);
        await _context.SaveChangesAsync();

        return Ok(ToResponse(plan));
    }

    // GET ALL
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var plans = await IncludeWeekWorkoutDetails(_context.WeeklyPlans)
            .OrderByDescending(x => x.CreatedAt)
            .ToListAsync();

        return Ok(plans.Select(ToResponse));
    }

    // GET BY ID
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var plan = await IncludeWeekWorkoutDetails(_context.WeeklyPlans)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (plan == null)
            return NotFound();

        return Ok(ToResponse(plan));
    }

    // UPDATE
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] UpdateWeeklyPlanRequest request)
    {
        var plan = await _context.WeeklyPlans
            .Include(x => x.Week)
            .FirstOrDefaultAsync(x => x.Id == id);

        if (plan == null)
            return NotFound();

        if (plan.isDefault)
            return StatusCode(StatusCodes.Status403Forbidden, "Default weekly plans cannot be modified.");

        plan.Name = request.Name;
        plan.Description = request.Description;

        plan.Week.MondayWorkoutId = request.MondayWorkoutId;
        plan.Week.TuesdayWorkoutId = request.TuesdayWorkoutId;
        plan.Week.WednesdayWorkoutId = request.WednesdayWorkoutId;
        plan.Week.ThursdayWorkoutId = request.ThursdayWorkoutId;
        plan.Week.FridayWorkoutId = request.FridayWorkoutId;
        plan.Week.SaturdayWorkoutId = request.SaturdayWorkoutId;
        plan.Week.SundayWorkoutId = request.SundayWorkoutId;

        await _context.SaveChangesAsync();

        return NoContent();
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

        if (plan.isDefault)
            return StatusCode(StatusCodes.Status403Forbidden, "Default weekly plans cannot be modified.");

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

        return NoContent();
    }

    // DELETE
    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(int id)
    {
        var plan = await _context.WeeklyPlans.FindAsync(id);

        if (plan == null)
            return NotFound();

        if (plan.isDefault)
            return StatusCode(StatusCodes.Status403Forbidden, "Default weekly plans cannot be deleted.");

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
            isDefault = plan.isDefault,
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
            Description = workout.Description,
            isDefault = workout.isDefault,
            CreatedAt = workout.CreatedAt,
            WorkoutExercises = workout.WorkoutExercises
                .OrderBy(we => we.OrderIndex)
                .Select(we => new WorkoutExerciseResponse
                {
                    Id = we.Id,
                    ExerciseId = we.ExerciseId,
                    ExerciseName = we.Exercise.Name,
                    ExerciseType = we.Exercise.ExerciseType.ToString(),
                    ExerciseVideoUrl = we.Exercise.VideoUrl,
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
                }).ToList(),
        };
    }

    private static IQueryable<WeeklyPlan> IncludeWeekWorkoutDetails(IQueryable<WeeklyPlan> query)
    {
        return query
            .Include("Week.Monday.WorkoutExercises.Exercise")
            .Include("Week.Monday.WorkoutExercises.Sets")
            .Include("Week.Tuesday.WorkoutExercises.Exercise")
            .Include("Week.Tuesday.WorkoutExercises.Sets")
            .Include("Week.Wednesday.WorkoutExercises.Exercise")
            .Include("Week.Wednesday.WorkoutExercises.Sets")
            .Include("Week.Thursday.WorkoutExercises.Exercise")
            .Include("Week.Thursday.WorkoutExercises.Sets")
            .Include("Week.Friday.WorkoutExercises.Exercise")
            .Include("Week.Friday.WorkoutExercises.Sets")
            .Include("Week.Saturday.WorkoutExercises.Exercise")
            .Include("Week.Saturday.WorkoutExercises.Sets")
            .Include("Week.Sunday.WorkoutExercises.Exercise")
            .Include("Week.Sunday.WorkoutExercises.Sets");
    }



}

public class AssignWorkoutRequest
{
    public string Day { get; set; } = null!;
    public int? WorkoutId { get; set; }
}
