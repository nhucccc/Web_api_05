using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Table;
using web_api_1771020345.Models;

namespace web_api_1771020345.Controllers
{
    [ApiController]
    [Route("api/tables")]
    public class TablesController : ControllerBase
    {
        private readonly AppDbContext _context;

        public TablesController(AppDbContext context)
        {
            _context = context;
        }

        // ✅ 6.1 GET /api/tables (KHÔNG LOGIN)
        [HttpGet]
        public async Task<IActionResult> GetAll(bool? available_only = null)
        {
            var query = _context.Tables.AsQueryable();

            if (available_only == true)
            {
                query = query.Where(t => t.IsAvailable);
            }

            return Ok(await query.ToListAsync());
        }

        // ✅ 6.2 POST /api/tables (ADMIN)
        [Authorize(Roles = "admin")]
        [HttpPost]
        public async Task<IActionResult> Create(TableCreateRequest request)
        {
            // ❗ CHECK UNIQUE TABLE NUMBER
            if (await _context.Tables.AnyAsync(t => t.TableNumber == request.TableNumber))
                return BadRequest("Table number already exists");

            var table = new Table
            {
                TableNumber = request.TableNumber,
                Capacity = request.Capacity
            };

            _context.Tables.Add(table);
            await _context.SaveChangesAsync();

            return Ok(table);
        }

        // ✅ 6.3 PUT /api/tables/{id} (ADMIN)
        [Authorize(Roles = "admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, TableCreateRequest request)
        {
            var table = await _context.Tables.FindAsync(id);
            if (table == null) return NotFound();

            // ❗ CHECK TRÙNG SỐ BÀN
            if (await _context.Tables.AnyAsync(t => t.TableNumber == request.TableNumber && t.Id != id))
                return BadRequest("Table number already exists");

            table.TableNumber = request.TableNumber;
            table.Capacity = request.Capacity;
            table.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();
            return Ok(table);
        }

        // ✅ 6.4 DELETE /api/tables/{id} (ADMIN)
        [Authorize(Roles = "admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var table = await _context.Tables.FindAsync(id);
            if (table == null) return NotFound();

            // ❗ KHÔNG ĐƯỢC XÓA TABLE ĐANG DÙNG
            if (!table.IsAvailable)
                return BadRequest("Table is currently in use");

            _context.Tables.Remove(table);
            await _context.SaveChangesAsync();

            return Ok("Deleted");
        }
    }
}
