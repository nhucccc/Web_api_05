using System.ComponentModel.DataAnnotations;
namespace web_api_1771020345.Models;

public class MenuItem
{
    [Key]
    public int Id { get; set; }
    [Required]
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    [Required]
    public string Category { get; set; } = null!;
    [Required]
    public decimal Price { get; set; }
    public string? ImageUrl { get; set; }
    public int PreparationTime { get; set; }
    public bool IsVegetarian { get; set; } = false;
    public bool IsSpicy { get; set; } = false;
    public bool IsAvailable { get; set; } = true;
    public decimal Rating { get; set; } = 0;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
