using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class DashboardController : ControllerBase
    {
        private readonly IDashboardService _dashboardService;
        public DashboardController(IDashboardService dashboardService) => _dashboardService = dashboardService;

        [HttpGet("metrics")]
        public async Task<IActionResult> GetMetrics()
        {
            try
            {
                var metrics = await _dashboardService.GetMetricsAsync();
                return Ok(metrics);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error generating metrics: {ex.Message}" });
            }
        }
    }
}
