using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class HolidayController : ControllerBase
    {
        private readonly IHolidayService _holidayService;
        public HolidayController(IHolidayService holidayService) => _holidayService = holidayService;

        [HttpGet]
        public async Task<IActionResult> GetHolidays()
        {
            var list = await _holidayService.GetHolidaysAsync();
            return Ok(list);
        }

        [HttpPost]
        public async Task<IActionResult> AddHoliday([FromBody] Holiday hol)
        {
            try
            {
                var created = await _holidayService.AddHolidayAsync(hol);
                return Created($"/api/holiday/{created.HolidayId}", created);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error saving holiday: {ex.Message}" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteHoliday(int id)
        {
            var success = await _holidayService.DeleteHolidayAsync(id);
            if (!success) return NotFound();
            return NoContent();
        }
    }
}
