using LakbayGameApi.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace LakbayGameApi.Controllers
{
    [Route("points")]
    [ApiController]
    public class PointsController(LakbayGameDbContext context) : ControllerBase
    {
        private readonly LakbayGameDbContext _context = context;

        [HttpPost("savePoints")]
        public async Task<ActionResult<Points>> SavePoints([FromBody]Points points)
        {
            if(points is null)
            {
                return BadRequest("Data is null.");
            }
            var existingLesson = await _context.Points.FirstOrDefaultAsync(p => p.UserId == points.UserId && p.Day == points.Day && p.Lesson == points.Lesson && p.Act == points.Act);

            if(existingLesson != null)
            {
                return Conflict(new
                {
                    message = "Activity already completed.",
                });
            }

            _context.Points.Add(points);

            int countedPoints = points.CountedPoints;

            var totalPoints = await _context.TotalPoints.FirstOrDefaultAsync(tp => tp.UserId == points.UserId);

            if(totalPoints is null)
            {
                totalPoints = new TotalPoints
                {
                    UserId = points.UserId,
                    TotalCountedPoints = countedPoints
                };
                _context.TotalPoints.Add(totalPoints);

            }
            else
            {
                int currentTotal = totalPoints.TotalCountedPoints;
                totalPoints.TotalCountedPoints = currentTotal + countedPoints;
                _context.TotalPoints.Update(totalPoints);
            }
           
                await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Points saved successfully.",
            });
        }

        [HttpGet("totalpoints/{userId}")]
        public async Task<IActionResult> GetTotalPoints(int userId)
        {
            var totalPoints = await _context.TotalPoints
                .FirstOrDefaultAsync(t => t.UserId == userId);

            if (totalPoints == null)
            {
                return Ok(new
                {
                    userId,
                    totalPoints = 0
                });
            }

            return Ok(new
            {
                userId,
                totalPoints = totalPoints.TotalCountedPoints
            });
        }
    }
}