using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FirstApp.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddRepsToWorkoutSet : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "Reps",
                table: "WorkoutSets",
                type: "INTEGER",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 1,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.mp4");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 2,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.mp4");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 3,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.mp4");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Reps",
                table: "WorkoutSets");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 1,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.jpg");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 2,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.jpg");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 3,
                column: "VideoUrl",
                value: "/exercises/Videos/Video1.jpg");
        }
    }
}
