namespace web_api_1771020345.DTOs.Reservation
{
    public class CreateReservationRequest
    {
        public DateTime ReservationDate { get; set; }
        public int NumberOfGuests { get; set; }
        public string? SpecialRequests { get; set; }
    }
}
