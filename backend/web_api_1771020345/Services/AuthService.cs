using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using web_api_1771020345.Data;
using web_api_1771020345.DTOs.Auth;
using web_api_1771020345.Models;
using web_api_1771020345.Models.DTO;

namespace web_api_1771020345.Services
{
    public class AuthService
    {
        private readonly AppDbContext _context;
        private readonly IConfiguration _config;

        public AuthService(AppDbContext context, IConfiguration config)
        {
            _context = context;
            _config = config;
        }

        // =========================
        // REGISTER
        // =========================
        public async Task<AuthResponse> Register(RegisterRequest request)
        {
            if (await _context.Customers.AnyAsync(x => x.Email == request.Email))
                throw new Exception("Email already exists");

            var customer = new Customer
            {
                Email = request.Email,
                Password = BCrypt.Net.BCrypt.HashPassword(request.Password),
                FullName = request.FullName,
                PhoneNumber = request.PhoneNumber,
                Address = request.Address,
                Role = "customer",
                IsActive = true,
                CreatedAt = DateTime.UtcNow,
                UpdatedAt = DateTime.UtcNow
            };

            _context.Customers.Add(customer);
            await _context.SaveChangesAsync();

            return new AuthResponse
            {
                Id = customer.Id,
                Email = customer.Email,
                FullName = customer.FullName,
                Role = customer.Role
            };
        }


        // =========================
        // LOGIN
        // =========================
        public async Task<string> Login(LoginRequest request)
        {
            var user = await _context.Customers
                .FirstOrDefaultAsync(x => x.Email == request.Email);

            if (user == null)
                throw new Exception("Invalid credentials");

            if (user.Role == "Admin")
            {
                if (request.Password != user.Password)
                    throw new Exception("Invalid password");
            }
            else
            {
                if (!BCrypt.Net.BCrypt.Verify(request.Password, user.Password))
                    throw new Exception("Invalid password");
            }


            var jwtKey = _config["Jwt:Key"];
            var issuer = _config["Jwt:Issuer"];
            var audience = _config["Jwt:Audience"];
            var expireMinutes = _config["Jwt:ExpireMinutes"];

            if (jwtKey == null || issuer == null || audience == null || expireMinutes == null)
                throw new Exception("JWT configuration is missing");

            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, user.Role)
            };

            var key = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(jwtKey)
            );

            var token = new JwtSecurityToken(
                issuer: issuer,
                audience: audience,
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(int.Parse(expireMinutes)),
                signingCredentials: new SigningCredentials(
                    key, SecurityAlgorithms.HmacSha256
                )
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }
    }
}
