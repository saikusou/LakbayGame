namespace LakbayGameApi.Models
{
    public class LessonActivity
    {
        public int Id { get; set; }

        public string Lesson { get; set; } = string.Empty;

        public string Day { get; set; } = string.Empty;

        public int TotalActivities { get; set; }
    }
}