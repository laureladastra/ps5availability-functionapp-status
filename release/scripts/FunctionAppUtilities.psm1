function Set-FunctionAppTimeBinding {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]$Path,
        [Parameter(Mandatory = $true)]
        [System.String]$FunctionName,
        [Parameter(Mandatory = $true)]
        [System.String]$CronExpression,
        [Parameter(Mandatory = $false)]
        [System.String]$FilePath = "$Path/$FunctionName/function.json"
    )
    try {
        $file = Get-Content -Path $FilePath -Raw | ConvertFrom-Json
        $file.bindings[0].schedule = $CronExpression
        $file | ConvertTo-Json -Depth 32 | Set-Content -Path $FilePath -Force
    }
    catch {
        Write-Error "An issue occured when renaming the bindings" -ErrorAction Stop
    }
}

Export-ModuleMember -Function *
