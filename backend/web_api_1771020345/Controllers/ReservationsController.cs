using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Reservation;
using web_api_1771020345.Models;

namespace web_api_1771020345.Controllers    
{
    [ApiController]
    [Route("api/reservations")]
    [Authorize]
    public class ReservationsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public ReservationsController(AppDbContext context)
        {
            _context = context;
        }
        [HttpPost]
        public async Task<IActionResult> Create(CreateReservationRequest request)
        {
            var userId = int.Parse(User.FindFirstValue(ClaimTypes.NameIdentifier)!);

            var todayCount = await _context.Reservations
                .CountAsync(r => r.CreatedAt.Date == DateTime.UtcNow.Date);

            var reservation = new Reservation
            {
                CustomerId = userId,
                ReservationDate = request.ReservationDate,
                NumberOfGuests = request.NumberOfGuests,
                SpecialRequests = request.SpecialRequests,
                ReservationNumber = $"RES-{DateTime.UtcNow:yyyyMMdd}-{(todayCount + 1).ToString("D3")}",
                Status = "pending"
            };

            _context.Reservations.Add(reservation);
            await _context.SaveChangesAsync();

            return Ok(reservation);
        }
        [HttpPost("{id}/items")]
        public async Task<IActionResult> AddItem(int id, AddReservationItemRequest request)
        {
            var reservation = await _context.Reservations
                .Include(r => r.ReservationItems)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (reservation == null)
                return NotFound();

            if (reservation.Status != "pending")
                return BadRequest("Cannot add items");

            var menuItem = await _context.MenuItems.FindAsync(request.MenuItemId);
            if (menuItem == null || !menuItem.IsAvailable)
                return BadRequest("Menu item not available");

            var item = new ReservationItem
            {
                ReservationId = id,
                MenuItemId = menuItem.Id,
                Quantity = request.Quantity,
                Price = menuItem.Price
            };

            _context.ReservationItems.Add(item);

            reservation.Subtotal += item.Price * item.Quantity;
            reservation.ServiceCharge = reservation.Subtotal * 0.1m;
            reservation.Total = reservation.Subtotal + reservation.ServiceCharge;

            await _context.SaveChangesAsync();
            return Ok(reservation);
        }
        [Authorize(Roles = "admin")]
        [HttpPut("{id}/confirm")]
        public async Task<IActionResult> Confirm(int id, ConfirmReservationRequest request)
        {
            var reservation = await _context.Reservations.FindAsync(id);
            if (reservation == null)
                return NotFound();

            var table = await _context.Tables
                .FirstOrDefaultAsync(t => t.TableNumber == request.TableNumber);

            if (table == null || !table.IsAvailable || table.Capacity < reservation.NumberOfGuests)
                return BadRequest("Table not available");

            reservation.TableNumber = table.TableNumber;
            reservation.Status = "confirmed";
            table.IsAvailable = false;

            await _context.SaveChangesAsync();
            return Ok(reservation);
        }
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var reservation = await _context.Reservations
                .Include(r => r.ReservationItems)
                .ThenInclude(ri => ri.MenuItem)
                .FirstOrDefaultAsync(r => r.Id == id);

            if (reservation == null)
                return NotFound();

            return Ok(reservation);
        }
        [HttpGet("/api/customers/{id}/reservations")]
        public async Task<IActionResult> GetByCustomer(
            int id,
            int page = 1,
            int limit = 10,
            string? status = null)
        {
            var query = _context.Reservations
                .Where(r => r.CustomerId == id);

            if (!string.IsNullOrEmpty(status))
                query = query.Where(r => r.Status == status);

            var data = await query
                .Include(r => r.ReservationItems)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToListAsync();

            return Ok(data);
        }
        [HttpPost("{id}/pay")]
        public async Task<IActionResult> Pay(int id, PayReservationRequest request)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();

            try
            {
                var reservation = await _context.Reservations.FindAsync(id);
                if (reservation == null || reservation.Status != "seated")
                    return BadRequest("Invalid reservation");

                var customer = await _context.Customers.FindAsync(reservation.CustomerId);

                decimal discount = 0;
                if (request.UseLoyaltyPoints)
                {
                    discount = request.LoyaltyPointsToUse * 1000;
                    discount = Math.Min(discount, reservation.Total * 0.5m);
                    customer!.LoyaltyPoints -= request.LoyaltyPointsToUse;
                }

                reservation.Discount = discount;
                reservation.Total -= discount;
                reservation.PaymentMethod = request.PaymentMethod;
                reservation.PaymentStatus = "paid";
                reservation.Status = "completed";

                customer!.LoyaltyPoints += (int)(reservation.Total * 0.01m);

                var table = await _context.Tables
                    .FirstAsync(t => t.TableNumber == reservation.TableNumber);
                table.IsAvailable = true;

                await _context.SaveChangesAsync();
                await transaction.CommitAsync();

                return Ok(reservation);
            }
            catch
            {
                await transaction.RollbackAsync();
                throw;
            }
        }
        [HttpDelete("{id}")]
        public async Task<IActionResult> Cancel(int id)
        {
            var reservation = await _context.Reservations.FindAsync(id);
            if (reservation == null)
                return NotFound();

            if (reservation.Status == "confirmed")
            {
                var table = await _context.Tables
                    .FirstAsync(t => t.TableNumber == reservation.TableNumber);
                table.IsAvailable = true;
            }

            reservation.Status = "cancelled";
            await _context.SaveChangesAsync();

            return Ok("Cancelled");
        }
    }
}

