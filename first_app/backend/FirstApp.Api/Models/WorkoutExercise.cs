namespace FirstApp.Api.Models
{
    public class WorkoutExercise
    {
        public int Id { get; set; }

        // Workout içindeki sırası
        public int OrderIndex { get; set; }

        // 🔑 HANGİ WORKOUT'a ait olduğu
        public int WorkoutId { get; set; }
        public Workout Workout { get; set; } = null!;

        // Hangi exercise
        public int ExerciseId { get; set; }
        public Exercise Exercise { get; set; } = null!;

        // Setler
        public ICollection<WorkoutSet> Sets { get; set; } = new List<WorkoutSet>();

    }
}
