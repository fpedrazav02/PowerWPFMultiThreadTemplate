$func = @( Get-ChildItem -Path $PSScriptRoot\src\*.ps1 -ErrorAction SilentlyContinue )

#Dot source the files
Foreach ($import in @($func)) {
    Try {
        . $import.fullname
    } Catch {
        Write-Error -Message "Failed to import function $($import.fullname): $_"

    }
}
Export-ModuleMember -Function '*'