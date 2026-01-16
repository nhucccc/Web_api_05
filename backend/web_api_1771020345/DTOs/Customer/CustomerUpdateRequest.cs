namespace web_api_1771020345.DTOs.Customer
{
    public class CustomerUpdateRequest
    {
        public string FullName { get; set; } = null!;
        public string? PhoneNumber { get; set; }
        public string? Address { get; set; }
    }
}
