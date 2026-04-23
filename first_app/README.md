# OnlyFit

OnlyFit is a Flutter + ASP.NET Core fitness app prototype focused on workout creation, weekly planning, and exercise media.

## Project Structure

- `mobile/` - Flutter client
- `backend/FirstApp.Api/` - ASP.NET Core Web API with Entity Framework Core and SQLite
- `ONLYFIT_README.md` - product roadmap and longer planning notes

## Run The Backend

```powershell
cd backend/FirstApp.Api
dotnet restore
dotnet ef database update
dotnet run
```

The API runs on port `5018` in the included launch settings.

## Run The Mobile App

```powershell
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5018
```

Use `10.0.2.2` for the Android emulator. For a physical device, pass your computer's local network IP instead, for example:

```powershell
flutter run --dart-define=API_BASE_URL=http://192.168.1.15:5018
```

## Public Repo Notes

The local SQLite database file is ignored and should not be committed. Recreate it with EF Core migrations using `dotnet ef database update`.
