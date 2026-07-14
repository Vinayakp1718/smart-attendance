using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Services
{
    // =========================================================================
    // AUTH SERVICE
    // =========================================================================
    public class AuthService : IAuthService
    {
        private readonly IEmployeeRepository _employeeRepo;
        public AuthService(IEmployeeRepository employeeRepo) => _employeeRepo = employeeRepo;

        public async Task<Employee?> LoginAsync(LoginRequest req)
        {
            var emp = await _employeeRepo.GetEmployeeByEmailAsync(req.Email);
            if (emp == null) return null;
            if (emp.PasswordHash != req.Password) throw new Exception("Invalid password!");
            if (!emp.Status) throw new Exception("Your account is deactivated. Contact Admin.");
            return emp;
        }
    }

    // =========================================================================
    // EMPLOYEE SERVICE
    // =========================================================================
    public class EmployeeService : IEmployeeService
    {
        private readonly IEmployeeRepository _repo;
        private readonly ILeaveRepository _leaveRepo;

        public EmployeeService(IEmployeeRepository repo, ILeaveRepository leaveRepo)
        {
            _repo = repo;
            _leaveRepo = leaveRepo;
        }

        public async Task<IEnumerable<Employee>> GetEmployeesAsync() => await _repo.GetEmployeesAsync();
        public async Task<Employee?> GetEmployeeByIdAsync(int id) => await _repo.GetEmployeeByIdAsync(id);

        public async Task<Employee> AddEmployeeAsync(Employee emp)
        {
            var list = await _repo.GetEmployeesAsync();
            var maxId = list.Any() ? list.Max(e => e.EmployeeId) : 0;
            var nextId = maxId + 1;

            emp.EmployeeCode = "EMP" + nextId.ToString().PadLeft(4, '0');
            emp.CreatedDate = DateTime.Now;
            emp.Status = true;
            emp.PasswordHash = "Password123"; // Default

            var created = await _repo.AddEmployeeAsync(emp);

            // Seed Leave Balance
            await _leaveRepo.SeedLeaveBalanceAsync(created.EmployeeId);

            return created;
        }

        public async Task<Employee?> UpdateEmployeeAsync(int id, Employee emp) => await _repo.UpdateEmployeeAsync(id, emp);
        public async Task<bool> DeleteEmployeeAsync(int id) => await _repo.DeleteEmployeeAsync(id);
        public async Task<Employee?> ToggleEmployeeStatusAsync(int id) => await _repo.ToggleEmployeeStatusAsync(id);

        // --- Lookups ---
        public async Task<IEnumerable<Department>> GetDepartmentsAsync() => await _repo.GetDepartmentsAsync();
        public async Task<Department> AddDepartmentAsync(string name, string code) => await _repo.AddDepartmentAsync(name, code);
        public async Task<Department?> UpdateDepartmentAsync(int id, string name, string code) => await _repo.UpdateDepartmentAsync(id, name, code);
        public async Task<bool> DeleteDepartmentAsync(int id) => await _repo.DeleteDepartmentAsync(id);

        public async Task<IEnumerable<Designation>> GetDesignationsAsync() => await _repo.GetDesignationsAsync();
        public async Task<Designation> AddDesignationAsync(string name, int departmentId) => await _repo.AddDesignationAsync(name, departmentId);
        public async Task<Designation?> UpdateDesignationAsync(int id, string name, int departmentId) => await _repo.UpdateDesignationAsync(id, name, departmentId);
        public async Task<bool> DeleteDesignationAsync(int id) => await _repo.DeleteDesignationAsync(id);

        public async Task<IEnumerable<Branch>> GetBranchesAsync() => await _repo.GetBranchesAsync();
        public async Task<Branch> AddBranchAsync(string name, string address) => await _repo.AddBranchAsync(name, address);
        public async Task<Branch?> UpdateBranchAsync(int id, string name, string address) => await _repo.UpdateBranchAsync(id, name, address);
        public async Task<bool> DeleteBranchAsync(int id) => await _repo.DeleteBranchAsync(id);
    }

    // =========================================================================
    // ATTENDANCE SERVICE
    // =========================================================================
    public class AttendanceService : IAttendanceService
    {
        private readonly IAttendanceRepository _repo;
        private readonly IEmployeeRepository _employeeRepo;
        private readonly ILeaveRepository _leaveRepo;

        public AttendanceService(IAttendanceRepository repo, IEmployeeRepository employeeRepo, ILeaveRepository leaveRepo)
        {
            _repo = repo;
            _employeeRepo = employeeRepo;
            _leaveRepo = leaveRepo;
        }

        public async Task<IEnumerable<Attendance>> GetPersonalHistoryAsync(int employeeId) => await _repo.GetPersonalHistoryAsync(employeeId);
        public async Task<IEnumerable<Attendance>> GetAllHistoryAsync() => await _repo.GetAllHistoryAsync();
        public async Task<Attendance?> GetTodayAttendanceAsync(int employeeId) => await _repo.GetTodayAttendanceAsync(employeeId);

        public async Task<Attendance> CheckInAsync(PunchInRequest req)
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");
            var already = await _repo.GetTodayAttendanceAsync(req.EmployeeId);
            if (already != null) throw new Exception("Already checked in for today!");

            // Check if there is an approved leave today. If yes, cancel it and refund the day!
            var leaves = await _leaveRepo.GetPersonalRequestsAsync(req.EmployeeId);
            var today = DateTime.Today;
            var activeLeave = leaves.FirstOrDefault(l => 
                l.Status == "Approved" && 
                DateTime.TryParse(l.FromDate, out var fromDate) && fromDate <= today && 
                DateTime.TryParse(l.ToDate, out var toDate) && today <= toDate
            );
            if (activeLeave != null)
            {
                await _leaveRepo.UpdateLeaveStatusAsync(activeLeave.LeaveId, "Cancelled");
                string balanceColumn = activeLeave.LeaveType switch
                {
                    "Sick Leave" => "SickLeave",
                    "Casual Leave" => "CasualLeave",
                    "Paid Leave" => "PaidLeave",
                    "Half Day Leave" => "CasualLeave",
                    _ => string.Empty
                };
                if (!string.IsNullOrEmpty(balanceColumn))
                {
                    double refundDays = (activeLeave.LeaveType == "Half Day Leave") ? 0.5 : 1.0;
                    await _leaveRepo.DecrementLeaveBalanceAsync(req.EmployeeId, balanceColumn, -refundDays);
                }
            }

            // Get Employee Shift to determine Late Login
            var employee = await _employeeRepo.GetEmployeeByIdAsync(req.EmployeeId) ?? throw new Exception("Employee not found!");
            var now = DateTime.Now;
            string status = "Present";

            var shift = (employee.Shift ?? "India").Trim().ToLower();
            if (shift == "india" || shift == "general")
            {
                if (now.Hour >= 12) status = "Late";
            }
            else if (shift == "uk")
            {
                if (now.Hour >= 16) status = "Late";
            }
            else if (shift == "us")
            {
                if (now.Hour >= 20) status = "Late";
            }

            return await _repo.CheckInAsync(req, status, todayStr);
        }

        public async Task<Attendance?> CheckOutAsync(int employeeId)
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");
            var record = await _repo.GetTodayAttendanceAsync(employeeId);
            if (record == null) throw new Exception("Not checked in today yet!");
            if (record.CheckOutTime != null) throw new Exception("Already checked out today!");

            var workingHours = Math.Round((DateTime.Now - record.CheckInTime).TotalMinutes / 60.0, 2);

            // Check if there is an approved active Half-Day Leave today (which was NOT cancelled)
            var leaves = await _leaveRepo.GetPersonalRequestsAsync(employeeId);
            var today = DateTime.Today;
            var hasApprovedHalfDay = leaves.Any(l => 
                l.LeaveType == "Half Day Leave" && 
                l.Status == "Approved" && 
                DateTime.TryParse(l.FromDate, out var fromDate) && fromDate <= today && 
                DateTime.TryParse(l.ToDate, out var toDate) && today <= toDate
            );

            string status = record.Status;
            if (hasApprovedHalfDay)
            {
                // Half-day shift: must work minimum 4.5 hours. If yes -> "Half Day". If no -> "Absent"
                if (workingHours < 4.5)
                {
                    status = "Absent";
                }
                else
                {
                    status = "Half Day";
                }
            }
            else
            {
                // Full-day shift: must work minimum 8.5 hours. If no -> downgraded to "Half Day"
                if (workingHours < 8.5)
                {
                    status = "Half Day";
                }
            }

            return await _repo.CheckOutAsync(employeeId, workingHours, status, todayStr);
        }

        public async Task<Attendance?> StartBreakAsync(int employeeId)
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");
            var record = await _repo.GetTodayAttendanceAsync(employeeId);
            if (record == null) throw new Exception("Not checked in yet!");
            if (record.BreakStartTime != null && record.BreakEndTime == null) throw new Exception("Already on break!");

            return await _repo.StartBreakAsync(employeeId, todayStr);
        }

        public async Task<Attendance?> EndBreakAsync(int employeeId)
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");
            var record = await _repo.GetTodayAttendanceAsync(employeeId);
            if (record == null) throw new Exception("Not checked in yet!");
            if (record.BreakStartTime == null || record.BreakEndTime != null) throw new Exception("Not on break!");

            return await _repo.EndBreakAsync(employeeId, todayStr);
        }
    }

    // =========================================================================
    // LEAVE SERVICE
    // =========================================================================
    public class LeaveService : ILeaveService
    {
        private readonly ILeaveRepository _repo;
        public LeaveService(ILeaveRepository repo) => _repo = repo;

        public async Task<LeaveBalance> GetLeaveBalanceAsync(int employeeId)
        {
            var balance = await _repo.GetLeaveBalanceAsync(employeeId);
            if (balance == null)
            {
                await _repo.SeedLeaveBalanceAsync(employeeId);
                balance = await _repo.GetLeaveBalanceAsync(employeeId);
            }
            return balance!;
        }

        public async Task<IEnumerable<LeaveRequest>> GetPersonalRequestsAsync(int employeeId) => await _repo.GetPersonalRequestsAsync(employeeId);
        public async Task<IEnumerable<LeaveRequest>> GetAllRequestsAsync() => await _repo.GetAllRequestsAsync();
        public async Task<LeaveRequest> ApplyLeaveAsync(ApplyLeaveRequest req) => await _repo.ApplyLeaveAsync(req);

        public async Task<LeaveRequest?> RecommendLeaveAsync(int leaveId)
        {
            var req = await _repo.GetLeaveRequestByIdAsync(leaveId);
            if (req == null) return null;
            if (req.Status != "Pending Recommendation") throw new Exception("Leave request status is not pending recommendation.");

            await _repo.UpdateLeaveStatusAsync(leaveId, "Pending");
            req.Status = "Pending";
            return req;
        }

        public async Task<LeaveRequest?> ApproveLeaveAsync(int leaveId)
        {
            var req = await _repo.GetLeaveRequestByIdAsync(leaveId);
            if (req == null) return null;
            if (req.Status != "Pending" && req.Status != "Pending Recommendation") throw new Exception("Leave request is already processed.");

            var from = DateTime.Parse(req.FromDate);
            var to = DateTime.Parse(req.ToDate);
            double days = (req.LeaveType == "Half Day Leave") ? 0.5 : ((to - from).Days + 1);

            string balanceColumn = req.LeaveType switch
            {
                "Sick Leave" => "SickLeave",
                "Casual Leave" => "CasualLeave",
                "Paid Leave" => "PaidLeave",
                "Half Day Leave" => "CasualLeave",
                _ => string.Empty
            };

            if (!string.IsNullOrEmpty(balanceColumn))
            {
                await _repo.DecrementLeaveBalanceAsync(req.EmployeeId, balanceColumn, days);
            }

            await _repo.UpdateLeaveStatusAsync(leaveId, "Approved");
            req.Status = "Approved";
            return req;
        }

        public async Task<LeaveRequest?> RejectLeaveAsync(int leaveId)
        {
            var req = await _repo.GetLeaveRequestByIdAsync(leaveId);
            if (req == null) return null;
            if (req.Status != "Pending" && req.Status != "Pending Recommendation") throw new Exception("Leave request is already processed.");

            await _repo.UpdateLeaveStatusAsync(leaveId, "Rejected");
            req.Status = "Rejected";
            return req;
        }

        public async Task<LeaveBalance?> UpdateLeaveBalanceAsync(int employeeId, double sick, double casual, double paid)
        {
            await _repo.UpdateLeaveBalanceAsync(employeeId, sick, casual, paid);
            return await _repo.GetLeaveBalanceAsync(employeeId);
        }
    }

    // =========================================================================
    // HOLIDAY SERVICE
    // =========================================================================
    public class HolidayService : IHolidayService
    {
        private readonly IHolidayRepository _repo;
        public HolidayService(IHolidayRepository repo) => _repo = repo;

        public async Task<IEnumerable<Holiday>> GetHolidaysAsync() => await _repo.GetHolidaysAsync();
        public async Task<Holiday> AddHolidayAsync(Holiday hol) => await _repo.AddHolidayAsync(hol);
        public async Task<bool> DeleteHolidayAsync(int id) => await _repo.DeleteHolidayAsync(id);
    }

    // =========================================================================
    // DASHBOARD SERVICE
    // =========================================================================
    public class DashboardService : IDashboardService
    {
        private readonly IDashboardRepository _repo;
        public DashboardService(IDashboardRepository repo) => _repo = repo;

        public async Task<object> GetMetricsAsync()
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");

            var totalEmployees = await _repo.GetActiveEmployeeCountAsync();
            var todayStatuses = (await _repo.GetTodayAttendanceStatusesAsync(todayStr)).ToList();

            var presentToday = todayStatuses.Count(s => s == "Present" || s == "Late");
            var lateToday = todayStatuses.Count(s => s == "Late");
            var halfDayToday = todayStatuses.Count(s => s == "Half Day");
            var absentToday = totalEmployees - (presentToday + halfDayToday);

            var pendingLeaves = await _repo.GetPendingLeaveCountAsync();

            // Last 7 days trend
            var attendanceTrend = new List<object>();
            var now = DateTime.Now;
            for (int i = 6; i >= 0; i--)
            {
                var date = now.AddDays(-i);
                var dateStr = date.ToString("yyyy-MM-dd");
                var dayPresent = await _repo.GetAttendanceCountForDateAsync(dateStr);

                attendanceTrend.Add(new {
                    date = dateStr,
                    present = dayPresent,
                    absent = Math.Max(0, totalEmployees - dayPresent)
                });
            }

            // Department distribution
            var deptCounts = await _repo.GetDepartmentEmployeeCountsAsync();
            var departmentDistribution = deptCounts.Select(d => new {
                department = d.Department,
                count = d.Count
            }).ToList();

            // Today's Birthdays
            var birthdays = await _repo.GetTodayBirthdaysAsync();

            // Today's Present & Absent teammate lists
            var presentList = await _repo.GetTodayPresentListAsync(todayStr);
            var absentList = await _repo.GetTodayAbsentListAsync(todayStr);

            return new {
                totalEmployees,
                presentToday,
                absentToday = Math.Max(0, absentToday),
                lateToday,
                pendingLeaves,
                attendanceTrend,
                departmentDistribution,
                birthdays,
                presentList,
                absentList
            };
        }
    }

    // =========================================================================
    // REPORT SERVICE
    // =========================================================================
    public class ReportService : IReportService
    {
        private readonly IReportRepository _repo;
        private readonly IEmployeeRepository _employeeRepo;

        public ReportService(IReportRepository repo, IEmployeeRepository employeeRepo)
        {
            _repo = repo;
            _employeeRepo = employeeRepo;
        }

        public async Task<IEnumerable<dynamic>> GetFilteredAttendanceAsync(string? startDate, string? endDate, int? employeeId, string? department, string? status)
        {
            return await _repo.GetFilteredAttendanceAsync(startDate, endDate, employeeId, department, status);
        }

        public async Task<IEnumerable<object>> GetPayrollSummaryAsync(int month, int year)
        {
            var employees = (await _employeeRepo.GetEmployeesAsync()).Where(e => e.Status).ToList();
            var results = new List<object>();
            int totalDaysInMonth = DateTime.DaysInMonth(year, month);

            int weekendDaysCount = 0;
            for (int day = 1; day <= totalDaysInMonth; day++)
            {
                var dt = new DateTime(year, month, day);
                if (dt.DayOfWeek == DayOfWeek.Saturday || dt.DayOfWeek == DayOfWeek.Sunday)
                {
                    weekendDaysCount++;
                }
            }

            foreach (var emp in employees)
            {
                var attendance = (await _repo.GetFilteredAttendanceAsync(
                    $"{year}-{month.ToString().PadLeft(2, '0')}-01",
                    $"{year}-{month.ToString().PadLeft(2, '0')}-{totalDaysInMonth}",
                    emp.EmployeeId, null, null
                )).ToList();

                int presentDays = attendance.Count(a => a.Status == "Present" || a.Status == "Late");
                int lateDays = attendance.Count(a => a.Status == "Late");
                int halfDays = attendance.Count(a => a.Status == "Half Day");
                int queryAbsentDays = attendance.Count(a => a.Status == "Absent");

                var leaves = (await _repo.GetApprovedLeavesAsync(emp.EmployeeId)).ToList();
                int approvedLeaveDays = 0;

                foreach (var leave in leaves)
                {
                    var from = DateTime.Parse((string)leave.FromDate);
                    var to = DateTime.Parse((string)leave.ToDate);

                    var start = from < new DateTime(year, month, 1) ? new DateTime(year, month, 1) : from;
                    var end = to > new DateTime(year, month, totalDaysInMonth) ? new DateTime(year, month, totalDaysInMonth) : to;

                    if (start <= end && start.Month == month && start.Year == year)
                    {
                        approvedLeaveDays += (end - start).Days + 1;
                    }
                }

                // Weekends are paid days. WorkingDays includes actual present + half days (as 0.5) + approved leaves + weekends.
                double workingDays = presentDays + (halfDays * 0.5) + approvedLeaveDays + weekendDaysCount;
                if (workingDays > totalDaysInMonth) workingDays = totalDaysInMonth;

                int absentDays = (int)Math.Max(0, totalDaysInMonth - workingDays);

                results.Add(new {
                    employeeId = emp.EmployeeId,
                    employeeCode = emp.EmployeeCode,
                    firstName = emp.FirstName,
                    lastName = emp.LastName,
                    department = emp.Department,
                    designation = emp.Designation,
                    month,
                    year,
                    presentDays = presentDays + (halfDays * 0.5),
                    lateDays,
                    halfDays,
                    absentDays,
                    leaveDays = approvedLeaveDays,
                    workingDays,
                    totalDays = totalDaysInMonth
                });
            }

            return results;
        }
    }
}
