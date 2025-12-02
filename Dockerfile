# create the build instance 
FROM  mcr.microsoft.com/dotnet/sdk:9.0 AS build
ADD . /nop
WORKDIR /nop
RUN dotnet build -c Release src/Presentation/Nop.Web/Nop.Web.csproj