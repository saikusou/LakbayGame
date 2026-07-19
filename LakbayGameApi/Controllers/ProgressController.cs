using LakbayGameApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LakbayGameApi.Controllers
{
    [Route("api/progress")]
    [ApiController]
    public class ProgressController : Controller
    {
      private readonly LakbayGameDbContext _context;  

        public ProgressController(LakbayGameDbContext context)
        {
            _context = context;
        }

        [HttpGet("getProgress/{userId}/{lesson}")]
        public async Task<IActionResult> GetProgress(int userId, string lesson)
        {
            var lessonActivities = await _context.LessonActivities
                .Where(x => x.Lesson == lesson)
                .ToListAsync();

            if (!lessonActivities.Any())
            {
                return NotFound("Lesson structure not found.");
            }


            var points = await _context.Points
                .Where(p =>
                    p.UserId == userId &&
                    p.Lesson == lesson)
                .ToListAsync();


            int completedActivities = 0;

            foreach (var activity in lessonActivities)
            {
                int completedForDay = points
                    .Where(p => p.Day == activity.Day)
                    .Select(p => p.Act)
                    .Distinct()
                    .Count();


                completedActivities += Math.Min(
                    completedForDay,
                    activity.TotalActivities
                );
            }


            int totalActivities = lessonActivities
                .Sum(x => x.TotalActivities);


            double percentageCompleted =
                Math.Round(
                    (double)completedActivities / totalActivities * 100,
                    2
                );


            return Ok(new
            {
                Lesson = lesson,
                PercentageCompleted = percentageCompleted,
                CompletedActivities = completedActivities,
                TotalActivities = totalActivities
            });
        }
    }
}
