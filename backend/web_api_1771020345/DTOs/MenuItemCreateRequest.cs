using System.ComponentModel.DataAnnotations;

namespace web_api_1771020345.DTOs
{
    public class MenuItemCreateRequest
    {
        [Required]
        public string Name { get; set; } = null!;

        [Required]
        public string Category { get; set; } = null!;

        [Range(1, 1000000)]
        public decimal Price { get; set; }

        [Range(1, 180)]
        public int PreparationTime { get; set; }
    }
}
