using System;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Dapper;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Models;

namespace SmartAttendanceBackend.Repositories
{
    // =========================================================================
    // EMPLOYEE REPOSITORY
    // =========================================================================
    public class EmployeeRepository : IEmployeeRepository
    {
        private readonly IDbConnection _db;
        public EmployeeRepository(IDbConnection db) => _db = db;

        public async Task<IEnumerable<Employee>> GetEmployeesAsync()
        {
            return await _db.QueryAsync<Employee>("SELECT * FROM Employees ORDER BY EmployeeCode");
        }

        public async Task<Employee?> GetEmployeeByIdAsync(int id)
        {
            return await _db.QueryFirstOrDefaultAsync<Employee>(
                "SELECT * FROM Employees WHERE EmployeeId = @Id",
                new { Id = id }
            );
        }

        public async Task<Employee> AddEmployeeAsync(Employee emp)
        {
            const string query = @"
                INSERT INTO Employees (EmployeeCode, FirstName, LastName, Email, MobileNumber, Department, Designation, Branch, JoiningDate, DateOfBirth, Address, ProfilePhoto, Status, Role, PasswordHash, Shift, CreatedDate, ReportingToId)
                VALUES (@EmployeeCode, @FirstName, @LastName, @Email, @MobileNumber, @Department, @Designation, @Branch, @JoiningDate, @DateOfBirth, @Address, @ProfilePhoto, @Status, @Role, @PasswordHash, @Shift, @CreatedDate, @ReportingToId);
                SELECT CAST(SCOPE_IDENTITY() as int);";

            var id = await _db.ExecuteScalarAsync<int>(query, emp);
            emp.EmployeeId = id;
            return emp;
        }

        public async Task<Employee?> UpdateEmployeeAsync(int id, Employee emp)
        {
            const string query = @"
                UPDATE Employees 
                SET FirstName = @FirstName, LastName = @LastName, Email = @Email, MobileNumber = @MobileNumber, 
                    Department = @Department, Designation = @Designation, Branch = @Branch, 
                    JoiningDate = @JoiningDate, DateOfBirth = @DateOfBirth, Address = @Address, ProfilePhoto = @ProfilePhoto, Role = @Role, Shift = @Shift, ReportingToId = @ReportingToId
                WHERE EmployeeId = @Id";

            var rows = await _db.ExecuteAsync(query, new {
                emp.FirstName, emp.LastName, emp.Email, emp.MobileNumber,
                emp.Department, emp.Designation, emp.Branch, emp.JoiningDate, emp.DateOfBirth,
                emp.Address, emp.ProfilePhoto, emp.Role, emp.Shift, emp.ReportingToId, Id = id
            });

            if (rows == 0) return null;
            emp.EmployeeId = id;
            return emp;
        }

        public async Task<bool> DeleteEmployeeAsync(int id)
        {
            var rows = await _db.ExecuteAsync("DELETE FROM Employees WHERE EmployeeId = @Id", new { Id = id });
            return rows > 0;
        }

        public async Task<Employee?> ToggleEmployeeStatusAsync(int id)
        {
            var employee = await _db.QueryFirstOrDefaultAsync<Employee>("SELECT * FROM Employees WHERE EmployeeId = @Id", new { Id = id });
            if (employee == null) return null;

            var newStatus = !employee.Status;
            await _db.ExecuteAsync("UPDATE Employees SET Status = @Status WHERE EmployeeId = @Id", new { Status = newStatus, Id = id });
            employee.Status = newStatus;
            return employee;
        }

        public async Task<Employee?> GetEmployeeByEmailAsync(string email)
        {
            return await _db.QueryFirstOrDefaultAsync<Employee>(
                "SELECT * FROM Employees WHERE LOWER(Email) = LOWER(@Email)",
                new { Email = email.Trim() }
            );
        }

        // --- Departments ---
        public async Task<IEnumerable<Department>> GetDepartmentsAsync()
        {
            return await _db.QueryAsync<Department>("SELECT * FROM Departments ORDER BY Name");
        }

