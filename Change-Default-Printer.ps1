
<#PSScriptInfo

.VERSION 1.5

.GUID 9e0fe95d-a694-43d3-a972-c1779868af7e

.AUTHOR kledenai

.COMPANYNAME

.COPYRIGHT

.TAGS printer

.LICENSEURI

.PROJECTURI https://github.com/Kledenai/windows-change-default-printer

.ICONURI

.EXTERNALMODULEDEPENDENCIES

.REQUIREDSCRIPTS

.EXTERNALSCRIPTDEPENDENCIES

.RELEASENOTES

.PRIVATEDATA

#>

<#

.DESCRIPTION
 This script is used to automate the process of changing the default printer, either when starting a specific program, at machine startup or at any time

#>

# setting the parameters that will be expected on the command line by the user who will configure the script
#
Param(
  [Parameter()]
  [string]$StartupAppFile
)

# instantiating the variable that will be used to store the list of printers for a comparision with the printer selected
#
[System.Collections.ArrayList]$printerhistory = @()

# instantiating the function that will be used to get the list of all printers in the machine
#
Function GetListPrinters {
  try {
    # clear the listbox items and printerhistory to reload without duplicated items
    #
    $printerhistory.Clear()
    $listBox.Items.Clear()

    # get all printers listed on the machine
    #
    $printerlist = Get-CimInstance -Class Win32_Printer

    # loop to load the printer take the machine in the listbox, and taking advantage of the loop to add the machine
    # to be placed in the $printerhistory along with the information if it is shared or not
    #
    Foreach($printer in $printerlist){
      [void] $listBox.Items.Add((&{if($printer.shared){$printer.ShareName} else {$printer.Name}}))
      [void] $printerhistory.Add((&{if($printer.shared){[pscustomobject]@{Name=$printer.ShareName;Shared=$true}} else {[pscustomobject]@{Name=$printer.Name;Shared=$false}}}))
    }

    # setting the first item of the listbox as default
    #
    $listBox.SetSelected(0,$true)
  } catch {
    Write-Host "An error occurred:"
    Write-Host $_
  }
}

# declaring the Microsoft .NET Core class in the script session
#
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# instantiating and configuring the form to which the components that will come below will be placed
#
$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select the default printer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'
$form.ControlBox = $false
$form.FormBorderStyle = 'Fixed3d'

# configuring the ok button that will execute the rest of the functions as soon as you select the desired printer
#
$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(60,125)
$okButton.Size = New-Object System.Drawing.Size(80,24)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK

$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

# configuring the cancel button in case the user wants to abort when opening the modal without any other action being done
#
$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,125)
$cancelButton.Size = New-Object System.Drawing.Size(80,24)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel

$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

# configuring the reload button to reload the list of printers
#
$reloadButton = New-Object System.Windows.Forms.Button
$reloadButton.Location = New-Object System.Drawing.Point(247, 10)
$reloadButton.Size = New-Object System.Drawing.Size(24,24)
$reloadButton.Font = New-Object System.Drawing.Font("Cambria Math", 11, [System.Drawing.FontStyle]::Regular);
$reloadButton.Text = "↻"
$reloadButton.TextAlign = "MiddleRight"
$reloadButton.Padding = New-Object System.Windows.Forms.Padding(0,2,0,0)
$reloadButton.Add_Click({GetListPrinters})

$form.AcceptButton = $reloadButton
$form.Controls.Add($reloadButton)

# configuring the label which will appear on top of the listbox stating that they are the printers below
#
$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Printers:'

$form.Controls.Add($label)

# configuring the listbox component which will show the list of printers for the user to select
#
$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

$form.Controls.Add($listBox)

# run the function to get the list of printers
#
GetListPrinters | Out-Null

# forcing the modal to always be above any other program when it runs
#
$form.Topmost = $true

# instatiating the action inside the form to be added in the if statement if OK is triggered
#
$result = $form.ShowDialog()

# setting the trycatch in case an error occurs within thi function
#
try {

  # checking if the ok button was selected, once it is selected the other actions below will be executed
  #
  if ($result -eq [System.Windows.Forms.DialogResult]::OK) {

    # searching within the history for the selected printer in the listbox
    #
    $printerinfo = $printerhistory -match $listBox.SelectedItem

    # getting all the printer data and instantiating it in a variable
    #
    $printer = Get-CimInstance -Class Win32_Printer -Filter (&{if($printerinfo.shared){"ShareName='$($printerinfo.name)'"}else{"Name='$($printerinfo.name)'"}})

    # seting the selected printer as default
    #
    Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter

    # checking if the $StartupAppFile parameter wa passed, if so, the process will be executed
    #
    if ($StartupAppFile) {

      # starting the process based on the .exe file tgat was passed in the parameter
      #
      Start-Process $StartupAppFile
    }
  }
} catch {

  # writing to the console the error that is occurring, basically catching everything that occurs
  #
  Write-Host "An error occurred:"
  Write-Host $_
}
