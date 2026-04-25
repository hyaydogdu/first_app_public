using Microsoft.EntityFrameworkCore;
using FirstApp.Api.Data;
using FirstApp.Api.Data.Seed;

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

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    await db.Database.MigrateAsync();
    await DefaultDataSeeder.SeedAsync(db, app.Environment.ContentRootPath);
}

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
