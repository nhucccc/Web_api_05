namespace web_api_1771020345.DTOs.Menu
{
    public class MenuItemCreateRequest
    {
        public string Name { get; set; } = null!;
        public string? Description { get; set; }
        public string Category { get; set; } = null!;
        public decimal Price { get; set; }
        public int PreparationTime { get; set; }
        public bool IsVegetarian { get; set; }
        public bool IsSpicy { get; set; }
        public bool IsAvailable { get; set; }
        public string? ImageUrl { get; set; }
    }
}
