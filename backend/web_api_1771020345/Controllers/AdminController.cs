using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[ApiController]
[Route("api/admin")]
public class AdminController : ControllerBase
{
    // 🔐 CHỈ ADMIN ĐƯỢC VÀO
    [Authorize(Roles = "admin")]
    [HttpPost("menu")]
    public IActionResult CreateMenu()
    {
        return Ok("Admin tạo menu thành công");
    }

    // 🔐 CHỈ ADMIN
    [Authorize(Roles = "admin")]
    [HttpPost("table")]
    public IActionResult CreateTable()
    {
        return Ok("Admin tạo table thành công");
    }
}
