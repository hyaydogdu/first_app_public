namespace FirstApp.Api.Dtos
{
    public class UpdateWorkoutExercisesRequest
    {
        public List<UpdateWorkoutExerciseRequest> WorkoutExercises { get; set; }
            = new();
    }

    public class UpdateWorkoutExerciseRequest
    {
        // public int? Id { get; set; } // null → yeni kayıt 
        public int ExerciseId { get; set; }
        public int OrderIndex { get; set; }
        public List<UpdateWorkoutSetRequest> Sets { get; set; } = new();
    }

    public class UpdateWorkoutSetRequest
    {
        public int SetIndex { get; set; }
        public float WeightKg { get; set; }
        public int Reps { get; set; }
        public int RestSeconds { get; set; }
    }
}