        public async Task<Department> AddDepartmentAsync(string name, string code)
        {
            const string query = @"
                INSERT INTO Departments (Name, Code) VALUES (@Name, @Code);
                SELECT CAST(SCOPE_IDENTITY() as int);";
            var id = await _db.ExecuteScalarAsync<int>(query, new { Name = name, Code = code });
            return new Department { Id = id, Name = name, Code = code };
        }

        public async Task<Department?> UpdateDepartmentAsync(int id, string name, string code)
        {
            const string query = "UPDATE Departments SET Name = @Name, Code = @Code WHERE Id = @Id";
            var rows = await _db.ExecuteAsync(query, new { Name = name, Code = code, Id = id });
            if (rows == 0) return null;
            return new Department { Id = id, Name = name, Code = code };
        }

        public async Task<bool> DeleteDepartmentAsync(int id)
        {
            var rows = await _db.ExecuteAsync("DELETE FROM Departments WHERE Id = @Id", new { Id = id });
            return rows > 0;
        }

        // --- Designations ---
        public async Task<IEnumerable<Designation>> GetDesignationsAsync()
        {
            return await _db.QueryAsync<Designation>("SELECT * FROM Designations ORDER BY Name");
        }

        public async Task<Designation> AddDesignationAsync(string name, int departmentId)
        {
            const string query = @"
                INSERT INTO Designations (Name, DepartmentId) VALUES (@Name, @DepartmentId);
                SELECT CAST(SCOPE_IDENTITY() as int);";
            var id = await _db.ExecuteScalarAsync<int>(query, new { Name = name, DepartmentId = departmentId });
            return new Designation { Id = id, Name = name, DepartmentId = departmentId.ToString() };
        }

        public async Task<Designation?> UpdateDesignationAsync(int id, string name, int departmentId)
        {
            const string query = "UPDATE Designations SET Name = @Name, DepartmentId = @DepartmentId WHERE Id = @Id";
            var rows = await _db.ExecuteAsync(query, new { Name = name, DepartmentId = departmentId, Id = id });
            if (rows == 0) return null;
            return new Designation { Id = id, Name = name, DepartmentId = departmentId.ToString() };
        }

        public async Task<bool> DeleteDesignationAsync(int id)
        {
            var rows = await _db.ExecuteAsync("DELETE FROM Designations WHERE Id = @Id", new { Id = id });
            return rows > 0;
        }

        // --- Branches ---
        public async Task<IEnumerable<Branch>> GetBranchesAsync()
        {
            return await _db.QueryAsync<Branch>("SELECT * FROM Branches ORDER BY Name");
        }

        public async Task<Branch> AddBranchAsync(string name, string address)
        {
            const string query = @"
                INSERT INTO Branches (Name, Address) VALUES (@Name, @Address);
                SELECT CAST(SCOPE_IDENTITY() as int);";
            var id = await _db.ExecuteScalarAsync<int>(query, new { Name = name, Address = address });
            return new Branch { Id = id, Name = name, Address = address };
        }

        public async Task<Branch?> UpdateBranchAsync(int id, string name, string address)
        {
            const string query = "UPDATE Branches SET Name = @Name, Address = @Address WHERE Id = @Id";
            var rows = await _db.ExecuteAsync(query, new { Name = name, Address = address, Id = id });
            if (rows == 0) return null;
            return new Branch { Id = id, Name = name, Address = address };
        }

        public async Task<bool> DeleteBranchAsync(int id)
        {
            var rows = await _db.ExecuteAsync("DELETE FROM Branches WHERE Id = @Id", new { Id = id });
            return rows > 0;
        }
    }

    // =========================================================================
    // ATTENDANCE REPOSITORY
    // =========================================================================
    public class AttendanceRepository : IAttendanceRepository
    {
        private readonly IDbConnection _db;
        public AttendanceRepository(IDbConnection db) => _db = db;

        public async Task<IEnumerable<Attendance>> GetPersonalHistoryAsync(int employeeId)
        {
            return await _db.QueryAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE EmployeeId = @EmployeeId ORDER BY AttendanceDate DESC",
                new { EmployeeId = employeeId }
            );
        }

