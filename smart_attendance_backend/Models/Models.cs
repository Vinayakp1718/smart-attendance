using System;

namespace SmartAttendanceBackend.Models
{
    public class Employee
    {
        public int EmployeeId { get; set; }
        public string EmployeeCode { get; set; } = string.Empty;
        public string FirstName { get; set; } = string.Empty;
        public string LastName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public string MobileNumber { get; set; } = string.Empty;
        public string Department { get; set; } = string.Empty;
        public string Designation { get; set; } = string.Empty;
        public string Branch { get; set; } = string.Empty;
        public DateTime JoiningDate { get; set; }
        public DateTime DateOfBirth { get; set; }
        public string Address { get; set; } = string.Empty;
        public string? ProfilePhoto { get; set; }
        public bool Status { get; set; }
        private string _role = string.Empty;
        public string Role 
        { 
            get => _role; 
            set 
            {
                if (string.IsNullOrEmpty(value)) { _role = string.Empty; return; }
                var val = value.Trim();
                if (string.Equals(val, "employee", StringComparison.OrdinalIgnoreCase)) _role = "Employee";
                else if (string.Equals(val, "hradmin", StringComparison.OrdinalIgnoreCase) || string.Equals(val, "hrmanager", StringComparison.OrdinalIgnoreCase)) _role = "HRManager";
                else if (string.Equals(val, "superadmin", StringComparison.OrdinalIgnoreCase) || string.Equals(val, "admin", StringComparison.OrdinalIgnoreCase)) _role = "SuperAdmin";
                else _role = val;
            }
        }
        public string PasswordHash { get; set; } = string.Empty;
        public string Shift { get; set; } = "India";
        public DateTime CreatedDate { get; set; }
        public int? ReportingToId { get; set; }
    }

    public class Department
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Code { get; set; } = string.Empty;
    }

    public class Designation
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string DepartmentId { get; set; } = string.Empty;
    }

    public class Branch
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
    }

    public class Attendance
    {
        public int AttendanceId { get; set; }
        public int EmployeeId { get; set; }
        public string AttendanceDate { get; set; } = string.Empty; // YYYY-MM-DD
        public DateTime CheckInTime { get; set; }
        public DateTime? CheckOutTime { get; set; }
        public DateTime? BreakStartTime { get; set; }
        public DateTime? BreakEndTime { get; set; }
        public double WorkingHours { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string Status { get; set; } = string.Empty; // Present, Absent, Half Day, Late
        public string LocationType { get; set; } = "Office"; // Office, Home, Client Site
    }

    public class LeaveBalance
    {
        public int EmployeeId { get; set; }
        public double SickLeave { get; set; }
        public double CasualLeave { get; set; }
        public double PaidLeave { get; set; }
    }

    public class LeaveRequest
    {
        public int LeaveId { get; set; }
        public int EmployeeId { get; set; }
        public string LeaveType { get; set; } = string.Empty; // Sick Leave, Casual Leave, Paid Leave
        public string FromDate { get; set; } = string.Empty; // YYYY-MM-DD
        public string ToDate { get; set; } = string.Empty; // YYYY-MM-DD
        public string Reason { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty; // Pending, Approved, Rejected
        public DateTime AppliedDate { get; set; }
    }

    public class Holiday
    {
        public int HolidayId { get; set; }
        public string HolidayName { get; set; } = string.Empty;
        public string HolidayDate { get; set; } = string.Empty; // YYYY-MM-DD
        public string? Description { get; set; }
    }

    // Requests payloads
    public class LoginRequest
    {
        public string Email { get; set; } = string.Empty;
        public string Password { get; set; } = string.Empty;
    }

    public class PunchInRequest
    {
        public int EmployeeId { get; set; }
        public double Latitude { get; set; }
        public double Longitude { get; set; }
        public string LocationType { get; set; } = "Office";
    }

    public class PunchOutRequest
    {
        public int EmployeeId { get; set; }
    }

    public class ApplyLeaveRequest
    {
        public int EmployeeId { get; set; }
        public string LeaveType { get; set; } = string.Empty;
        public string FromDate { get; set; } = string.Empty;
        public string ToDate { get; set; } = string.Empty;
        public string Reason { get; set; } = string.Empty;
    }
}
