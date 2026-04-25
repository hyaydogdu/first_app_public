using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FirstApp.Api.Migrations
{
    public partial class AddDefaultKeyToDefaults : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "DefaultKey",
                table: "WeeklyPlans",
                type: "TEXT",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DefaultKey",
                table: "Workouts",
                type: "TEXT",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_DefaultKey",
                table: "WeeklyPlans",
                column: "DefaultKey",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Workouts_DefaultKey",
                table: "Workouts",
                column: "DefaultKey",
                unique: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_WeeklyPlans_DefaultKey",
                table: "WeeklyPlans");

            migrationBuilder.DropIndex(
                name: "IX_Workouts_DefaultKey",
                table: "Workouts");

            migrationBuilder.DropColumn(
                name: "DefaultKey",
                table: "WeeklyPlans");

            migrationBuilder.DropColumn(
                name: "DefaultKey",
                table: "Workouts");
        }
    }
}
