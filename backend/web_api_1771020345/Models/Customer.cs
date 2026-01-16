namespace web_api_1771020345.Models;

public class Customer
{
	public int Id { get; set; }
	public string Email { get; set; } = null!;
	public string Password { get; set; } = null!;
	public string FullName { get; set; } = null!;
	public string? PhoneNumber { get; set; }
	public string? Address { get; set; }
	public int LoyaltyPoints { get; set; } = 0;
	public bool IsActive { get; set; } = true;
	public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
	public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    // ⭐ BẮT BUỘC
    public string Role { get; set; } = "customer"; // admin | customer
}
