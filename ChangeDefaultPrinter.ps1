
<#PSScriptInfo

.VERSION 1.0

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
Param(
  [Parameter()]
  [string]$StartupAppFile,
)

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'Select the default printer'
$form.Size = New-Object System.Drawing.Size(300,200)
$form.StartPosition = 'CenterScreen'
$form.ControlBox = $false
$form.FormBorderStyle = 'Fixed3d'


$okButton = New-Object System.Windows.Forms.Button
$okButton.Location = New-Object System.Drawing.Point(60,125)
$okButton.Size = New-Object System.Drawing.Size(80,24)
$okButton.Text = 'OK'
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Location = New-Object System.Drawing.Point(150,125)
$cancelButton.Size = New-Object System.Drawing.Size(80,24)
$cancelButton.Text = 'Cancel'
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(10,20)
$label.Size = New-Object System.Drawing.Size(280,20)
$label.Text = 'Printers:'
$form.Controls.Add($label)

$listBox = New-Object System.Windows.Forms.ListBox
$listBox.Location = New-Object System.Drawing.Point(10,40)
$listBox.Size = New-Object System.Drawing.Size(260,20)
$listBox.Height = 80

$printerlist = Get-CimInstance -Class Win32_Printer

Foreach($printer in $printerlist){
  [void] $listBox.Items.Add($printer.Name)
}

$form.Controls.Add($listBox)
$form.Topmost = $true
$result = $form.ShowDialog()

if ($result -eq [System.Windows.Forms.DialogResult]::OK)
{
  $printerselected = $listBox.SelectedItem

  $printer = Get-CimInstance -Class Win32_Printer -Filter "Name='$($printerselected)'"
  Invoke-CimMethod -InputObject $printer -MethodName SetDefaultPrinter
}

c:\Program Files (x86)\Histotrac\Histotrac.exe
