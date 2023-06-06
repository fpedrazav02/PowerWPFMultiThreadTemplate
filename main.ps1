<#
.SYNOPSIS
    Prueba template funcional
.DESCRIPTION
    Asignaremos los cuatro primeros atributos custom para poder mantener las listas de distribuciÃ³n dinÃ¡micas
.NOTES
    File Name      : main.ps1
    Author         : fpedrazav02
    Prerequisite   : PowerShell V2 over Vista and upper.
.LINK
    Script located at:
    
#>

###################
#                 #
#  DEPENDENCIAS   #
#                 #
###################
Add-Type -AssemblyName PresentationFramework
Import-Module '.\inc' -Verbose -Force


################
#              #         
#    SET UP    #
#              #
################

# Load XAML Files and variables into a SyncHash
    #Create synchornized hash table
$Sync = [Hashtable]::Synchronized(@{})
$Sync.Jobs = [System.Collections.ArrayList]@()

LoadSyncXml -xamlpath '.\XML\login.xaml' -hashtable $Sync -xmlname "login"

###################
#                 #         
#    RUNSPACES    #
#                 #
###################>

<#                          INITIAL SESSION STATE                          #>

# Initial Session State General Settings
$iss = [System.Management.Automation.Runspaces.InitialSessionState]::CreateDefault()
$iss.ExecutionPolicy = 'Unrestricted'
$iss.ApartmentState  = 'STA'
$iss.ThreadOptions = 'ReuseThread'

# Initial Session State Modules
$iss.ImportPSModulesFromPath('.\inc') # Local Module
$iss.ImportPSModule('Active Directory')

# Initial Session State variables
$iss.Variables.Add((New-Object -TypeName System.Management.Automation.Runspaces.SessionStateVariableEntry -ArgumentList 'Sync', $Sync, 'Sincronized Hashtable'))
# Initital Session State SnapIns


<#                          RunspacePool & PowerShell                          #>
$Runspace = [RunspaceFactory]::CreateRunspacePool(1, $env:PROCESSOR_LEVEL + 1, $iss, $Host)
$Runspace.ApartmentState = [Threading.ApartmentState]::STA
$Runspace.Open()

$Sync.login.Add_PreviewKeyDown({
    if ($_.Key -eq 'Escape') {
        $job = [powershell]::Create().AddScript({

            $Sync.login.Dispatcher.Invoke([Action]{
                $Sync.login.Close()
            })
        })
        $job.RunspacePool = $Runspace
        $Handle = $job.BeginInvoke()
        $Sync.Jobs.Add([PSCustomObject]@{
            'Session' = $job
            'Handle' = $Handle
        })
    }
})


$Sync.login.ShowDialog() | Out-Null
