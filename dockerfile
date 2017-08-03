# escape = `
FROM microsoft/iis:10.0.14393.206
SHELL ["powershell", "-command"]

# Install ASP.NET 4.5
RUN Install-WindowsFeature NET-Framework-45-ASPNET ; `  
    Install-WindowsFeature Web-Asp-Net45

# Remove Default Web Site
RUN Remove-WebSite -Name 'Default Web Site'

# Install Web Deploy 3.6
RUN mkdir C:\install
RUN Invoke-WebRequest -OutFile "C:\install\WebDeploy.msi" -Uri "https://download.microsoft.com/download/0/1/D/01DC28EA-638C-4A22-A57B-4CEF97755C6C/WebDeploy_amd64_en-US.msi"
                      
WORKDIR /install
RUN Start-Process msiexec.exe -ArgumentList '/i c:\install\WebDeploy.msi /qn' -Wait

RUN mkdir C:\webapplication
WORKDIR /webapplication

ADD ./publish/ /webapplication/

RUN Remove-Website -Name 'GuidGenerator'
RUN New-Website -Name GuidGenerator -HostHeader ysovuka.me -PhysicalPath "C:\webapplication" -Port 80

EXPOSE 80