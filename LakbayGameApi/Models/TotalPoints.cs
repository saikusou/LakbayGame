using System.ComponentModel.DataAnnotations;

namespace LakbayGameApi.Models
{
    public class TotalPoints
    {
        [Key]
        public int Id { get; set; }
        public int UserId { get; set; }
        public required int TotalCountedPoints { get; set; }
    }
}