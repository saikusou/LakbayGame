namespace LakbayGameApi.Models
{
    public class Points
    {
        public int UserId { get; set; }
        public required string CountedPoints { get; set; }

        public required string DateLastClaimed { get; set; }
    }
}
