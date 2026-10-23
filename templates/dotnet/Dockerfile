# Match the image version (10.0) to your project's TargetFramework,
# e.g. a net8.0 project needs sdk:8.0 and aspnet:8.0.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
COPY . .
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app/publish .
USER $APP_UID
EXPOSE 8080
# Change MyApp.dll to your project's output
ENTRYPOINT ["dotnet", "MyApp.dll"]
