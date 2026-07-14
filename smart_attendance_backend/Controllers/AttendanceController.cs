using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AttendanceController : ControllerBase
    {
        private readonly IAttendanceService _attendanceService;
        public AttendanceController(IAttendanceService attendanceService) => _attendanceService = attendanceService;

        [HttpGet("history/{employeeId}")]
        public async Task<IActionResult> GetPersonalHistory(int employeeId)
        {
            var list = await _attendanceService.GetPersonalHistoryAsync(employeeId);
            return Ok(list);
        }

        [HttpGet("history")]
        public async Task<IActionResult> GetAllHistory()
        {
            var list = await _attendanceService.GetAllHistoryAsync();
            return Ok(list);
        }

        [HttpGet("today/{employeeId}")]
        public async Task<IActionResult> GetTodayAttendance(int employeeId)
        {
            var record = await _attendanceService.GetTodayAttendanceAsync(employeeId);
            return Ok(record);
        }

        [HttpPost("checkin")]
        public async Task<IActionResult> CheckIn([FromBody] PunchInRequest req)
        {
            try
            {
                var record = await _attendanceService.CheckInAsync(req);
                return Ok(record);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("checkout")]
        public async Task<IActionResult> CheckOut([FromBody] PunchOutRequest req)
        {
            try
            {
                var record = await _attendanceService.CheckOutAsync(req.EmployeeId);
                return Ok(record);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("break/start")]
        public async Task<IActionResult> StartBreak([FromBody] PunchOutRequest req)
        {
            try
            {
                var record = await _attendanceService.StartBreakAsync(req.EmployeeId);
                return Ok(record);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("break/end")]
        public async Task<IActionResult> EndBreak([FromBody] PunchOutRequest req)
        {
            try
            {
                var record = await _attendanceService.EndBreakAsync(req.EmployeeId);
                return Ok(record);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
