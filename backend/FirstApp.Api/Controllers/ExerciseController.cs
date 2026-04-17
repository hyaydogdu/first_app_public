using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using FirstApp.Api.Data;

namespace FirstApp.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class ExercisesController : ControllerBase
{
    private readonly AppDbContext _context;

    public ExercisesController(AppDbContext context)
    {
        _context = context;
    }

    // ✅ GET ALL EXERCISES
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var exercises = await _context.Exercises
            .AsNoTracking()
            .Select(e => new
            {
                e.Id,
                e.Name,
                e.Notes,
                e.ImageUrl,
                e.VideoUrl
            })
            .ToListAsync();

        return Ok(exercises);
    }
}
