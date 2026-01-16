namespace web_api_1771020345.DTOs.Reservation
{
    public class PayReservationRequest
    {
        public string PaymentMethod { get; set; } = null!;
        public bool UseLoyaltyPoints { get; set; }
        public int LoyaltyPointsToUse { get; set; }
    }
}
