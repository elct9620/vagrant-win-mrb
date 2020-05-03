# Visual Studio
$vsVersion = '2019'
$vsInstallerPath = "$env:TEMP\vs_community.exe"
$vsInstallerURL = 'https://download.visualstudio.microsoft.com/download/pr/678ef909-70fd-4fe7-85e4-3e09c8d07439/f316d55ca8483219c67acf4140b507c8/vs_community.exe'
$vsHome = "C:\VisualStudio\$vsVersion\Community"
$vsInstallOptions = "--installPath $vsHome",
                    "--quiet", "--wait",
                    "--add Microsoft.VisualStudio.Component.Git",
                    "--add Microsoft.Component.VC.Runtime.UCRTSDK",
                    "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64",
                    "--add Microsoft.VisualStudio.Component.Windows10SDK.17763"

# Ruby
$rubyVersion = '2.7.1-1'
$rubyInstallerPath = "$env:TEMP\ruby_installer.exe"
$rubyInstallerURL = "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$rubyVersion/rubyinstaller-devkit-$rubyVersion-x64.exe"
$rubyHome = 'C:\Ruby27-x64'

# Bison
$bisonVersion = '2.4.1'
$bisonInstallerPath = "$env:TEMP\bison_installer.exe"
$bisonInstallerURL = "https://nchc.dl.sourceforge.net/project/gnuwin32/bison/$bisonVersion/bison-$bisonVersion-setup.exe"
$bisonHome = 'C:\GnuWin32'

# Vim
$vimVersion = '8.2.0671'
$vimInstallerPath = "$env:TEMP\vim_installer.exe"
$vimInstallerURL = "https://github.com/vim/vim-win32-installer/releases/download/v$vimVersion/gvim_$($vimVersion)_x64.exe"
# NOTE: Unable change NSIS install Dir
$vimHome = 'C:\Program Files\Vim\vim82'

# GIT
$gitVersion = '2.26.2'
$gitInstallerPath = "$env:TEMP\git_installer.exe"
$gitInstallerURL = "https://github.com/git-for-windows/git/releases/download/v$gitVersion.windows.1/Git-$gitVersion-64-bit.exe"
$gitHome = 'C:\Git26-x64'

# Functions
function Install {
  Param([string] $Package, [string] $Url, [string] $Path, [string[]] $Arguments)
  Process {
    $job = Start-Job -ScriptBlock {
      Param($Package, $Url, $Path, $Arguments)
      # Download
      Write-Host "Downloading $Package Installer"
      (New-Object System.Net.WebClient).DownloadFile($Url, $Path)

      # Install
      Write-Host "Installing $Package"
      (Start-Process -FilePath $Path -ArgumentList $Arguments -PassThru -Wait | Out-Null)
    } -ArgumentList $Package, $Url, $Path, $Arguments
    return $job
  }
}

# Processing
$jobs = (Install "Visual Studio $vsVersion Community" -Url $vsInstallerURL -Path $vsInstallerPath -Arguments $vsInstallOptions),
        (Install "Ruby $rubyVersion" -Url $rubyInstallerURL -Path $rubyInstallerPath -Arguments "/silent", "/dir=$rubyHome", "/tasks=modpath"),
        (Install "Bison $bisonVersion" -Url $bisonInstallerURL -Path $bisonInstallerPath -Arguments "/silent", "/dir=$bisonHome", "/tasks=modpath"),
        (Install "Vim $vimVersion" -Url $vimInstallerURL -Path $vimInstallerPath -Arguments "/S", "/D=$vimHome"),
        (Install "Git $gitVersion" -Url $gitInstallerURL -Path $gitInstallerPath -Arguments "/silent", "/dir=$gitHome", "/tasks=modpath")

Receive-Job $jobs -Wait -AutoRemoveJob

# Environments
Write-Host 'Setup Environment Path'
$oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newPath = "$oldPath;$bisonHome\bin;$vimHome;$gitHome\bin"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath
