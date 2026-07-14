using System.Data;
using Microsoft.Data.SqlClient;
using SmartAttendanceBackend.Data;
using SmartAttendanceBackend.Interfaces;
using SmartAttendanceBackend.Repositories;
using SmartAttendanceBackend.Services;

var builder = WebApplication.CreateBuilder(args);

// Initialize DB and Seed data on startup
DbInitializer.Initialize();

// Inject Database Connection
builder.Services.AddScoped<IDbConnection>(sp => 
    new SqlConnection("Server=(localdb)\\MSSQLLocalDB;Database=SmartAttendanceDb;Trusted_Connection=True;Encrypt=False;"));

// Register Repositories
builder.Services.AddScoped<IEmployeeRepository, EmployeeRepository>();
builder.Services.AddScoped<IAttendanceRepository, AttendanceRepository>();
builder.Services.AddScoped<ILeaveRepository, LeaveRepository>();
builder.Services.AddScoped<IHolidayRepository, HolidayRepository>();
builder.Services.AddScoped<IDashboardRepository, DashboardRepository>();
builder.Services.AddScoped<IReportRepository, ReportRepository>();

// Register Services
builder.Services.AddScoped<IAuthService, AuthService>();
builder.Services.AddScoped<IEmployeeService, EmployeeService>();
builder.Services.AddScoped<IAttendanceService, AttendanceService>();
builder.Services.AddScoped<ILeaveService, LeaveService>();
builder.Services.AddScoped<IHolidayService, HolidayService>();
builder.Services.AddScoped<IDashboardService, DashboardService>();
builder.Services.AddScoped<IReportService, ReportService>();

// Add permissive CORS policy for local Flutter dev calls
builder.Services.AddCors(options =>
{
    options.AddDefaultPolicy(policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

builder.Services.AddControllers();

// Add Swagger Services
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseCors();

// Enable Swagger UI in Development
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "Smart HR System API v1");
        c.RoutePrefix = "swagger"; // Access at http://localhost:5170/swagger/index.html
    });
}

app.UseAuthorization();
app.MapControllers();

app.Run();
