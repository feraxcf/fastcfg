# Ejecution commands

## Windows
~~~ps1
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
$rawUrl = "https://raw.githubusercontent.com/feraxcf/fastcfg/refs/heads/main/windows.ps1"
Invoke-Expression (Invoke-WebRequest -Uri $rawUrl).Content
~~~

