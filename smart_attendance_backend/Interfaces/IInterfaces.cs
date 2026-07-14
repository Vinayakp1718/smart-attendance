using System.Collections.Generic;
using System.Threading.Tasks;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Interfaces
{
    // --- Auth Service ---
    public interface IAuthService
    {
        Task<Employee?> LoginAsync(LoginRequest req);
    }

    // --- Employee Interfaces ---
    public interface IEmployeeRepository
    {
        Task<IEnumerable<Employee>> GetEmployeesAsync();
        Task<Employee?> GetEmployeeByIdAsync(int id);
        Task<Employee> AddEmployeeAsync(Employee emp);
        Task<Employee?> UpdateEmployeeAsync(int id, Employee emp);
        Task<bool> DeleteEmployeeAsync(int id);
        Task<Employee?> ToggleEmployeeStatusAsync(int id);
        Task<Employee?> GetEmployeeByEmailAsync(string email);

        // Lookups
        Task<IEnumerable<Department>> GetDepartmentsAsync();
        Task<Department> AddDepartmentAsync(string name, string code);
        Task<Department?> UpdateDepartmentAsync(int id, string name, string code);
        Task<bool> DeleteDepartmentAsync(int id);

        Task<IEnumerable<Designation>> GetDesignationsAsync();
        Task<Designation> AddDesignationAsync(string name, int departmentId);
        Task<Designation?> UpdateDesignationAsync(int id, string name, int departmentId);
        Task<bool> DeleteDesignationAsync(int id);

        Task<IEnumerable<Branch>> GetBranchesAsync();
        Task<Branch> AddBranchAsync(string name, string address);
        Task<Branch?> UpdateBranchAsync(int id, string name, string address);
        Task<bool> DeleteBranchAsync(int id);
    }

    public interface IEmployeeService
    {
        Task<IEnumerable<Employee>> GetEmployeesAsync();
        Task<Employee?> GetEmployeeByIdAsync(int id);
        Task<Employee> AddEmployeeAsync(Employee emp);
        Task<Employee?> UpdateEmployeeAsync(int id, Employee emp);
        Task<bool> DeleteEmployeeAsync(int id);
        Task<Employee?> ToggleEmployeeStatusAsync(int id);

        // Lookups
        Task<IEnumerable<Department>> GetDepartmentsAsync();
        Task<Department> AddDepartmentAsync(string name, string code);
        Task<Department?> UpdateDepartmentAsync(int id, string name, string code);
        Task<bool> DeleteDepartmentAsync(int id);

        Task<IEnumerable<Designation>> GetDesignationsAsync();
        Task<Designation> AddDesignationAsync(string name, int departmentId);
        Task<Designation?> UpdateDesignationAsync(int id, string name, int departmentId);
        Task<bool> DeleteDesignationAsync(int id);

        Task<IEnumerable<Branch>> GetBranchesAsync();
        Task<Branch> AddBranchAsync(string name, string address);
        Task<Branch?> UpdateBranchAsync(int id, string name, string address);
        Task<bool> DeleteBranchAsync(int id);
    }

    // --- Attendance Interfaces ---
    public interface IAttendanceRepository
    {
        Task<IEnumerable<Attendance>> GetPersonalHistoryAsync(int employeeId);
        Task<IEnumerable<Attendance>> GetAllHistoryAsync();
        Task<Attendance?> GetTodayAttendanceAsync(int employeeId);
        Task<Attendance> CheckInAsync(PunchInRequest req, string status, string todayStr);
        Task<Attendance?> CheckOutAsync(int employeeId, double workingHours, string status, string todayStr);
        Task<Attendance?> StartBreakAsync(int employeeId, string todayStr);
        Task<Attendance?> EndBreakAsync(int employeeId, string todayStr);
    }

    public interface IAttendanceService
    {
        Task<IEnumerable<Attendance>> GetPersonalHistoryAsync(int employeeId);
        Task<IEnumerable<Attendance>> GetAllHistoryAsync();
        Task<Attendance?> GetTodayAttendanceAsync(int employeeId);
        Task<Attendance> CheckInAsync(PunchInRequest req);
        Task<Attendance?> CheckOutAsync(int employeeId);
        Task<Attendance?> StartBreakAsync(int employeeId);
        Task<Attendance?> EndBreakAsync(int employeeId);
    }

    // --- Leave Interfaces ---
    public interface ILeaveRepository
    {
        Task<LeaveBalance?> GetLeaveBalanceAsync(int employeeId);
        Task SeedLeaveBalanceAsync(int employeeId);
        Task<IEnumerable<LeaveRequest>> GetPersonalRequestsAsync(int employeeId);
        Task<IEnumerable<LeaveRequest>> GetAllRequestsAsync();
        Task<LeaveRequest> ApplyLeaveAsync(ApplyLeaveRequest req);
        Task<LeaveRequest?> GetLeaveRequestByIdAsync(int leaveId);
        Task UpdateLeaveStatusAsync(int leaveId, string status);
        Task DecrementLeaveBalanceAsync(int employeeId, string column, double days);
        Task UpdateLeaveBalanceAsync(int employeeId, double sick, double casual, double paid);
    }

    public interface ILeaveService
    {
        Task<LeaveBalance> GetLeaveBalanceAsync(int employeeId);
        Task<IEnumerable<LeaveRequest>> GetPersonalRequestsAsync(int employeeId);
        Task<IEnumerable<LeaveRequest>> GetAllRequestsAsync();
        Task<LeaveRequest> ApplyLeaveAsync(ApplyLeaveRequest req);
        Task<LeaveRequest?> RecommendLeaveAsync(int leaveId);
        Task<LeaveRequest?> ApproveLeaveAsync(int leaveId);
        Task<LeaveRequest?> RejectLeaveAsync(int leaveId);
        Task<LeaveBalance?> UpdateLeaveBalanceAsync(int employeeId, double sick, double casual, double paid);
    }

    // --- Holiday Interfaces ---
    public interface IHolidayRepository
    {
        Task<IEnumerable<Holiday>> GetHolidaysAsync();
        Task<Holiday> AddHolidayAsync(Holiday hol);
        Task<bool> DeleteHolidayAsync(int id);
    }

    public interface IHolidayService
    {
        Task<IEnumerable<Holiday>> GetHolidaysAsync();
        Task<Holiday> AddHolidayAsync(Holiday hol);
        Task<bool> DeleteHolidayAsync(int id);
    }

    // --- Dashboard & Report Interfaces ---
    public interface IDashboardRepository
    {
        Task<int> GetActiveEmployeeCountAsync();
        Task<IEnumerable<string>> GetTodayAttendanceStatusesAsync(string todayStr);
        Task<int> GetPendingLeaveCountAsync();
        Task<int> GetAttendanceCountForDateAsync(string dateStr);
        Task<IEnumerable<dynamic>> GetDepartmentEmployeeCountsAsync();
        Task<IEnumerable<dynamic>> GetTodayBirthdaysAsync();
        Task<IEnumerable<dynamic>> GetTodayPresentListAsync(string todayStr);
        Task<IEnumerable<dynamic>> GetTodayAbsentListAsync(string todayStr);
    }

    public interface IDashboardService
    {
        Task<object> GetMetricsAsync();
    }

    public interface IReportRepository
    {
        Task<IEnumerable<dynamic>> GetFilteredAttendanceAsync(string? startDate, string? endDate, int? employeeId, string? department, string? status);
        Task<IEnumerable<dynamic>> GetApprovedLeavesAsync(int employeeId);
    }

    public interface IReportService
    {
        Task<IEnumerable<dynamic>> GetFilteredAttendanceAsync(string? startDate, string? endDate, int? employeeId, string? department, string? status);
        Task<IEnumerable<object>> GetPayrollSummaryAsync(int month, int year);
    }
}
