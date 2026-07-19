using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace LakbayGameApi.Migrations
{
    /// <inheritdoc />
    public partial class SeedLessonActivities : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "LessonActivities",
                columns: new[] { "Id", "Day", "Lesson", "TotalActivities" },
                values: new object[,]
                {
                    { 1, "Day 1", "Lesson 1", 3 },
                    { 2, "Day 2", "Lesson 1", 3 },
                    { 3, "Day 3", "Lesson 1", 3 },
                    { 4, "Day 4", "Lesson 1", 1 },
                    { 5, "Day 1", "Lesson 2", 5 },
                    { 6, "Day 2", "Lesson 2", 6 },
                    { 7, "Day 3", "Lesson 2", 7 },
                    { 8, "Day 4", "Lesson 2", 8 },
                    { 9, "Day 1", "Lesson 3", 5 },
                    { 10, "Day 2", "Lesson 3", 6 },
                    { 11, "Day 3", "Lesson 3", 7 },
                    { 12, "Day 4", "Lesson 3", 8 },
                    { 13, "Day 1", "Lesson 4", 5 },
                    { 14, "Day 2", "Lesson 4", 6 },
                    { 15, "Day 3", "Lesson 4", 7 },
                    { 16, "Day 4", "Lesson 4", 8 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 16);
        }
    }
}
