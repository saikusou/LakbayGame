using LakbayGameApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

[Route("api/updateActivity")]
[ApiController]
public class LessonActivitiesController : ControllerBase
{
    private readonly LakbayGameDbContext _context;

    public LessonActivitiesController(LakbayGameDbContext context)
    {
        _context = context;
    }


    [HttpPut("{lesson}/{day}/{totalActivities}")]
    public async Task<IActionResult> UpdateLessonActivity(
        string lesson,
        string day,
        int totalActivities)
    {
        var lessonActivity = await _context.LessonActivities
            .FirstOrDefaultAsync(x => x.Lesson == lesson && x.Day == day);

        if (lessonActivity == null)
        {
            return NotFound(new
            {
                message = "Lesson activity not found."
            });
        }

        lessonActivity.TotalActivities = totalActivities;

        await _context.SaveChangesAsync();

        return Ok(new
        {
            message = "Updated successfully.",
            data = lessonActivity
        });
    }
}