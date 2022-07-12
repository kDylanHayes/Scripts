#Disable Java 
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bDisableJavaScript
#REG_DWORD value: 1

#Disable Flash
#HKLM\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown\bEnableFlash
#REG_DWORD value: 0 

#Disable Java on DC
#HKLM\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\bDisableJavaScript
#To the following REG_DWORD value:
#REG_DWORD value: 1

$regs = @(
    @{Path = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"; Type = "Dword"; Name = "bDisableJavaScript"; Value = "1" },
    @{Path = "HKLM:\SOFTWARE\Policies\Adobe\Acrobat Reader\DC\FeatureLockDown"; Type = "Dword"; Name = "bEnableFlash"; Value = "0" },
    @{Path = "HKLM:\SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown"; Type = "Dword"; Name = "bDisableJavaScript"; Value = "1" }) | % { New-Object object | Add-Member -NotePropertyMembers $_ -PassThru }

try {
    foreach ($reg in $regs) {

        #Skip if the Path does not exist
        if (-not(Test-Path $reg.Path)) { continue }

        $testreg = (Get-ItemProperty -Path $reg.Path).$($reg.Name)

        if ($testreg -ne $reg.Value) {
            #Below necessary for Intune as of 10/2019 will only remediate Exit Code 1
            write-host "Start remediation - $($reg.Path) - $($reg.Name)"
            exit 1
        }
    }
    exit 0
}
catch {
    $errMsg = $_.Exception.Message
    Write-Error $errMsg
    exit 1
}