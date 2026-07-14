using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class EmployeeController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;
        public EmployeeController(IEmployeeService employeeService) => _employeeService = employeeService;

        [HttpGet]
        public async Task<IActionResult> GetEmployees()
        {
            var list = await _employeeService.GetEmployeesAsync();
            return Ok(list);
        }

        [HttpPost]
        public async Task<IActionResult> AddEmployee([FromBody] Employee emp)
        {
            try
            {
                var created = await _employeeService.AddEmployeeAsync(emp);
                return Created($"/api/employee/{created.EmployeeId}", created);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error adding employee: {ex.Message}" });
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateEmployee(int id, [FromBody] Employee emp)
        {
            try
            {
                var updated = await _employeeService.UpdateEmployeeAsync(id, emp);
                if (updated == null) return NotFound();
                return Ok(updated);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error updating employee: {ex.Message}" });
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteEmployee(int id)
        {
            var success = await _employeeService.DeleteEmployeeAsync(id);
            if (!success) return NotFound();
            return NoContent();
        }

        [HttpPost("{id}/toggle-status")]
        public async Task<IActionResult> ToggleEmployeeStatus(int id)
        {
            try
            {
                var result = await _employeeService.ToggleEmployeeStatusAsync(id);
                if (result == null) return NotFound();
                return Ok(result);
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Error toggling status: {ex.Message}" });
            }
        }
    }
}
