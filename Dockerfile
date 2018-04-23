#escape=`

# This Dockerfile builds a (64-bit) busybox images which is suitable for
# running many of the integration-cli tests for Docker against a Windows
# daemon. Intended for nanoserver. Busybox is a hacked version....
#
# John Howard (IRC jhowardmsft, Email john.howard@microsoft.com)
#
# To build: docker build -t busybox .
# To publish: Needs someone with publishing rights
#
# http://github.com/jhowardmsft/busybox64


#ADD https://github.com/jhowardmsft/busybox64/raw/master/busybox.exe?raw=true c:\\windows\\system32
#SHELL ["powershell", "-command"]
#RUN cd c:\windows\system32; busybox.exe --list | %{New-Item -ItemType Hardlink -Name $_`.exe -Target busybox.exe 2>&1 | Out-Null}
#SHELL ["cmd", "/S", "/C"]
#ENTRYPOINT ["busybox.exe"]


FROM microsoft/nanoserver
RUN mkdir C:\tmp && mkdir C:\busybox && mkdir C:\powershell
ADD https://github.com/jhowardmsft/busybox64/raw/master/busybox.exe?raw=true /busybox/
RUN curl.exe -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/PowerShell-6.0.2-win-x64.zip" -o c:\powershell.zip
RUN setx /M PATH "C:\busybox;c:\powershell;%PATH%"
RUN cd c:\powershell && tar.exe -xf c:\powershell.zip
RUN pwsh -command busybox.exe --list ^|%{$nul = cmd /c mklink C:\busybox\$_.exe busybox.exe}
ENTRYPOINT ["C:/busybox/busybox.exe"]
