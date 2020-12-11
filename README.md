# Introduction

This is a clone of  [Microsoft/WSL-DistroLauncher](https://github.com/Microsoft/WSL-DistroLauncher) and merged from [bilguun0203/WSL-ArchLinux](https://github.com/bilguun0203/WSL-ArchLinux) 
to use Arch Linux as a Windows Subsystem for Linux (WSL2)

Use scripts to build the rootfs from arch bootstrap package, according to the [config in ArchLinuxFS](https://github.com/bilguun0203/ArchLinuxFS/blob/master/.travis.yml) but without any third party built package.

# Steps

## short version
1. build fs (install.tar.gz)
2. build sln 
3. install 

## step by step

1. Install a wsl2 system from Microsoft Store (Unbutu for example)
2. Download an arch bootstrap package  (archlinux-bootstrap-2020.12.01-x86_64.tar.gz for example) from any arch mirror you like. Put it into the directory GenerateFS 
3. login to the installed wsl2 system
4. copy the GenerateFS dir to a temp dir
5. decompress the bootstrap package (use sudo)
    ```
    sudo tar -zxpf archlinux-bootstrap-2020.12.01-x86_64.tar.gz
    ```
6. run the `compile-0.sh` get a rootfs at `out/install.tar.gz`
7. copy the `install.tar.g`z int to this workspace's `x64` direcotry, 
8. build the workspace and install, you could get an usable `arch.exe`
9. run `arch.exe install` , create user and set password
10. now , you got an running wls2 arch linux system. 
11. If you would like a pure bootstrapped system(use pacstrap):

    11.1 login into he new new ArchLinux system as root
    
       ```
       # open a powershell
       arch.exe config --defualt-user root
       arch.exe
      
       ```
    11.1. repeat step 4, step5,  use `compile-1.sh` at step 6 to do bootstrap
    
    11.2. copy the new `install.tar.gz` and rebuild workspace 
    
    11.3. remove old ArchLinux application and install the new one

To get more details, check the scripts, enjoy :)

# Buidl and Install Laucher:

## Getting Started
1. Generate a test certificate:
    1. In Visual Studio, open `DistroLauncher-Appx/MyDistro.appxmanifest`
    1. Select the Packaging tab
    1. Select "Choose Certificate"
    1. Click the Configure Certificate drop down and select Create test certificate.

2. Edit your distribution-specific information in `DistributionInfo.h` and `DistributionInfo.cpp`. **NOTE: The `DistributionInfo::Name` variable must uniquely identify your distribution and cannot change from one version of your app to the next.**
    > Note: The examples for creating a user account and querying the UID are from an Ubuntu-based system, and may need to be modified to work appropriately on your distribution.

3.  Add an icon (.ico) and logo (.png) to the `/images` directory. The logo will be used in the Start Menu and the taskbar for your launcher, and the icon will appear on the Console window.
    > Note: The icon must be named `icon.ico`.

4. Pick the name you'd like to make this distro callable from the command line. For the rest of the README, I'll be using `mydistro` or `mydistro.exe`. **This is the name of your executable** and should be unique.

5. Make sure to change the name of the project in the `DistroLauncher-Appx/DistroLauncher-Appx.vcxproj` file to the name of your executable we picked in step 4. By default, the lines should look like:

``` xml
<PropertyGroup Label="Globals">
  ...
  <TargetName>mydistro</TargetName>
</PropertyGroup>
```

So, if I wanted to instead call my distro "TheBestDistroEver", I'd change this to:
``` xml
<PropertyGroup Label="Globals">
  ...
  <TargetName>TheBestDistroEver</TargetName>
</PropertyGroup>
```

> Note: **DO NOT** change the ProjectName of the `DistroLauncher/DistroLauncher.vcxproj` from the value `launcher`. Doing so will break the build, as the DistroLauncher-Appx project is looking for the output of this project as `launcher.exe`.

6.  Update `MyDistro.appxmanifest`. There are several properties that are in the manifest that will need to be updated with your specific values:
    1. Note the `Identity Publisher` value (by default, `"CN=DistroOwner"`). We'll need that for testing the application.
    1. Ensure `<desktop:ExecutionAlias Alias="mydistro.exe" />` ends in ".exe". This is the command that will be used to launch your distro from the command line and should match the executable name we picked in step 4.
    1. Make sure each of the `Executable` values matches the executable name we picked in step 4.

7. Copy your tar.gz containing your distro into the root of the project and rename it to `install.tar.gz`.

## Setting up your Windows Environment
You will need a Windows environment to test that your app installs and works as expected. To set up a Windows environment for testing you can follow the steps from the [Windows Dev Center](https://developer.microsoft.com/en-us/windows/downloads/virtual-machines).

> Note: If you are using Hyper-V you can use the new VM gallery to easily spin up a Windows instance.

Also, to allow your locally built distro package to be manually side-loaded, ensure you've enabled Developer Mode in the Settings app (sideloading won't work without it). 

## Build and Test

To help building and testing the DistroLauncher project, we've included several scripts to automate some tasks. You can either choose to use these scripts from the command line, or work directly in Visual Studio, whatever your preference is. 

> **Note**: some sideloading/deployment steps don't work if you mix and match Visual Studio and the command line for development. If you run into errors while trying to deploy your app after already deploying it once, the easiest step is usually just to uninstall the previously sideloaded version and try again. 

### Building the Project (Command line):
To compile the project, you can simply type `build` in the root of the project to use MSBuild to build the solution. This is useful for verifying that your application compiles. It will also build an appx for you to sideload on your dev machine for testing.

> Note: We recommend that you build your launcher from the "Developer Command Prompt for Visual Studio" which can be launched from the start menu. This command-prompt sets up several path and environment variables to make building easier and smoother.

`build.bat` assumes that MSBuild is installed at one of the following paths:
`%ProgramFiles*%\MSBuild\14.0\bin\msbuild.exe` or
`%ProgramFiles*%\Microsoft Visual Studio\2017\Enterprise\MSBuild\15.0\Bin\msbuild.exe` or
`%ProgramFiles*%\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe`.

If that's not the case, then you will need to modify that script.

Once you've completed the build, the packaged appx should be placed in a directory like `WSL-DistroLauncher\x64\Release\DistroLauncher-Appx` and should be named something like `DistroLauncher-Appx_1.0.0.0_x64.appx`. Simply double click that appx file to open the sideloading dialog. 

You can also use the PowerShell cmdlet `Add-AppxPackage` to register your appx:
``` powershell
powershell Add-AppxPackage x64\Debug\DistroLauncher-Appx\DistroLauncher-Appx_1.0.0.0_x64_Debug.appx
```

### Building Project (Visual Studio):

You can also easily build and deploy the distro launcher from Visual Studio. To sideload your appx on your machine for testing, all you need to do is right-click on the "Solution (DistroLauncher)" in the Solution Explorer and click "Deploy Solution". This should build the project and sideload it automatically for testing.

In order run your solution under the Visual Studio debugger, you will need to copy your install.tar.gz file into your output folder, for example: `x64\Debug`. **NOTE: If you have registered your distribution by this method, you will need to manually unregister it via wslconfig.exe /unregister**

### Installing & Testing
You should now have a finished appx sideloaded on your machine for testing.

To install your distro package, double click on the signed appx and click "Install". Note that this only installs the appx on your system - it doesn't unzip the tar.gz or register the distro yet. 

You should now find your distro in the Start menu, and you can launch your distro by clicking its Start menu tile or executing your distro from the command line by entering its name into a Cmd/PowerShell Console.

When you first run your newly installed distro, it is unpacked and registered with WSL. This can take a couple of minutes while all your distro files are unpacked and copied to your drive. 

Once complete, you should see a Console window with your distro running inside it.

## Contents
This reference launcher provides the following functionality:
(where `arch.exe` is replaced by the distro-specific name)

* `arch.exe`
  - Launches the user's default shell in the user's home directory.

* `arch.exe install [--root]`
  - Install the distribution and do not launch the shell when complete.
    - `--root`: Do not create a user account and leave the default user set to root.

* `arch.exe run <command line>`
  - Run the provided command line in the current working directory. If no command line is provided, the default shell is launched.
  - Everything after `run` is passed to WslLaunchInteractive.

* `arch.exe config [setting [value]]`
  - Configure settings for this distribution.
  - Settings:
    - `--default-user <username>`: Sets the default user to <username>. This must be an existing user.

* `arch.exe help`
  - Print usage information.


