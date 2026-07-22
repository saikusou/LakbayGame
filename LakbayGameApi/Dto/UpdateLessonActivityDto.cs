namespace LakbayGameApi.Dto
{
    public class UpdateLessonActivityDto
    {
        public string Lesson { get; set; } = string.Empty;

        public string Day { get; set; } = string.Empty;

        public int TotalActivities { get; set; }
    }
}
