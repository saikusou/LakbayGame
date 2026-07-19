using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace LakbayGameApi.Migrations
{
    /// <inheritdoc />
    public partial class SeedNewData : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 5,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 6,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 7,
                column: "TotalActivities",
                value: 2);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 8,
                column: "TotalActivities",
                value: 1);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 9,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 10,
                column: "TotalActivities",
                value: 2);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 11,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 12,
                column: "TotalActivities",
                value: 2);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 13,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 14,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 15,
                column: "TotalActivities",
                value: 3);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 16,
                column: "TotalActivities",
                value: 1);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 5,
                column: "TotalActivities",
                value: 5);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 6,
                column: "TotalActivities",
                value: 6);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 7,
                column: "TotalActivities",
                value: 7);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 8,
                column: "TotalActivities",
                value: 8);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 9,
                column: "TotalActivities",
                value: 5);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 10,
                column: "TotalActivities",
                value: 6);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 11,
                column: "TotalActivities",
                value: 7);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 12,
                column: "TotalActivities",
                value: 8);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 13,
                column: "TotalActivities",
                value: 5);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 14,
                column: "TotalActivities",
                value: 6);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 15,
                column: "TotalActivities",
                value: 7);

            migrationBuilder.UpdateData(
                table: "LessonActivities",
                keyColumn: "Id",
                keyValue: 16,
                column: "TotalActivities",
                value: 8);
        }
    }
}
