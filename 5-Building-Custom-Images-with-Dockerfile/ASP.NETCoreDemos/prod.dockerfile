FROM mcr.microsoft.com/dotnet/aspnet
WORKDIR /app
COPY ./publish .

# ensure we listen on any IP Address 
# can't access the web app in the container by using localhost b/c
# the container is really a different machine, so localhost points to your computer
# not the web app in the container
#ENV DOTNET_URLS=http://+:80
ENV ASPNETCORE_URLS=http://*:80

ENTRYPOINT ["dotnet", "ASP.NETCoreDemos.dll"]

#1. dotnet publish "./ASP.NETCoreDemos.csproj" -c Release -o ./publish   
#2. docker build -f prod.dockerfile -t aspnetcoredemos:1.0 .
#3. docker run -d -p 8080:80 aspnetcoredemos:1.0