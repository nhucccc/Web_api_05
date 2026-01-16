using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Customer;
using web_api_1771020345.Models.DTO;

[ApiController]
[Route("api/customers")]
[Authorize] // 🔐 BẮT BUỘC
public class CustomersController : ControllerBase
{
    private readonly AppDbContext _context;

    public CustomersController(AppDbContext context)
    {
        _context = context;
    }

    // =====================================
    // 3.1 GET /api/customers (ADMIN ONLY)
    // =====================================
    [HttpGet]
    [Authorize(Roles = "admin")]
    public async Task<IActionResult> GetAll()
    {
        var customers = await _context.Customers
            .Select(x => new
            {
                x.Id,
                x.Email,
                x.FullName,
                x.PhoneNumber,
                x.Address,
                x.LoyaltyPoints,
                x.IsActive,
                x.Role
            })
            .ToListAsync();

        return Ok(customers);
    }

    // =====================================
    // 3.2 GET /api/customers/{id}
    // admin: xem bất kỳ
    // customer: chỉ xem chính mình
    // =====================================
    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(int id)
    {
        var userId = int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );
        var role = User.FindFirstValue(ClaimTypes.Role);

        if (role != "admin" && userId != id)
            return Forbid();

        var customer = await _context.Customers
            .Where(x => x.Id == id)
            .Select(x => new
            {
                x.Id,
                x.Email,
                x.FullName,
                x.PhoneNumber,
                x.Address,
                x.LoyaltyPoints,
                x.IsActive,
                x.Role
            })
            .FirstOrDefaultAsync();

        if (customer == null)
            return NotFound();

        return Ok(customer);
    }

    // =====================================
    // 3.3 PUT /api/customers/{id}
    // customer: chỉ được sửa chính mình
    // ❌ KHÔNG TRẢ ENTITY
    // =====================================
    [HttpPut("{id}")]
    public async Task<IActionResult> Update(
        int id,
        [FromBody] CustomerUpdateRequest request)
    {
        // 🔐 Lấy ID user từ JWT
        var userId = int.Parse(
            User.FindFirstValue(ClaimTypes.NameIdentifier)!
        );

        // ❌ Không cho sửa người khác
        if (userId != id)
            return Forbid();

        var customer = await _context.Customers.FindAsync(id);
        if (customer == null)
            return NotFound();

        // ✅ Chỉ cho sửa field an toàn
        customer.FullName = request.FullName;
        customer.PhoneNumber = request.PhoneNumber;
        customer.Address = request.Address;
        customer.UpdatedAt = DateTime.UtcNow;

        await _context.SaveChangesAsync();

        // 🚨 TUYỆT ĐỐI KHÔNG return customer
        return Ok(new
        {
            customer.Id,
            customer.Email,
            customer.FullName,
            customer.PhoneNumber,
            customer.Address,
            customer.LoyaltyPoints,
            customer.IsActive,
            customer.Role
        });
    }
}
