using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FirstApp.Api.Migrations
{
    public partial class AddIsDefaultToWeeklyPlansAndWorkouts : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "isDefault",
                table: "WeeklyPlans",
                type: "INTEGER",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<bool>(
                name: "isDefault",
                table: "Workouts",
                type: "INTEGER",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "isDefault",
                table: "WeeklyPlans");

            migrationBuilder.DropColumn(
                name: "isDefault",
                table: "Workouts");
        }
    }
}
