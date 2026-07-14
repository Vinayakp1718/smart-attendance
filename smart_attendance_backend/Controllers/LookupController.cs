using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LookupController : ControllerBase
    {
        private readonly IEmployeeService _employeeService;
        public LookupController(IEmployeeService employeeService) => _employeeService = employeeService;

        // --- Departments ---
        [HttpGet("departments")]
        public async Task<IActionResult> GetDepartments()
        {
            try
            {
                var list = await _employeeService.GetDepartmentsAsync();
                return Ok(list);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("departments")]
        public async Task<IActionResult> AddDepartment([FromBody] Department dept)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(dept.Name) || string.IsNullOrWhiteSpace(dept.Code))
                {
                    return BadRequest(new { message = "Department Name and Code are required." });
                }

                var created = await _employeeService.AddDepartmentAsync(dept.Name, dept.Code);
                return Created($"/api/lookup/departments/{created.Id}", created);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("departments/{id}")]
        public async Task<IActionResult> UpdateDepartment(int id, [FromBody] Department dept)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(dept.Name) || string.IsNullOrWhiteSpace(dept.Code))
                {
                    return BadRequest(new { message = "Department Name and Code are required." });
                }

                var updated = await _employeeService.UpdateDepartmentAsync(id, dept.Name, dept.Code);
                if (updated == null) return NotFound();
                return Ok(updated);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("departments/{id}")]
        public async Task<IActionResult> DeleteDepartment(int id)
        {
            try
            {
                var success = await _employeeService.DeleteDepartmentAsync(id);
                if (!success) return NotFound();
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        // --- Designations ---
        [HttpGet("designations")]
        public async Task<IActionResult> GetDesignations()
        {
            try
            {
                var list = await _employeeService.GetDesignationsAsync();
                return Ok(list);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("designations")]
        public async Task<IActionResult> AddDesignation([FromBody] Designation desig)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(desig.Name) || !int.TryParse(desig.DepartmentId, out int deptId) || deptId <= 0)
                {
                    return BadRequest(new { message = "Designation Name and Link Department ID are required." });
                }

                var created = await _employeeService.AddDesignationAsync(desig.Name, deptId);
                return Created($"/api/lookup/designations/{created.Id}", created);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("designations/{id}")]
        public async Task<IActionResult> UpdateDesignation(int id, [FromBody] Designation desig)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(desig.Name) || !int.TryParse(desig.DepartmentId, out int deptId) || deptId <= 0)
                {
                    return BadRequest(new { message = "Designation Name and Link Department ID are required." });
                }

                var updated = await _employeeService.UpdateDesignationAsync(id, desig.Name, deptId);
                if (updated == null) return NotFound();
                return Ok(updated);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("designations/{id}")]
        public async Task<IActionResult> DeleteDesignation(int id)
        {
            try
            {
                var success = await _employeeService.DeleteDesignationAsync(id);
                if (!success) return NotFound();
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        // --- Branches ---
        [HttpGet("branches")]
        public async Task<IActionResult> GetBranches()
        {
            try
            {
                var list = await _employeeService.GetBranchesAsync();
                return Ok(list);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPost("branches")]
        public async Task<IActionResult> AddBranch([FromBody] Branch branch)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(branch.Name) || string.IsNullOrWhiteSpace(branch.Address))
                {
                    return BadRequest(new { message = "Branch Name and Address are required." });
                }

                var created = await _employeeService.AddBranchAsync(branch.Name, branch.Address);
                return Created($"/api/lookup/branches/{created.Id}", created);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpPut("branches/{id}")]
        public async Task<IActionResult> UpdateBranch(int id, [FromBody] Branch branch)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(branch.Name) || string.IsNullOrWhiteSpace(branch.Address))
                {
                    return BadRequest(new { message = "Branch Name and Address are required." });
                }

                var updated = await _employeeService.UpdateBranchAsync(id, branch.Name, branch.Address);
                if (updated == null) return NotFound();
                return Ok(updated);
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }

        [HttpDelete("branches/{id}")]
        public async Task<IActionResult> DeleteBranch(int id)
        {
            try
            {
                var success = await _employeeService.DeleteBranchAsync(id);
                if (!success) return NotFound();
                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }
    }
}
