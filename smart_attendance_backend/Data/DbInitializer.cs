using System;
using System.Data;
using Microsoft.Data.SqlClient;
using Dapper;

namespace SmartAttendanceBackend.Data
{
    public static class DbInitializer
    {
        private const string MasterConnectionString = "Server=(localdb)\\MSSQLLocalDB;Database=master;Trusted_Connection=True;Encrypt=False;";
        private const string ConnectionString = "Server=(localdb)\\MSSQLLocalDB;Database=SmartAttendanceDb;Trusted_Connection=True;Encrypt=False;";

        public static void Initialize()
        {
            try
            {
                // 1. Create DB if not exists
                using (var masterConn = new SqlConnection(MasterConnectionString))
                {
                    masterConn.Open();
                    var dbExists = masterConn.ExecuteScalar<int>(
                        "SELECT COUNT(*) FROM sys.databases WHERE name = 'SmartAttendanceDb'") > 0;
                    
                    if (!dbExists)
                    {
                        masterConn.Execute("CREATE DATABASE SmartAttendanceDb");
                        Console.WriteLine("Database 'SmartAttendanceDb' created successfully.");
                    }
                }

                // 2. Initialize Tables & Seed
                using (var conn = new SqlConnection(ConnectionString))
                {
                    conn.Open();

                    // Create Departments Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Departments' AND xtype='U')
                        CREATE TABLE Departments (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Name NVARCHAR(100) NOT NULL UNIQUE,
                            Code VARCHAR(20) NOT NULL UNIQUE
                        );");

                    // Create Designations Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Designations' AND xtype='U')
                        CREATE TABLE Designations (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Name NVARCHAR(100) NOT NULL UNIQUE,
                            DepartmentId INT NOT NULL
                        );");

                    // Create Branches Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Branches' AND xtype='U')
                        CREATE TABLE Branches (
                            Id INT IDENTITY(1,1) PRIMARY KEY,
                            Name NVARCHAR(150) NOT NULL UNIQUE,
                            Address NVARCHAR(500) NOT NULL
                        );");

                    // Create Employees Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Employees' AND xtype='U')
                        CREATE TABLE Employees (
                            EmployeeId INT IDENTITY(1,1) PRIMARY KEY,
                            EmployeeCode VARCHAR(20) UNIQUE NOT NULL,
                            FirstName NVARCHAR(100) NOT NULL,
                            LastName NVARCHAR(100) NOT NULL,
                            Email VARCHAR(150) UNIQUE NOT NULL,
                            MobileNumber VARCHAR(20) NOT NULL,
                            Department NVARCHAR(100) NOT NULL,
                            Designation NVARCHAR(100) NOT NULL,
                            Branch NVARCHAR(100) NOT NULL,
                            JoiningDate DATE NOT NULL,
                            DateOfBirth DATE NOT NULL,
                            Address NVARCHAR(500) NOT NULL,
                            ProfilePhoto VARCHAR(500) NULL,
                            Status BIT NOT NULL DEFAULT 1,
                            Role VARCHAR(50) NOT NULL,
                            PasswordHash VARCHAR(255) NOT NULL,
                            Shift VARCHAR(50) NOT NULL DEFAULT 'India',
                            CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
                        );
                        
                        -- Ensure Shift column exists for existing installations
                        IF NOT EXISTS (
                            SELECT * FROM sys.columns 
                            WHERE object_id = OBJECT_ID(N'[dbo].[Employees]') AND name = 'Shift'
                        )
                        ALTER TABLE Employees ADD Shift VARCHAR(50) NOT NULL DEFAULT 'India';

                        -- Ensure ReportingToId column exists for team leader approval workflow
                        IF NOT EXISTS (
                            SELECT * FROM sys.columns 
                            WHERE object_id = OBJECT_ID(N'[dbo].[Employees]') AND name = 'ReportingToId'
                        )
                        ALTER TABLE Employees ADD ReportingToId INT NULL CONSTRAINT FK_Employees_ReportingTo FOREIGN KEY (ReportingToId) REFERENCES Employees(EmployeeId);
                    ");

                    // Create Attendance Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Attendance' AND xtype='U')
                        CREATE TABLE Attendance (
                            AttendanceId INT IDENTITY(1,1) PRIMARY KEY,
                            EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeId),
                            AttendanceDate DATE NOT NULL,
                            CheckInTime DATETIME2 NOT NULL,
                            CheckOutTime DATETIME2 NULL,
                            BreakStartTime DATETIME2 NULL,
                            BreakEndTime DATETIME2 NULL,
                            WorkingHours FLOAT NOT NULL DEFAULT 0.0,
                            Latitude FLOAT NOT NULL,
                            Longitude FLOAT NOT NULL,
                            Status VARCHAR(30) NOT NULL,
                            LocationType VARCHAR(50) NOT NULL DEFAULT 'Office',
                            CONSTRAINT UC_Employee_Date UNIQUE (EmployeeId, AttendanceDate)
                        );");

                    // Create LeaveBalances Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LeaveBalances' AND xtype='U')
                        CREATE TABLE LeaveBalances (
                            EmployeeId INT PRIMARY KEY FOREIGN KEY REFERENCES Employees(EmployeeId) ON DELETE CASCADE,
                            SickLeave FLOAT NOT NULL DEFAULT 12.0,
                            CasualLeave FLOAT NOT NULL DEFAULT 12.0,
                            PaidLeave FLOAT NOT NULL DEFAULT 18.0
                        );
                        
                        -- Upgrade columns to FLOAT for half-day balances support only if they are not already FLOAT
                        IF EXISTS (
                            SELECT * FROM sys.columns c
                            JOIN sys.types t ON c.user_type_id = t.user_type_id
                            WHERE c.object_id = OBJECT_ID('LeaveBalances') 
                            AND c.name = 'SickLeave' 
                            AND t.name <> 'float'
                        )
                        BEGIN
                            -- Drop default constraints
                            DECLARE @ConstraintName NVARCHAR(200)
                            
                            SELECT @ConstraintName = Name FROM sys.default_constraints 
                            WHERE parent_object_id = OBJECT_ID('LeaveBalances') 
                            AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('LeaveBalances'), 'SickLeave', 'ColumnId')
                            IF @ConstraintName IS NOT NULL
                                EXEC('ALTER TABLE LeaveBalances DROP CONSTRAINT ' + @ConstraintName)

                            SELECT @ConstraintName = Name FROM sys.default_constraints 
                            WHERE parent_object_id = OBJECT_ID('LeaveBalances') 
                            AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('LeaveBalances'), 'CasualLeave', 'ColumnId')
                            IF @ConstraintName IS NOT NULL
                                EXEC('ALTER TABLE LeaveBalances DROP CONSTRAINT ' + @ConstraintName)

