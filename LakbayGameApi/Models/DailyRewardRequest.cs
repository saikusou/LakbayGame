using System.ComponentModel.DataAnnotations;

namespace LakbayGameApi.Models
{
    public class DailyRewardRequest
    {
        [Key]
        public int Id { get; set; }
        public int UserId { get; set; }
        public required DateTime RewardDate { get; set; }
        public int PointsAwarded { get; set; }
    }
}