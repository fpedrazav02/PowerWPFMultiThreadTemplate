<#
.SYNOPSIS
    Prueba template funcional
.DESCRIPTION
    Asignaremos los cuatro primeros atributos custom para poder mantener las listas de distribuciÃ³n dinÃ¡micas
.NOTES
    File Name      : DynamicDLAssign.ps1
    Author         : TIC-Typsa
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

$rsPool = [runspacefactory]::CreateRunspace($iss)
$rsPool.Open()

$powerShell = [powershell]::Create()
$powerShell.Runspace = $rsPool

[void]$powerShell.AddScript({
    Add-Type -AssemblyName PresentationFramework
   $Sync.login.ShowDialog()
})

$powerShell.Invoke()
