using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FirstApp.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddExerciseType : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "ExerciseType",
                table: "Exercises",
                type: "TEXT",
                maxLength: 32,
                nullable: false,
                defaultValue: "WeightBased");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 1,
                column: "ExerciseType",
                value: "WeightBased");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 2,
                column: "ExerciseType",
                value: "WeightBased");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 3,
                column: "ExerciseType",
                value: "BodyweightBased");

            migrationBuilder.UpdateData(
                table: "Exercises",
                keyColumn: "Id",
                keyValue: 4,
                column: "ExerciseType",
                value: "WeightBased");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ExerciseType",
                table: "Exercises");
        }
    }
}
