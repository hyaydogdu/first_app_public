using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace FirstApp.Api.Migrations
{
    /// <inheritdoc />
    public partial class AddWeeklyPlan : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "WeeklyPlans",
                columns: table => new
                {
                    Id = table.Column<int>(type: "INTEGER", nullable: false),
                    Name = table.Column<string>(type: "TEXT", nullable: false),
                    Description = table.Column<string>(type: "TEXT", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "TEXT", nullable: false),
                    Week_MondayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_TuesdayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_WednesdayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_ThursdayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_FridayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_SaturdayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true),
                    Week_SundayWorkoutId = table.Column<int>(type: "INTEGER", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_WeeklyPlans", x => x.Id);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_FridayWorkoutId",
                        column: x => x.Week_FridayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_MondayWorkoutId",
                        column: x => x.Week_MondayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_SaturdayWorkoutId",
                        column: x => x.Week_SaturdayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_SundayWorkoutId",
                        column: x => x.Week_SundayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_ThursdayWorkoutId",
                        column: x => x.Week_ThursdayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_TuesdayWorkoutId",
                        column: x => x.Week_TuesdayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_WeeklyPlans_Workouts_Week_WednesdayWorkoutId",
                        column: x => x.Week_WednesdayWorkoutId,
                        principalTable: "Workouts",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                });

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_FridayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_FridayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_MondayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_MondayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_SaturdayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_SaturdayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_SundayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_SundayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_ThursdayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_ThursdayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_TuesdayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_TuesdayWorkoutId");

            migrationBuilder.CreateIndex(
                name: "IX_WeeklyPlans_Week_WednesdayWorkoutId",
                table: "WeeklyPlans",
                column: "Week_WednesdayWorkoutId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "WeeklyPlans");
        }
    }
}
