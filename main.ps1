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

Import-Module '.\inc' -Verbose -Force


################
#              #         
#    CODIGO    #
#              #
################

# Call the function to display the prompt
ShowPrompt
SayHi