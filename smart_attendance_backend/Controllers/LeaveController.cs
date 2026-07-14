using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LeaveController : ControllerBase
    {
        private readonly ILeaveService _leaveService;
        public LeaveController(ILeaveService leaveService) => _leaveService = leaveService;

        [HttpGet("balance/{employeeId}")]
        public async Task<IActionResult> GetLeaveBalance(int employeeId)
        {
            var record = await _leaveService.GetLeaveBalanceAsync(employeeId);
            return Ok(record);
        }

        [HttpGet("requests/{employeeId}")]
        public async Task<IActionResult> GetPersonalRequests(int employeeId)
        {
            var list = await _leaveService.GetPersonalRequestsAsync(employeeId);
            return Ok(list);
        }

        [HttpGet("requests")]
        public async Task<IActionResult> GetAllRequests()
        {
            var list = await _leaveService.GetAllRequestsAsync();
            return Ok(list);
        }

        [HttpPost("apply")]
        public async Task<IActionResult> ApplyLeave([FromBody] ApplyLeaveRequest req)
        {
            try
            {
                var leave = await _leaveService.ApplyLeaveAsync(req);
                return Ok(leave);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error applying for leave: {ex.Message}" });
            }
        }

        [HttpPost("{id}/recommend")]
        public async Task<IActionResult> RecommendLeave(int id)
        {
            try
            {
                var result = await _leaveService.RecommendLeaveAsync(id);
                if (result == null) return NotFound();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("{id}/approve")]
        public async Task<IActionResult> ApproveLeave(int id)
        {
            try
            {
                var result = await _leaveService.ApproveLeaveAsync(id);
                if (result == null) return NotFound();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("{id}/reject")]
        public async Task<IActionResult> RejectLeave(int id)
        {
            try
            {
                var result = await _leaveService.RejectLeaveAsync(id);
                if (result == null) return NotFound();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("balance/{employeeId}")]
        public async Task<IActionResult> UpdateLeaveBalance(int employeeId, [FromBody] LeaveBalance balance)
        {
            try
            {
                var record = await _leaveService.UpdateLeaveBalanceAsync(employeeId, balance.SickLeave, balance.CasualLeave, balance.PaidLeave);
                if (record == null) return NotFound(new { message = "Leave balance not found." });
                return Ok(record);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
