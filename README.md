![PowerShell](https://img.shields.io/badge/Powershell-5.1.19-blue.svg?style=flat)

<!-- PROJECT BANNER -->
<br/>

![Banner](./docs/banner-powershell.png)

<p>
  <h4 align="center">Windows Change Default Printer Script</h4>
</p>

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Introduction](#introduction)
- [Project Requeriments](#project-requirements)
- [Technology](#technology)
- [Getting Started](#getting-started)
  - [Install the Repository](#install-the-repository)
  - [Install the Script](#install-the-script)
  - [Params](#params)
  - [Script test](#script-test)
  - [Possibilities in using the script](#possibilities-in-using-the-script)
- [Useful Links](#useful-links)

## Introduction

A powershell script to manage the default printer change process at software startup

## Project Requirements

You will only need an windows machine to run the script and a list of available printers so you can have more than 1 to choose from

## Technology

What was used:

- **[PowerShell](https://learn.microsoft.com/en-us/powershell/)** PowerShell is a cross-platform task automation solution made up of a command-line shell, a scripting language, and a configuration management framework.

## Getting Started

The following steps will be necessary for you to run the script

### Install the Repository

First we need to configure the powershell gallery repository so we can download the scripts from there

This is pretty easy for Powershell v5+ :

```powershell
#I add the switch Trusted because I trust all the modules and scripts from Powershell Gallery
Register-PSRepository -Default -InstallationPolicy Trusted
```

For Powershell with version less than v5:

```powershell
Register-PSRepository -Name PSGallery -SourceLocation https://www.powershellgallery.com/api/v2/ -InstallationPolicy Trusted
```

And now to be able to test if it was successfully installed, run the command below:

```powershell
Get-PSRepository
```

Expected would be something like this:

```powershell
Name                      InstallationPolicy   SourceLocation
----                      ------------------   --------------
PSGallery                 Trusted              https://www.powershellgallery.com/api/v2/
```

Now with the repository available we can install it in the next step

### Install the Script

In this step we will install the script on our local machine, follow the command below to install it:

```powershell
Install-Script -Name change-default-printer
```

---

**Note**: it will ask you if you want to proceed, when answering in the payload it will show the location where the script was installed

---

After installing it is possible for you to check the script and its information, run the command below:

```powershell
Get-InstalledScript -Name "change-default-printer" | Format-List *
```

---

**Note**: and remembering that the script is being downloaded from this repository [here](https://www.powershellgallery.com/packages/change-default-printer/1.1)

---

### Params

In this session you will see what parameters the script supports and their details

| Name           | Description                                                                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
| StartupAppFile | Specifies if after selecting the default printer which program should be opened, if nothing is passed it will terminate the script process after finishing |

### Script Test

Now we will test the script in two ways, which are listed below:

- Start the script, select the printer and finish without any further action
- Start the script, select the printer and open the Google Chrome

For the first test you can run the following command:

```powershell
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -File C:\Program Files\WindowsPowerShell\Scripts\Change-Default-Printer.ps1
```

What is expected will be to open a modal for you to select the desired printer, then when clicking ok the function will be performed and the modal will be closed without any other action

Now in the second test we will want to start google chrome as an example after selecting the default printer, run the following command:

```powershell
C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -WindowStyle hidden -File C:\Program Files\WindowsPowerShell\Scripts\Change-Default-Printer.ps1 -StartupAppFile "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
```

The expected is that after you select the default printer you will have google chrome started.

---

**Note**: (WindowStyle hidden) param is recommended because it makes the script more presentable, without having to be looking at the powershell console all the time.

---

### Possibilities in using the script

The script has certain possibilities that you can work with and they are:

- create a shortcup of the script and when selecting the printer open a specific program to which you need to make sure the correct printer will be selected before opening it
- after some event in windows run the script to select the default printer
- use of complement to the function of another script

and where you can make it run, the possibilities end up being diverse, the ones I mentioned above are the ones I needed to create the script.

# Useful Links

- **[Powershell](https://learn.microsoft.com/en-us/powershell/)**
- **[Powershell Gallery](https://www.powershellgallery.com/)**
