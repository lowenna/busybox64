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

FROM microsoft/nanoserver
RUN mkdir C:\tmp && mkdir C:\bin && mkdir C:\powershell
ADD https://github.com/jhowardmsft/busybox64/raw/master/busybox.exe?raw=true /bin/
RUN curl.exe -fsSL "https://github.com/PowerShell/PowerShell/releases/download/v6.0.2/PowerShell-6.0.2-win-x64.zip" -o c:\powershell.zip
RUN setx /M PATH "C:\bin;c:\powershell;%PATH%"
RUN cd c:\powershell && tar.exe -xf c:\powershell.zip
RUN pwsh -command busybox.exe --list ^|%{$nul = cmd /c mklink C:\bin\$_.exe busybox.exe}
CMD ["sh"]
