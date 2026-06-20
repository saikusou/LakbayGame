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
            if(points == null)
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
            await _context.SaveChangesAsync();

            return Ok(new
            {
                message = "Points saved successfully.",
            });
        }
    }
}