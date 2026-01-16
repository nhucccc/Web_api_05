using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Menu;
using web_api_1771020345.Models;

namespace web_api_1771020345.Controllers
{
    [ApiController]
    [Route("api/menu-items")]
    public class MenuItemsController : ControllerBase
    {
        private readonly AppDbContext _context;

        public MenuItemsController(AppDbContext context)
        {
            _context = context;
        }

        // =========================================================
        // GET /api/menu-items (LOGIN REQUIRED – ADMIN + CUSTOMER)
        // =========================================================
        [Authorize]
        [HttpGet]
        public async Task<IActionResult> GetAll(
            [FromQuery] int page = 1,
            [FromQuery] int limit = 100)
        {
            var totalItems = await _context.MenuItems.CountAsync();

            var items = await _context.MenuItems
                .OrderBy(x => x.Id)
                .Skip((page - 1) * limit)
                .Take(limit)
                .ToListAsync();

            return Ok(new
            {
                page = page,
                limit = limit,
                total = totalItems,
                data = items
            });
        }

        // =========================================================
        // GET /api/menu-items/{id} (LOGIN REQUIRED)
        // =========================================================
        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(int id)
        {
            var item = await _context.MenuItems.FindAsync(id);
            if (item == null)
                return NotFound();

            return Ok(item);
        }

        // =========================================================
        // POST /api/menu-items (ADMIN ONLY)
        // =========================================================
        [Authorize(Roles = "Admin")]
        [HttpPost]
        public async Task<IActionResult> Create(MenuItemCreateRequest request)
        {
            var item = new MenuItem
            {
                Name = request.Name,
                Description = request.Description,
                Category = request.Category,
                Price = request.Price,
                PreparationTime = request.PreparationTime,
                IsVegetarian = request.IsVegetarian,
                IsSpicy = request.IsSpicy,
                IsAvailable = request.IsAvailable,
                ImageUrl = request.ImageUrl,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.MenuItems.Add(item);
            await _context.SaveChangesAsync();

            return Ok(item);
        }

        // =========================================================
        // PUT /api/menu-items/{id} (ADMIN ONLY)
        // =========================================================
        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public async Task<IActionResult> Update(int id, MenuItemCreateRequest request)
        {
            var item = await _context.MenuItems.FindAsync(id);
            if (item == null)
                return NotFound();

            item.Name = request.Name;
            item.Description = request.Description;
            item.Category = request.Category;
            item.Price = request.Price;
            item.PreparationTime = request.PreparationTime;
            item.IsVegetarian = request.IsVegetarian;
            item.IsSpicy = request.IsSpicy;
            item.IsAvailable = request.IsAvailable;
            item.ImageUrl = request.ImageUrl;
            item.UpdatedAt = DateTime.UtcNow;

            await _context.SaveChangesAsync();

            return Ok(item);
        }

        // =========================================================
        // DELETE /api/menu-items/{id} (ADMIN ONLY)
        // =========================================================
        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            var item = await _context.MenuItems.FindAsync(id);
            if (item == null)
                return NotFound();

            _context.MenuItems.Remove(item);
            await _context.SaveChangesAsync();

            return Ok("Deleted successfully");
        }
    }
}
