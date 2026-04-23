using FirstApp.Api.Models;
using Microsoft.EntityFrameworkCore;

namespace FirstApp.Api.Data;

public class AppDbContext : DbContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<WeeklyPlan> WeeklyPlans { get; set; }
    public DbSet<Workout> Workouts { get; set; }
    public DbSet<WorkoutSet> WorkoutSets { get; set; }
    public DbSet<WorkoutExercise> WorkoutExercises { get; set; }
    public DbSet<Exercise> Exercises { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        modelBuilder.Entity<WeeklyPlan>()
            .OwnsOne(wp => wp.Week, week =>
            {
                week.WithOwner();

                week.HasOne(w => w.Monday)
                    .WithMany()
                    .HasForeignKey(w => w.MondayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Tuesday)
                    .WithMany()
                    .HasForeignKey(w => w.TuesdayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Wednesday)
                    .WithMany()
                    .HasForeignKey(w => w.WednesdayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Thursday)
                    .WithMany()
                    .HasForeignKey(w => w.ThursdayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Friday)
                    .WithMany()
                    .HasForeignKey(w => w.FridayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Saturday)
                    .WithMany()
                    .HasForeignKey(w => w.SaturdayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);

                week.HasOne(w => w.Sunday)
                    .WithMany()
                    .HasForeignKey(w => w.SundayWorkoutId)
                    .OnDelete(DeleteBehavior.SetNull);
            });

        // Workout -> WorkoutExercises (1 - many)
        modelBuilder.Entity<Workout>()
            .HasMany(w => w.WorkoutExercises)
            .WithOne(we => we.Workout)
            .HasForeignKey(we => we.WorkoutId)
            .OnDelete(DeleteBehavior.Cascade);

        // Exercise -> WorkoutExercises (1 - many)
        modelBuilder.Entity<WorkoutExercise>()
            .HasOne(we => we.Exercise)
            .WithMany()
            .HasForeignKey(we => we.ExerciseId)
            .OnDelete(DeleteBehavior.Restrict);

        // WorkoutExercise -> WorkoutSets (1 - many)
        modelBuilder.Entity<WorkoutExercise>()
            .HasMany(we => we.Sets)
            .WithOne(s => s.WorkoutExercise)
            .HasForeignKey(s => s.WorkoutExerciseId)
            .OnDelete(DeleteBehavior.Cascade);

        // ⭐ Opsiyonel ama çok iyi
        modelBuilder.Entity<WorkoutSet>()
            .HasIndex(s => new { s.WorkoutExerciseId, s.SetIndex })
            .IsUnique();

        // Seed initial data for Exercises
        modelBuilder.Entity<Exercise>().HasData(
            new Exercise { Id = 1, Name = "Bench Press", Notes = "Chest", ImageUrl = "/exercises/Photos/foto1.jpg", VideoUrl = "/exercises/Videos/Video1.mp4" },
            new Exercise { Id = 2, Name = "Skull Crusher", Notes = "Triceps", ImageUrl = "/exercises/Photos/foto2.jpg", VideoUrl = "/exercises/Videos/Video1.mp4" },
            new Exercise { Id = 3, Name = "Pull Up", Notes = "Back", ImageUrl = "/exercises/Photos/foto3.jpg", VideoUrl = "/exercises/Videos/Video1.mp4" }
        );
    }
}

