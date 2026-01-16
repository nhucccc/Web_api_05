using System.ComponentModel.DataAnnotations;

namespace web_api_1771020345.Models;

public class Table
{
    public int Id { get; set; }
    public string TableNumber { get; set; } = null!;
    public int Capacity { get; set; }
    public bool IsAvailable { get; set; } = true;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;
}