                            SELECT @ConstraintName = Name FROM sys.default_constraints 
                            WHERE parent_object_id = OBJECT_ID('LeaveBalances') 
                            AND parent_column_id = COLUMNPROPERTY(OBJECT_ID('LeaveBalances'), 'PaidLeave', 'ColumnId')
                            IF @ConstraintName IS NOT NULL
                                EXEC('ALTER TABLE LeaveBalances DROP CONSTRAINT ' + @ConstraintName)

                            ALTER TABLE LeaveBalances ALTER COLUMN SickLeave FLOAT NOT NULL;
                            ALTER TABLE LeaveBalances ALTER COLUMN CasualLeave FLOAT NOT NULL;
                            ALTER TABLE LeaveBalances ALTER COLUMN PaidLeave FLOAT NOT NULL;

                            -- Re-add default constraints
                            ALTER TABLE LeaveBalances ADD CONSTRAINT DF_LeaveBalances_SickLeave DEFAULT 12.0 FOR SickLeave;
                            ALTER TABLE LeaveBalances ADD CONSTRAINT DF_LeaveBalances_CasualLeave DEFAULT 12.0 FOR CasualLeave;
                            ALTER TABLE LeaveBalances ADD CONSTRAINT DF_LeaveBalances_PaidLeave DEFAULT 18.0 FOR PaidLeave;
                        END
                    ");

