# Use the official SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY ["MachineDetailsAPI/MachineDetailsAPI.csproj", "MachineDetailsAPI/"]
RUN dotnet restore "MachineDetailsAPI/MachineDetailsAPI.csproj"

# Copy the application files and build
COPY . .
WORKDIR "/src/MachineDetailsAPI"
RUN dotnet build "MachineDetailsAPI.csproj" -c Release -o /app/build

# Publish the application
FROM build AS publish
RUN dotnet publish "MachineDetailsAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Use the official IIS image as a base
FROM mcr.microsoft.com/windows/servercore/iis

# Create a directory for your application in the container
WORKDIR /inetpub/wwwroot

# Copy the published application files to the container
COPY --from=publish /app/publish .

# Configure IIS to run your application
RUN Remove-Website -Name 'Default Web Site'; \
    New-Website -Name 'myapp' -Port 80 -PhysicalPath 'C:\inetpub\wwwroot' -ApplicationPool '.NET v4.5'

# Start IIS service
CMD [ "C:\\ServiceMonitor.exe", "w3svc" ]

