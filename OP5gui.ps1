Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$ALL_GUI_FONT = 'Microsoft Sans Serif'
$ALL_GUI_FONT_SIZE = 10
$ALL_GUI_BG_COLOR = "#f0f0f0"

$Form_Dummy1                            = New-Object system.Windows.Forms.Form
$Form_Dummy1.ClientSize                 = New-Object System.Drawing.Point(800,400)
$Form_Dummy1.text                       = "Main Password Generator Window"
$Form_Dummy1.TopMost                    = $false
$Form_Dummy1.BackColor                  = $ALL_GUI_BG_COLOR


$Panel_Dummy1                          = New-Object system.Windows.Forms.Panel
$Panel_Dummy1.height                   = 400
$Panel_Dummy1.width                    = 800
$Panel_Dummy1.Anchor                   = 'top,right,left'
$Panel_Dummy1.location                 = New-Object System.Drawing.Point(4,4)

$Button_Dummy1                         = New-Object system.Windows.Forms.Button
$Button_Dummy1.text                    = "OP5"
$Button_Dummy1.width                   = 90
$Button_Dummy1.height                  = 70
$Button_Dummy1.location                = New-Object System.Drawing.Point(140,10)
$Button_Dummy1.Font                    = New-Object System.Drawing.Font($ALL_GUI_FONT,$ALL_GUI_FONT_SIZE)

$CharLabels                          = New-Object System.Windows.Forms.RichTextBox
$CharLabels.text                     = 'dfddfdf'
$CharLabels.AutoSize                 = $true
$CharLabels.width                    = 780
$CharLabels.height                   = 290
$CharLabels.location                 = New-Object System.Drawing.Point(5,100)
$CharLabels.Font                     = New-Object System.Drawing.Font($ALL_GUI_FONT,$ALL_GUI_FONT_SIZE)
$CharLabels.BorderStyle              = "None"

$Form_Dummy1.controls.AddRange(@($Panel_Dummy1))
$Panel_Dummy1.controls.AddRange(@($Button_Dummy1, $CharLabels))

$Button_Dummy1.Add_Click({ $CharLabels.text = Show-QueryResults | Format-Table -AutoSize | Out-String })
#$Button_Dummy1.Add_Click({ Show-QueryResults })

[void]$Form_Dummy1.ShowDialog()



function Get-Query {

$apiBaseURL = 'https://op5.dqe.com/api/'
$apiAction = 'filter/query?query='
$apiQuery = '[downtimes] author="jban" and comment ~~ "INC" '

$endpoint = $apiBaseURL + $apiAction + $apiQuery

$appName = "op5".ToUpper()
$secretLoc = 'C:\Users\Public\secretFolder\secretfile_' + $appName + '.txt'
$op5Cred = Import-Clixml -Path $secretLoc

$username = $op5Cred.UserName
$password = $op5Cred.Password


$apiCallParams = @{
    Method     = 'Get'
    Uri        = "$endpoint"
    Credential = $op5Cred
}

$queryResult = (Invoke-RestMethod @apiCallParams | Out-String)


#$queryResult = 'pickles'



return $queryResult


}


function Show-QueryResults {

$CharLabels.text = "Loading..."

$queryToDisplay = (Get-Query)

Write-Host $queryToDisplay + 'y'

$CharLabels.text = $queryToDisplay
$CharLabels.Refresh()


}