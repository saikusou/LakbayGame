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
        public async Task<ActionResult<Points>> SavePoints([FromBody] Points points)
        {
            if (points is null)
            {
                return BadRequest("Data is null.");
            }
            var existingLesson = await _context.Points.FirstOrDefaultAsync(p => p.UserId == points.UserId && p.Day == points.Day && p.Lesson == points.Lesson && p.Act == points.Act);

            if (existingLesson != null)
            {
                return Conflict(new
                {
                    message = "Activity already completed.",
                });
            }

            _context.Points.Add(points);

            int countedPoints = points.CountedPoints;

            var totalPoints = await _context.TotalPoints.FirstOrDefaultAsync(tp => tp.UserId == points.UserId);

            if (totalPoints is null)
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

        [HttpPost("claim-daily-reward")]
        public async Task<IActionResult> ClaimDailyReward([FromBody] int userId)
        {
            var today = DateTime.Today;

            // Check if already claimed today
            bool alreadyClaimed = await _context.DailyRewards
                .AnyAsync(x =>
                    x.UserId == userId &&
                    x.RewardDate == today);

            if (alreadyClaimed)
            {
                return Conflict(new
                {
                    success = false,
                    message = "Daily reward already claimed."
                });
            }

            // Get latest reward record
            var lastReward = await _context.DailyRewards
                .Where(x => x.UserId == userId)
                .OrderByDescending(x => x.RewardDate)
                .FirstOrDefaultAsync();

            int streakDay = 1;

            if (lastReward != null)
            {
                var daysDifference = (today - lastReward.RewardDate).Days;

                if (daysDifference == 1)
                {
                    streakDay = (lastReward.PointsAwarded / 5) + 1;
                }
                else
                {
                    streakDay = 1;
                }
            }

            int pointsToAward = streakDay * 5;

            var reward = new DailyRewardRequest
            {
                UserId = userId,
                RewardDate = today,
                PointsAwarded = pointsToAward
            };

            _context.DailyRewards.Add(reward);

            var totalPoints = await _context.TotalPoints
                .FirstOrDefaultAsync(tp => tp.UserId == userId);

            if (totalPoints == null)
            {
                totalPoints = new TotalPoints
                {
                    UserId = userId,
                    TotalCountedPoints = pointsToAward
                };

                _context.TotalPoints.Add(totalPoints);
            }
            else
            {
                totalPoints.TotalCountedPoints += pointsToAward;
            }

            await _context.SaveChangesAsync();

            return Ok(new
            {
                success = true,
                streakDay,
                pointsAwarded = pointsToAward
            });
        }
    }
}