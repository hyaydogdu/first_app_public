using Microsoft.EntityFrameworkCore;
using FirstApp.Api.Data;

var builder = WebApplication.CreateBuilder(args);

// =====================
// Services
// =====================

// Controller kullanacağız
builder.Services.AddControllers();

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Database (SQLite)
builder.Services.AddDbContext<AppDbContext>(options =>
{
    options.UseSqlite("Data Source=firstapp.db");
});

var app = builder.Build();

// =====================
// Middleware
app.UseStaticFiles();
// =====================

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();



// Controller endpoint’lerini aktif et
app.MapControllers();

app.Run();
