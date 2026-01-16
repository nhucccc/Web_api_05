namespace web_api_1771020345.Models;

public class ReservationItem
{
    public int Id { get; set; }

    public int ReservationId { get; set; }
    public Reservation Reservation { get; set; } = null!;

    public int MenuItemId { get; set; }
    public MenuItem MenuItem { get; set; } = null!;

    public int Quantity { get; set; }
    public decimal Price { get; set; }
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