        public async Task<IEnumerable<Attendance>> GetAllHistoryAsync()
        {
            return await _db.QueryAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance ORDER BY AttendanceDate DESC"
            );
        }

        public async Task<Attendance?> GetTodayAttendanceAsync(int employeeId)
        {
            var todayStr = DateTime.Now.ToString("yyyy-MM-dd");
            return await _db.QueryFirstOrDefaultAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { EmployeeId = employeeId, TodayDate = todayStr }
            );
        }

        public async Task<Attendance> CheckInAsync(PunchInRequest req, string status, string todayStr)
        {
            const string query = @"
                INSERT INTO Attendance (EmployeeId, AttendanceDate, CheckInTime, WorkingHours, Latitude, Longitude, Status, LocationType)
                VALUES (@EmployeeId, @AttendanceDate, @CheckInTime, 0.0, @Latitude, @Longitude, @Status, @LocationType);
                SELECT CAST(SCOPE_IDENTITY() as int);";

            var id = await _db.ExecuteScalarAsync<int>(query, new {
                EmployeeId = req.EmployeeId,
                AttendanceDate = todayStr,
                CheckInTime = DateTime.Now,
                Latitude = req.Latitude,
                Longitude = req.Longitude,
                Status = status,
                LocationType = req.LocationType
            });

            return await _db.QueryFirstOrDefaultAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE AttendanceId = @Id",
                new { Id = id }
            ) ?? throw new Exception("Error returning created attendance record.");
        }

        public async Task<Attendance?> CheckOutAsync(int employeeId, double workingHours, string status, string todayStr)
        {
            const string query = @"
                UPDATE Attendance 
                SET CheckOutTime = @CheckOutTime, WorkingHours = @WorkingHours, Status = @Status 
                WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate AND CheckOutTime IS NULL";

            await _db.ExecuteAsync(query, new {
                CheckOutTime = DateTime.Now,
                WorkingHours = workingHours,
                Status = status,
                EmployeeId = employeeId,
                TodayDate = todayStr
            });

            return await _db.QueryFirstOrDefaultAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { EmployeeId = employeeId, TodayDate = todayStr }
            );
        }

        public async Task<Attendance?> StartBreakAsync(int employeeId, string todayStr)
        {
            await _db.ExecuteAsync(
                "UPDATE Attendance SET BreakStartTime = @BreakStartTime, BreakEndTime = NULL WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { BreakStartTime = DateTime.Now, EmployeeId = employeeId, TodayDate = todayStr }
            );

            return await _db.QueryFirstOrDefaultAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { EmployeeId = employeeId, TodayDate = todayStr }
            );
        }

        public async Task<Attendance?> EndBreakAsync(int employeeId, string todayStr)
        {
            await _db.ExecuteAsync(
                "UPDATE Attendance SET BreakEndTime = @BreakEndTime WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { BreakEndTime = DateTime.Now, EmployeeId = employeeId, TodayDate = todayStr }
            );

            return await _db.QueryFirstOrDefaultAsync<Attendance>(
                "SELECT AttendanceId, EmployeeId, CONVERT(VARCHAR(10), AttendanceDate, 120) AS AttendanceDate, CheckInTime, CheckOutTime, BreakStartTime, BreakEndTime, WorkingHours, Latitude, Longitude, Status, LocationType FROM Attendance WHERE EmployeeId = @EmployeeId AND AttendanceDate = @TodayDate",
                new { EmployeeId = employeeId, TodayDate = todayStr }
            );
        }
    }

    // =========================================================================
    // LEAVE REPOSITORY
    // =========================================================================
    public class LeaveRepository : ILeaveRepository
    {
        private readonly IDbConnection _db;
        public LeaveRepository(IDbConnection db) => _db = db;

        public async Task<LeaveBalance?> GetLeaveBalanceAsync(int employeeId)
        {
            return await _db.QueryFirstOrDefaultAsync<LeaveBalance>(
                "SELECT * FROM LeaveBalances WHERE EmployeeId = @EmployeeId",
                new { EmployeeId = employeeId }
            );
        }

        public async Task SeedLeaveBalanceAsync(int employeeId)
        {
            await _db.ExecuteAsync(
                "INSERT INTO LeaveBalances (EmployeeId, SickLeave, CasualLeave, PaidLeave) VALUES (@Id, 12, 12, 18)",
                new { Id = employeeId }
            );
        }

        public async Task<IEnumerable<LeaveRequest>> GetPersonalRequestsAsync(int employeeId)
        {
            return await _db.QueryAsync<LeaveRequest>(
                "SELECT LeaveId, EmployeeId, LeaveType, CONVERT(VARCHAR(10), FromDate, 120) AS FromDate, CONVERT(VARCHAR(10), ToDate, 120) AS ToDate, Reason, Status, AppliedDate FROM LeaveRequests WHERE EmployeeId = @EmployeeId ORDER BY AppliedDate DESC",
                new { EmployeeId = employeeId }
            );
        }

        public async Task<IEnumerable<LeaveRequest>> GetAllRequestsAsync()
        {
            return await _db.QueryAsync<LeaveRequest>(
                "SELECT LeaveId, EmployeeId, LeaveType, CONVERT(VARCHAR(10), FromDate, 120) AS FromDate, CONVERT(VARCHAR(10), ToDate, 120) AS ToDate, Reason, Status, AppliedDate FROM LeaveRequests ORDER BY AppliedDate DESC"
            );
        }

        public async Task<LeaveRequest> ApplyLeaveAsync(ApplyLeaveRequest req)
        {
            var reportingToId = await _db.ExecuteScalarAsync<int?>(
                "SELECT ReportingToId FROM Employees WHERE EmployeeId = @Id",
                new { Id = req.EmployeeId }
            );

            string initialStatus = reportingToId.HasValue ? "Pending Recommendation" : "Pending";

            const string query = @"
                INSERT INTO LeaveRequests (EmployeeId, LeaveType, FromDate, ToDate, Reason, Status, AppliedDate)
                VALUES (@EmployeeId, @LeaveType, @FromDate, @ToDate, @Reason, @Status, @AppliedDate);
                SELECT CAST(SCOPE_IDENTITY() as int);";

            var id = await _db.ExecuteScalarAsync<int>(query, new {
                EmployeeId = req.EmployeeId,
                LeaveType = req.LeaveType,
                FromDate = req.FromDate,
                ToDate = req.ToDate,
                Reason = req.Reason,
                Status = initialStatus,
                AppliedDate = DateTime.Now
            });

            return await _db.QueryFirstOrDefaultAsync<LeaveRequest>(
                "SELECT LeaveId, EmployeeId, LeaveType, CONVERT(VARCHAR(10), FromDate, 120) AS FromDate, CONVERT(VARCHAR(10), ToDate, 120) AS ToDate, Reason, Status, AppliedDate FROM LeaveRequests WHERE LeaveId = @Id",
                new { Id = id }
            ) ?? throw new Exception("Error applying leave.");
        }

        public async Task<LeaveRequest?> GetLeaveRequestByIdAsync(int leaveId)
        {
            return await _db.QueryFirstOrDefaultAsync<LeaveRequest>(
                "SELECT LeaveId, EmployeeId, LeaveType, CONVERT(VARCHAR(10), FromDate, 120) AS FromDate, CONVERT(VARCHAR(10), ToDate, 120) AS ToDate, Reason, Status, AppliedDate FROM LeaveRequests WHERE LeaveId = @Id",
                new { Id = leaveId }
            );
        }

        public async Task UpdateLeaveStatusAsync(int leaveId, string status)
        {
            await _db.ExecuteAsync(
                "UPDATE LeaveRequests SET Status = @Status WHERE LeaveId = @Id",
                new { Status = status, Id = leaveId }
            );
        }

        public async Task DecrementLeaveBalanceAsync(int employeeId, string column, double days)
        {
            var query = $"UPDATE LeaveBalances SET {column} = {column} - @Days WHERE EmployeeId = @EmployeeId";
            await _db.ExecuteAsync(query, new { Days = days, EmployeeId = employeeId });
        }

        public async Task UpdateLeaveBalanceAsync(int employeeId, double sick, double casual, double paid)
        {
            const string query = @"
                UPDATE LeaveBalances 
                SET SickLeave = @Sick, CasualLeave = @Casual, PaidLeave = @Paid 
                WHERE EmployeeId = @EmployeeId";
            await _db.ExecuteAsync(query, new { EmployeeId = employeeId, Sick = sick, Casual = casual, Paid = paid });
        }
    }

    // =========================================================================
    // HOLIDAY REPOSITORY
    // =========================================================================
    public class HolidayRepository : IHolidayRepository
    {
        private readonly IDbConnection _db;
        public HolidayRepository(IDbConnection db) => _db = db;

        public async Task<IEnumerable<Holiday>> GetHolidaysAsync()
        {
            return await _db.QueryAsync<Holiday>("SELECT HolidayId, HolidayName, CONVERT(VARCHAR(10), HolidayDate, 120) AS HolidayDate, Description FROM Holidays ORDER BY HolidayDate ASC");
        }

        public async Task<Holiday> AddHolidayAsync(Holiday hol)
        {
            const string query = @"
                INSERT INTO Holidays (HolidayName, HolidayDate, Description) 
                VALUES (@HolidayName, @HolidayDate, @Description);
                SELECT CAST(SCOPE_IDENTITY() as int);";
            var id = await _db.ExecuteScalarAsync<int>(query, hol);
            hol.HolidayId = id;
            return hol;
        }

        public async Task<bool> DeleteHolidayAsync(int id)
        {
            var rows = await _db.ExecuteAsync("DELETE FROM Holidays WHERE HolidayId = @Id", new { Id = id });
            return rows > 0;
        }
    }

    // =========================================================================
    // DASHBOARD REPOSITORY
    // =========================================================================
    public class DashboardRepository : IDashboardRepository
    {
        private readonly IDbConnection _db;
        public DashboardRepository(IDbConnection db) => _db = db;

        public async Task<int> GetActiveEmployeeCountAsync()
        {
            return await _db.ExecuteScalarAsync<int>(
                "SELECT COUNT(*) FROM Employees WHERE Status = 1"
            );
        }

        public async Task<IEnumerable<string>> GetTodayAttendanceStatusesAsync(string todayStr)
        {
            return await _db.QueryAsync<string>(
                "SELECT Status FROM Attendance WHERE AttendanceDate = @TodayDate",
                new { TodayDate = todayStr }
            );
        }

        public async Task<int> GetPendingLeaveCountAsync()
        {
            return await _db.ExecuteScalarAsync<int>(
                "SELECT COUNT(*) FROM LeaveRequests WHERE Status = 'Pending'"
            );
        }

        public async Task<int> GetAttendanceCountForDateAsync(string dateStr)
        {
            return await _db.ExecuteScalarAsync<int>(
                "SELECT COUNT(Status) FROM Attendance WHERE AttendanceDate = @Date AND (Status = 'Present' OR Status = 'Late')",
                new { Date = dateStr }
            );
        }

        public async Task<IEnumerable<dynamic>> GetDepartmentEmployeeCountsAsync()
        {
            return await _db.QueryAsync<dynamic>(
                "SELECT Department, COUNT(*) as Count FROM Employees WHERE Status = 1 GROUP BY Department"
            );
        }

        public async Task<IEnumerable<dynamic>> GetTodayBirthdaysAsync()
        {
            return await _db.QueryAsync<dynamic>(
                @"SELECT EmployeeId as employeeId, EmployeeCode as employeeCode, FirstName as firstName, LastName as lastName, Department as department, Designation as designation, ProfilePhoto as profilePhoto, DateOfBirth as dateOfBirth 
                  FROM Employees 
                  WHERE Status = 1 AND MONTH(DateOfBirth) = MONTH(GETDATE()) AND DAY(DateOfBirth) = DAY(GETDATE())"
            );
        }

        public async Task<IEnumerable<dynamic>> GetTodayPresentListAsync(string todayStr)
        {
            return await _db.QueryAsync<dynamic>(
                @"SELECT e.EmployeeId as employeeId, e.EmployeeCode as employeeCode, e.FirstName as firstName, e.LastName as lastName, e.Department as department, e.Designation as designation, a.Status as status, a.CheckInTime as checkInTime 
                  FROM Attendance a 
                  INNER JOIN Employees e ON a.EmployeeId = e.EmployeeId 
                  WHERE a.AttendanceDate = @TodayDate",
                new { TodayDate = todayStr }
            );
        }

        public async Task<IEnumerable<dynamic>> GetTodayAbsentListAsync(string todayStr)
        {
            return await _db.QueryAsync<dynamic>(
                @"SELECT e.EmployeeId as employeeId, e.EmployeeCode as employeeCode, e.FirstName as firstName, e.LastName as lastName, e.Department as department, e.Designation as designation 
                  FROM Employees e 
                  WHERE e.Status = 1 
                    AND e.EmployeeId NOT IN (SELECT EmployeeId FROM Attendance WHERE AttendanceDate = @TodayDate)
                    AND e.EmployeeId NOT IN (
                        SELECT EmployeeId FROM LeaveRequests 
                        WHERE Status = 'Approved' 
                          AND @TodayDate >= FromDate 
                          AND @TodayDate <= ToDate
                    )",
                new { TodayDate = todayStr }
            );
        }
    }

    // =========================================================================
    // REPORT REPOSITORY
    // =========================================================================
    public class ReportRepository : IReportRepository
    {
        private readonly IDbConnection _db;
        public ReportRepository(IDbConnection db) => _db = db;

        public async Task<IEnumerable<dynamic>> GetFilteredAttendanceAsync(string? startDate, string? endDate, int? employeeId, string? department, string? status)
        {
            var sql = @"
                SELECT a.AttendanceId as attendanceId, a.EmployeeId as employeeId, CONVERT(VARCHAR(10), a.AttendanceDate, 120) AS attendanceDate, a.CheckInTime as checkInTime, a.CheckOutTime as checkOutTime, a.BreakStartTime as breakStartTime, a.BreakEndTime as breakEndTime, a.WorkingHours as workingHours, a.Latitude as latitude, a.Longitude as longitude, a.Status as status, a.LocationType as locationType, e.EmployeeCode as employeeCode, e.FirstName as firstName, e.LastName as lastName, e.Department as department, e.Designation as designation, e.Branch as branch
                FROM Attendance a
                INNER JOIN Employees e ON a.EmployeeId = e.EmployeeId
                WHERE 1 = 1";

            var parameters = new DynamicParameters();

            if (employeeId.HasValue)
            {
                sql += " AND a.EmployeeId = @EmployeeId";
                parameters.Add("EmployeeId", employeeId.Value);
            }

            if (!string.IsNullOrEmpty(department))
            {
                sql += " AND LOWER(e.Department) = LOWER(@Department)";
                parameters.Add("Department", department.Trim());
            }

            if (!string.IsNullOrEmpty(status))
            {
                sql += " AND LOWER(a.Status) = LOWER(@Status)";
                parameters.Add("Status", status.Trim());
            }

            if (!string.IsNullOrEmpty(startDate))
            {
                sql += " AND a.AttendanceDate >= @StartDate";
                parameters.Add("StartDate", startDate);
            }

            if (!string.IsNullOrEmpty(endDate))
            {
                sql += " AND a.AttendanceDate <= @EndDate";
                parameters.Add("EndDate", endDate);
            }

            sql += " ORDER BY a.AttendanceDate DESC";

            return await _db.QueryAsync<dynamic>(sql, parameters);
        }

        public async Task<IEnumerable<dynamic>> GetApprovedLeavesAsync(int employeeId)
        {
            return await _db.QueryAsync<dynamic>(
                "SELECT CONVERT(VARCHAR(10), FromDate, 120) AS FromDate, CONVERT(VARCHAR(10), ToDate, 120) AS ToDate FROM LeaveRequests WHERE EmployeeId = @Id AND Status = 'Approved'",
                new { Id = employeeId }
            );
        }
    }
}