                    // Create LeaveRequests Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='LeaveRequests' AND xtype='U')
                        CREATE TABLE LeaveRequests (
                            LeaveId INT IDENTITY(1,1) PRIMARY KEY,
                            EmployeeId INT NOT NULL FOREIGN KEY REFERENCES Employees(EmployeeId) ON DELETE CASCADE,
                            LeaveType VARCHAR(50) NOT NULL,
                            FromDate DATE NOT NULL,
                            ToDate DATE NOT NULL,
                            Reason NVARCHAR(1000) NOT NULL,
                            Status VARCHAR(30) NOT NULL DEFAULT 'Pending',
                            AppliedDate DATETIME2 NOT NULL DEFAULT GETDATE()
                        );");

                    // Create Holidays Table
                    conn.Execute(@"
                        IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Holidays' AND xtype='U')
                        CREATE TABLE Holidays (
                            HolidayId INT IDENTITY(1,1) PRIMARY KEY,
                            HolidayName NVARCHAR(200) NOT NULL,
                            HolidayDate DATE NOT NULL UNIQUE,
                            Description NVARCHAR(500) NULL
                        );");

                    Console.WriteLine("Database tables initialized.");

                    // Seed lookup tables
                    SeedLookupData(conn);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine($"Error initializing database: {ex.Message}");
            }
        }

