<#
.Synopsis
 Load XAML file from path and store it into a sync hashtable
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

function LoadSyncXml {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)][string]$xamlpath,
        [Parameter(Mandatory=$true)][hashtable]$hashtable,
        [Parameter(Mandatory=$true)][string]$xmlname
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
            $Sync.$xmlname = [Windows.Markup.XamlReader]::Load($reader)
        }
        catch {
            write-host $_:Exception
            throw
        }
        #Cargar en la hash table los objetos del XAML para no tener que meterte dentro de $Sync.Window1.Content.ChildeItems...
        $name = "$($xmlname)_obj"
        $Sync.$name = @{}
        $xaml.SelectNodes("//*[@Name]") | ForEach-Object {

            try {
                $Sync.$name.Add($_.Name,$Sync.$xmlname.FindName($_.Name))
            }
            catch {
                throw
            }
        }
    }
    end {
        Write-Verbose "Importado con exito"
    }
}
