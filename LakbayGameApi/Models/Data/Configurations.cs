using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace LakbayGameApi.Models.Configurations
{
    public class LessonActivityConfiguration : IEntityTypeConfiguration<LessonActivity>
    {
        public void Configure(EntityTypeBuilder<LessonActivity> builder)
        {
            builder.HasData(
                new LessonActivity
                {
                    Id = 1,
                    Lesson = "Lesson 1",
                    Day = "Day 1",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 2,
                    Lesson = "Lesson 1",
                    Day = "Day 2",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 3,
                    Lesson = "Lesson 1",
                    Day = "Day 3",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 4,
                    Lesson = "Lesson 1",
                    Day = "Day 4",
                    TotalActivities = 1
                },

                //LESSON 2

                new LessonActivity
                {
                    Id = 5,
                    Lesson = "Lesson 2",
                    Day = "Day 1",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 6,
                    Lesson = "Lesson 2",
                    Day = "Day 2",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 7,
                    Lesson = "Lesson 2",
                    Day = "Day 3",
                    TotalActivities = 2
                },
                new LessonActivity
                {
                    Id = 8,
                    Lesson = "Lesson 2",
                    Day = "Day 4",
                    TotalActivities = 1
                },

                //LESSON 3

                new LessonActivity
                {
                    Id = 9,
                    Lesson = "Lesson 3",
                    Day = "Day 1",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 10,
                    Lesson = "Lesson 3",
                    Day = "Day 2",
                    TotalActivities = 2
                },
                new LessonActivity
                {
                    Id = 11,
                    Lesson = "Lesson 3",
                    Day = "Day 3",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 12,
                    Lesson = "Lesson 3",
                    Day = "Day 4",
                    TotalActivities = 2
                },

                //LESSON 4
                new LessonActivity
                {
                    Id = 13,
                    Lesson = "Lesson 4",
                    Day = "Day 1",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 14,
                    Lesson = "Lesson 4",
                    Day = "Day 2",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 15,
                    Lesson = "Lesson 4",
                    Day = "Day 3",
                    TotalActivities = 3
                },
                new LessonActivity
                {
                    Id = 16,
                    Lesson = "Lesson 4",
                    Day = "Day 4",
                    TotalActivities = 1
                }
            );
        }
    }
}