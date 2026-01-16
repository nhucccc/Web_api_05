namespace web_api_1771020345.Models;

public class Reservation
{
    public int Id { get; set; }

    public int CustomerId { get; set; }
    public Customer Customer { get; set; } = null!;

    public string ReservationNumber { get; set; } = null!;
    public DateTime ReservationDate { get; set; }
    public int NumberOfGuests { get; set; }
    public string? TableNumber { get; set; }
    public string Status { get; set; } = "pending";
    public string? SpecialRequests { get; set; }

    public decimal Subtotal { get; set; } = 0;
    public decimal ServiceCharge { get; set; } = 0;
    public decimal Discount { get; set; } = 0;
    public decimal Total { get; set; } = 0;

    public string? PaymentMethod { get; set; }
    public string PaymentStatus { get; set; } = "pending";

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public ICollection<ReservationItem> ReservationItems { get; set; } = new List<ReservationItem>();
}
