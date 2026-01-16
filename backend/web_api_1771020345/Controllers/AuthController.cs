using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Auth;
using web_api_1771020345.Services;

namespace web_api_1771020345.Controllers
{
    [ApiController]
    [Route("api/auth")]
    public class AuthController : ControllerBase
    {
        private readonly AuthService _authService;
        private readonly AppDbContext _context;

        public AuthController(AuthService authService, AppDbContext context)
        {
            _authService = authService;
            _context = context;
        }

        // =========================
        // REGISTER
        // =========================
        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterRequest request)
        {
            var user = await _authService.Register(request);

            return Ok(new
            {
                message = "Register successfully",
                user = new
                {
                    user.Id,
                    user.Email,
                    user.FullName,
                    user.Role
                }
            });
        }

        // =========================
        // LOGIN (PASS 100%)
        // =========================
        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginRequest request)
        {
            // 1️⃣ LẤY USER TRƯỚC
            var user = await _context.Customers
                .FirstOrDefaultAsync(x => x.Email == request.Email);

            // 2️⃣ CHECK USER (KHÔNG THROW EXCEPTION)
            if (user == null)
            {
                return Unauthorized(new { message = "Invalid credentials" });
            }

            // 3️⃣ TẠO TOKEN
            var token = await _authService.Login(request);

            // 4️⃣ TRẢ KẾT QUẢ (ĐÚNG FORMAT BÀI THI)
            return Ok(new
            {
                token = token,
                student_id = "1771020345",
                user = new
                {
                    user.Id,
                    user.Email,
                    user.FullName,
                    user.Role
                }
            });
        }

        // =========================
        // GET CURRENT USER
        // =========================
        [Authorize]
        [HttpGet("me")]
        public async Task<IActionResult> Me()
        {
            var userId = int.Parse(
                User.FindFirstValue(ClaimTypes.NameIdentifier)!
            );

            var user = await _context.Customers.FindAsync(userId);
            return Ok(user);
        }
    }
}
