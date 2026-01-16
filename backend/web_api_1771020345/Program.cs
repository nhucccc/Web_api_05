using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using web_api_1771020345.Data;
using web_api_1771020345.Middlewares;
using web_api_1771020345.Services;

var builder = WebApplication.CreateBuilder(args);

// ================================
// 1️⃣ ADD CONTROLLERS
// ================================
builder.Services.AddControllers();
builder.Services.AddScoped<ReservationService>();

// ================================
// 2️⃣ DATABASE CONNECTION
// ================================
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// ================================
// 3️⃣ JWT AUTHENTICATION CONFIG
// ================================
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"]!))
        };
    });

// ================================
// 4️⃣ AUTHORIZATION
// ================================
builder.Services.AddAuthorization();

// ================================
// 5️⃣ DEPENDENCY INJECTION
// ================================
builder.Services.AddScoped<AuthService>();

// ================================
// 6️⃣ CORS - CHO PHÉP FLUTTER WEB
// ================================
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader();
    });
});

// ================================
// 7️⃣ SWAGGER
// ================================
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseMiddleware<ExceptionMiddleware>();

// ================================
// 8️⃣ MIDDLEWARE PIPELINE
// ================================
// Swagger LUÔN BẬT (ĐÚNG YÊU CẦU THI)
app.UseSwagger();
app.UseSwaggerUI();

// CORS - BẮT BUỘC PHẢI TRƯỚC Authentication
app.UseCors("AllowAll");

// 🔐 JWT
app.UseAuthentication(); // 🔥 BẮT BUỘC
app.UseAuthorization();

// ================================
// 9️⃣ MAP CONTROLLERS
// ================================
app.MapControllers();

app.Run();
