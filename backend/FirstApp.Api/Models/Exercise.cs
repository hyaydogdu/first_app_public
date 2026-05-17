namespace FirstApp.Api.Models
{
    public enum ExerciseType
    {
        BodyweightBased = 0,
        WeightBased = 1
    }

    public class Exercise
    {
        public int Id { get; set; }
        public string Name { get; set; } = null!;
        public string? Notes { get; set; }
        public ExerciseType ExerciseType { get; set; } = ExerciseType.WeightBased;

        public string? VideoUrl { get; set; }
        public string? ImageUrl { get; set; }
    }
}
