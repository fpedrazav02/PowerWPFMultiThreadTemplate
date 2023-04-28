<#
.Synopsis
 Load XAML file from path and store it into a returned psForm
.DESCRIPTION
 Receives a path to an XML file. Then converts and loads de XML to an XML object ready for use.
.EXAMPLE
 LoadXAML -path '../XML/mainxml.xml'
.EXAMPLE
 LoadXAML -path '../XML/mainxml.xml' -Verbose
.INPUTS
 Path: Fullpath or Relative path work fine
.OUTPUTS
 psform and variables setted
.NOTES
 After Loading the XAML you need to store it in a form and populate all the variables
.COMPONENT
 No component needed
.ROLE
 XAML
.FUNCTIONALITY
 The functionality that best describes this cmdlet
#>

function LoadXml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$xamlpath
    )
    
    begin {
        
    }
    
    process {
        #Sacar content raw y hacer replace para poder crear objeto XML
        $inputXAML = Get-Content -Path $xamlpath -Raw
        $inputXAML=$inputXAML -replace 'mc:Ignorable="d"','' -replace "x:N","N" -replace '^<Win.*','<Window'

        #Crear objeto XML
        [XML]$xaml = $inputXAML

        #Objeto lector del objeto XAML
        $reader = New-Object System.Xml.XmlNodeReader $xaml

        try {
            #tratar de cargar el XAML a un form de PS1
            $psform = [Windows.Markup.XamlReader]::Load($reader)
        }
        catch {
            write-host $_:Exception
            throw
        }
    }

    end {
        $res = @($psform,$xaml)
        return $res
    }
}