        private static void SeedLookupData(IDbConnection conn)
        {
            // Seed Departments
            var deptCount = conn.ExecuteScalar<int>("SELECT COUNT(*) FROM Departments");
            if (deptCount == 0)
            {
                conn.Execute("INSERT INTO Departments (Name, Code) VALUES ('Engineering', 'ENG')");
                conn.Execute("INSERT INTO Departments (Name, Code) VALUES ('Human Resources', 'HR')");
                conn.Execute("INSERT INTO Departments (Name, Code) VALUES ('Sales', 'MKT')");
                Console.WriteLine("Departments seeded.");
            }

            // Seed Designations
            var desigCount = conn.ExecuteScalar<int>("SELECT COUNT(*) FROM Designations");
            if (desigCount == 0)
            {
                var engId = conn.ExecuteScalar<int>("SELECT Id FROM Departments WHERE Code = 'ENG'");
                var hrId = conn.ExecuteScalar<int>("SELECT Id FROM Departments WHERE Code = 'HR'");
                var mktId = conn.ExecuteScalar<int>("SELECT Id FROM Departments WHERE Code = 'MKT'");

                conn.Execute("INSERT INTO Designations (Name, DepartmentId) VALUES ('Senior Software Engineer', @DeptId)", new { DeptId = engId });
                conn.Execute("INSERT INTO Designations (Name, DepartmentId) VALUES ('HR Executive', @DeptId)", new { DeptId = hrId });
                conn.Execute("INSERT INTO Designations (Name, DepartmentId) VALUES ('Sales Manager', @DeptId)", new { DeptId = mktId });
                Console.WriteLine("Designations seeded.");
            }

            // Seed Branches
            var branchCount = conn.ExecuteScalar<int>("SELECT COUNT(*) FROM Branches");
            if (branchCount == 0)
            {
                conn.Execute("INSERT INTO Branches (Name, Address) VALUES ('Headquarters (Pune)', '78 Silicon Heights, Hinjewadi, Pune')");
                conn.Execute("INSERT INTO Branches (Name, Address) VALUES ('Branch Office (Bangalore)', '56 Tech Park, Whitefield, Bangalore')");
                Console.WriteLine("Branches seeded.");
            }

            // Seed Employees
            var empCount = conn.ExecuteScalar<int>("SELECT COUNT(*) FROM Employees");
            if (empCount == 0)
            {
                // Admin (Super Admin) - India Shift
                int adminId = conn.ExecuteScalar<int>(@"
                    INSERT INTO Employees (EmployeeCode, FirstName, LastName, Email, MobileNumber, Department, Designation, Branch, JoiningDate, DateOfBirth, Address, Role, PasswordHash, Status, Shift)
                    VALUES ('EMP0001', 'Admin', 'User', 'admin@company.com', '+919876543210', 'Human Resources', 'HR Executive', 'Headquarters (Pune)', '2020-01-01', '1985-05-15', 'Pune Headquarters Campus', 'SuperAdmin', 'Password123', 1, 'India');
                    SELECT CAST(SCOPE_IDENTITY() as int);");

                // HR Manager - UK Shift
                int hrId = conn.ExecuteScalar<int>(@"
                    INSERT INTO Employees (EmployeeCode, FirstName, LastName, Email, MobileNumber, Department, Designation, Branch, JoiningDate, DateOfBirth, Address, Role, PasswordHash, Status, Shift)
                    VALUES ('EMP0002', 'Neha', 'Sharma', 'hr@company.com', '+919876543211', 'Human Resources', 'HR Executive', 'Headquarters (Pune)', '2021-06-15', '1990-08-20', 'Flat 402, Green Glen Layout, Pune', 'HRManager', 'Password123', 1, 'UK');
                    SELECT CAST(SCOPE_IDENTITY() as int);");

                // Employee - US Shift
                int empId = conn.ExecuteScalar<int>(@"
                    INSERT INTO Employees (EmployeeCode, FirstName, LastName, Email, MobileNumber, Department, Designation, Branch, JoiningDate, DateOfBirth, Address, Role, PasswordHash, Status, Shift)
                    VALUES ('EMP0003', 'Rahul', 'Varma', 'employee@company.com', '+919876543212', 'Engineering', 'Senior Software Engineer', 'Headquarters (Pune)', '2022-03-10', '1994-11-05', '78 Silicon Heights, Hinjewadi, Pune', 'Employee', 'Password123', 1, 'US');
                    SELECT CAST(SCOPE_IDENTITY() as int);");

                Console.WriteLine("Employees seeded.");

                // Set Rahul Varma (empId) reporting to Neha Sharma (hrId)
                conn.Execute("UPDATE Employees SET ReportingToId = @ManagerId WHERE EmployeeId = @EmployeeId", new { ManagerId = hrId, EmployeeId = empId });

                // Seed Leave Balances for all 3
                conn.Execute("INSERT INTO LeaveBalances (EmployeeId, SickLeave, CasualLeave, PaidLeave) VALUES (@Id, 12, 12, 18)", new { Id = adminId });
                conn.Execute("INSERT INTO LeaveBalances (EmployeeId, SickLeave, CasualLeave, PaidLeave) VALUES (@Id, 12, 12, 18)", new { Id = hrId });
                conn.Execute("INSERT INTO LeaveBalances (EmployeeId, SickLeave, CasualLeave, PaidLeave) VALUES (@Id, 12, 12, 18)", new { Id = empId });
                Console.WriteLine("Leave balances seeded.");
            }

            // Sync default accounts to Password123 for quick-fill credentials compatibility
            conn.Execute("UPDATE Employees SET PasswordHash = 'Password123' WHERE Email IN ('admin@company.com', 'hr@company.com', 'employee@company.com')");

            // Ensure employee hierarchy is linked in existing databases
            conn.Execute(@"
                UPDATE e
                SET e.ReportingToId = mgr.EmployeeId
                FROM Employees e
                INNER JOIN Employees mgr ON mgr.Email = 'hr@company.com'
                WHERE e.Email = 'employee@company.com' AND e.ReportingToId IS NULL");

            // Force Rahul Varma's birthday to today's date (July 13) for immediate dashboard display verification
            conn.Execute("UPDATE Employees SET DateOfBirth = '1994-07-13' WHERE Email = 'employee@company.com'");

            // Seed Holidays
            var holidayCount = conn.ExecuteScalar<int>("SELECT COUNT(*) FROM Holidays");
            if (holidayCount == 0)
            {
                conn.Execute("INSERT INTO Holidays (HolidayName, HolidayDate, Description) VALUES ('New Year''s Day', '2026-01-01', 'Global celebration of the first day of the year')");
                conn.Execute("INSERT INTO Holidays (HolidayName, HolidayDate, Description) VALUES ('Republic Day', '2026-01-26', 'National day celebrating the republic of India')");
                conn.Execute("INSERT INTO Holidays (HolidayName, HolidayDate, Description) VALUES ('Independence Day', '2026-08-15', 'National day celebrating independence')");
                conn.Execute("INSERT INTO Holidays (HolidayName, HolidayDate, Description) VALUES ('Christmas', '2026-12-25', 'Celebration of Christmas day')");
                Console.WriteLine("Holidays seeded.");
            }
        }
    }
}
