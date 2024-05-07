
# step 1
# AS base = create an alias for the base image
# this is going to be used as the image we want to generate for production
# this only includes the runtime
FROM mcr.microsoft.com/dotnet/aspnet AS base
WORKDIR /app

# step 2
# use the sdk image just to build the application
# AS build = create an alias for the build image
FROM mcr.microsoft.com/dotnet/sdk AS build
WORKDIR /src
# copy the .csproj file into the /src working directory
COPY ./ASP.NETCoreDemos.csproj .
RUN dotnet restore "./ASP.NETCoreDemos.csproj"
# copy the rest of the code in
COPY . .
# run the build in release mode
# output to /app/build
# this actually generates an intermediate image behind the scenes
RUN dotnet build "./ASP.NETCoreDemos.csproj" -c Release -o /app/build

# step 3
# use the same build image that was used earlier
# AS publish = create an alias for the publish image
# output to app/publish
# you could include this in previous step, however breaking this out allows you to leverage the caching of layers and intermediate images
# this actually generates an intermediate image behind the scenes
FROM build AS publish
RUN dotnet publish "./ASP.NETCoreDemos.csproj" -c Release -o /app/publish

# step 4
# base is using the base production image that was aliased above
# AS final = create an alias for the final image
# this image only includes the runtime
FROM base AS final
# copy from the publish alias
# get everything in /app/publish and copy it into . (the working directory, which is /app in this case)
# working directory was set in the base image aliasing code block: FROM mcr.microsoft.com/dotnet/aspnet AS base WORKDIR /app
# run dotnet and then run the application's dll
# this only has the artifacts we want in the final image, no debug or leftover files, so it will shrink things down as much as possible
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS=http://*:80
ENV ASPNETCORE_ENVIRONMENT=production
ENTRYPOINT ["dotnet", "ASP.NETCoreDemos.dll"]

# 1. docker build -t aspnetcoredemos:2.0 .
# 2. docker run -d -p 8080:80 aspnetcoredemos:2.0
