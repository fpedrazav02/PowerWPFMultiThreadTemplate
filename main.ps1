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
#    CODIGO    #
#              #
################

# Load XAML Files and variables into a SyncHash
    #Create synchornized hash table
$Sync = [Hashtable]::Synchronized(@{})

LoadSyncXml -xamlpath '.\XML\login.xaml' -hashtable $Sync -xmlname "login"

