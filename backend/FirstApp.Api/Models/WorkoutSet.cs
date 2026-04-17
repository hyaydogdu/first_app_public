namespace FirstApp.Api.Models
{
    public class WorkoutSet
    {
        public int Id { get; set; }

        public int WorkoutExerciseId { get; set; }
        public WorkoutExercise WorkoutExercise { get; set; } = null!;

        public int SetIndex { get; set; }     // 1,2,3...
        public float WeightKg { get; set; }   // +60, 0, -20
        public int Reps { get; set; } // 4, 10
        public int RestSeconds { get; set; }  // Egzersiz bittikten sonra dinlenme (saniye)
    }
}
