using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly IReportService _reportService;
        public ReportController(IReportService reportService) => _reportService = reportService;

        [HttpGet("attendance")]
        public async Task<IActionResult> GetFilteredAttendance(
            [FromQuery] string? startDate,
            [FromQuery] string? endDate,
            [FromQuery] int? employeeId,
            [FromQuery] string? department,
            [FromQuery] string? status)
        {
            try
            {
                var results = await _reportService.GetFilteredAttendanceAsync(startDate, endDate, employeeId, department, status);
                return Ok(results);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error compiling report: {ex.Message}" });
            }
        }

        [HttpGet("payroll")]
        public async Task<IActionResult> GetPayrollSummary([FromQuery] int month, [FromQuery] int year)
        {
            try
            {
                var results = await _reportService.GetPayrollSummaryAsync(month, year);
                return Ok(results);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error compiling payroll: {ex.Message}" });
            }
        }
    }
}
