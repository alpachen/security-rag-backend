# ===============================
# STEP 1: Build the .NET project
# ===============================
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# copy csproj & restore dependency
COPY *.csproj ./
RUN dotnet restore

# copy everything & build
COPY . .
RUN dotnet publish -c Release -o /app

# ===============================
# STEP 2: Run the published app
# ===============================
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app

COPY --from=build /app .

# Expose port (Render uses 10000 internally)
EXPOSE 8080

# Tell ASP.NET to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "WebAPI.dll"]
