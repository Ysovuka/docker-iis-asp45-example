# escape = `

FROM microsoft/iis:10.0.14393.206
SHELL ["powershell"]

RUN Install-WindowsFeature NET-Framework45-ASPNET; `
    Install-WindowsFeature Web-AspNet45



RUN Remove-Website -Name 'Default Web Site'
RUN New-Website -Name 'guidgenerator' -Port 80 `
    -PhysicalPath 'C:\GuidGenerator' -ApplicationPool '.Net v4.5'

EXPOSE 80

CMD ["ping", "-t", "localhost"]