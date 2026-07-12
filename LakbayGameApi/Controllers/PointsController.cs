using LakbayGameApi.Dto;
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

        private const int StreakCycleLength = 7;

        private const int PointsPerDay = 5;

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
        public async Task<IActionResult> ClaimDailyReward([FromBody] ClaimDailyRewardDto dto)
        {
            var today = DateTime.Today;

   
            bool alreadyClaimed = await _context.DailyRewards
                .AnyAsync(x =>
                    x.UserId == dto.UserId &&
                    x.RewardDate == today);

            if (alreadyClaimed)
            {
                return Conflict(new
                {
                    success = false,
                    message = "Daily reward already claimed."
                });
            }

            int streakDay = await ComputeNextStreakDayAsync(dto.UserId, today);
            int pointsToAward = PointsPerDay;

            var reward = new DailyRewardRequest
            {
                UserId = dto.UserId,
                RewardDate = today,
                PointsAwarded = pointsToAward
            };

            _context.DailyRewards.Add(reward);

            var totalPoints = await _context.TotalPoints
                .FirstOrDefaultAsync(tp => tp.UserId == dto.UserId);

            if (totalPoints == null)
            {
                totalPoints = new TotalPoints
                {
                    UserId = dto.UserId,
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

        [HttpGet("daily-reward-status/{userId}")]
        public async Task<IActionResult> GetDailyRewardStatus(int userId)
        {
            var today = DateTime.Today;

            bool alreadyClaimed = await _context.DailyRewards
                .AnyAsync(x =>
                    x.UserId == userId &&
                    x.RewardDate == today);

            int currentStreakDay;

            if (alreadyClaimed)
            {
     
                int rawLength = await ComputeConsecutiveStreakLengthAsync(userId, today);
                currentStreakDay = ((rawLength - 1) % StreakCycleLength) + 1;
            }
            else
            {
                currentStreakDay = await ComputeNextStreakDayAsync(userId, today);
            }

            int claimedDaysSoFar = alreadyClaimed
                ? currentStreakDay
                : currentStreakDay - 1;

            return Ok(new
            {
                alreadyClaimed,
                currentStreakDay,
                claimedDaysSoFar,
                cycleLength = StreakCycleLength
            });
        }


        private async Task<int> ComputeNextStreakDayAsync(int userId, DateTime today)
        {
            var lastReward = await _context.DailyRewards
                .Where(x => x.UserId == userId)
                .OrderByDescending(x => x.RewardDate)
                .FirstOrDefaultAsync();

            if (lastReward == null)
            {
                return 1;
            }

            var daysDifference = (today - lastReward.RewardDate).Days;

            if (daysDifference != 1)
            {

                return 1;
            }

            int rawLength = await ComputeConsecutiveStreakLengthAsync(userId, lastReward.RewardDate);
            int nextRawLength = rawLength + 1;

            return ((nextRawLength - 1) % StreakCycleLength) + 1;
        }

        private async Task<int> ComputeConsecutiveStreakLengthAsync(int userId, DateTime uptoDate)
        {
            var rewardDates = await _context.DailyRewards
                .Where(x => x.UserId == userId && x.RewardDate <= uptoDate)
                .OrderByDescending(x => x.RewardDate)
                .Select(x => x.RewardDate)
                .ToListAsync();

            int count = 0;
            var expected = uptoDate;

            foreach (var date in rewardDates)
            {
                if (date == expected)
                {
                    count++;
                    expected = expected.AddDays(-1);
                }
                else if (date < expected)
                {
                    break;
                }
  
            }

            return count;
        }
    }
}