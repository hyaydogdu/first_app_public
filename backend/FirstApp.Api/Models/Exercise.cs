namespace FirstApp.Api.Models
{
    public class Exercise
    {
        public int Id { get; set; }          // Unique ID (save için)
        public string Name { get; set; } = null!;
        public string? Notes { get; set; }

        // Media (LOCAL + FUTURE CLOUD UYUMLU)
        public string? VideoUrl { get; set; }
        public string? ImageUrl { get; set; }
    }
}
