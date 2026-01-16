using web_api_1771020345.Data;
using web_api_1771020345.Models;

namespace web_api_1771020345.Services
{
    public class ReservationService
    {
        private readonly AppDbContext _context;

        public ReservationService(AppDbContext context)
        {
            _context = context;
        }

        public async Task CreateReservationAsync(
            Reservation reservation,
            List<ReservationItem> items)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                // BƯỚC 1: Lưu Reservation
                _context.Reservations.Add(reservation);
                await _context.SaveChangesAsync();

                // BƯỚC 2: Gán ReservationId cho từng item
                foreach (var item in items)
                {
                    item.ReservationId = reservation.Id;
                }

                // BƯỚC 3: Lưu ReservationItems
                _context.ReservationItems.AddRange(items);
                await _context.SaveChangesAsync();

                // BƯỚC 4: Commit
                await transaction.CommitAsync();
            }
            catch
            {
                // BƯỚC 5: Rollback nếu có lỗi
                await transaction.RollbackAsync();
                throw;
            }
        }
    }
}
