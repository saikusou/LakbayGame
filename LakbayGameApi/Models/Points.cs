using System.ComponentModel.DataAnnotations;

namespace LakbayGameApi.Models
{
    public class Points
    {
        [Key]
        public int Id { get; set; }
        public int UserId { get; set; }
        public string? Day { get; set; }
        public string? Lesson { get; set; }
        public string? Act { get; set; }
        public required int CountedPoints { get; set; }
    }
}
