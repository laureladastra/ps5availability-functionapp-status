# fetch project directories and files
$parentFolder = Split-Path -Path (Split-Path $PSScriptRoot -Parent) -Parent
$folderItems = Get-ChildItem -Path $parentFolder -Force
$functionFolders = $folderItems | Where-Object { $_.PSIsContainer -and $_.Name -match '^[P]_' }
$systemFolders = 'release', 'tests'
$sourceControlFiles = '.gitattributes', '.gitignore'
$runtimeFiles = 'host.json', 'package.json'
$countryCodes = 'NL', 'BE', 'DE', 'UK', 'US'

Describe 'FunctionApp QA Tests' -Tag 'System' {
    Context 'Repository has the correct structure' {

        It "Directory contains the required source control files: $($sourceControlFiles -join ',')" {
            param(
                $folder = $parentFolder
            )
            $sourceControlFiles | Should -BeIn $folderItems.Where{ -not $_.PSIsContainer }.Name -Because 'root directory should include the required source control files'
        }

        It "Directory contains the required project folders: $($systemFolders -join ',')" {
            $systemFolders | Should -BeIn $folderItems.Where{ $_.PSIsContainer }.Name
        }
    }

    Context 'Azure FunctionApp has the correct structure' {
        $testCases = @($runtimeFiles.ForEach{
                @{file = $_ }
            })
        It "Directory contains the required runtime file: '<file>'" -TestCases $testCases {
            param($file)
            switch ($file) {
                'host.json' { $message = 'file should be present to run the FunctionApp' }
                'package.json' { $message = 'file should be present to install the dependencies' }
                default { $message = 'File should be present in directory' }
            }
            $folderItems.Name | Should -Contain $file -Because $message
        }
    }

    Context 'Azure Functions have the correct structure' {
        $testCases = $functionFolders.ForEach{
            @{
                name     = $_.Name
                fullPath = $_.FullName
            }
        }

        It "Azure Functions folder '<name>' follows naming convention" -TestCases $testCases {
            param ($name)
            $name | Should -MatchExactly "^P_[A-Z][A-Za-z0-9_]+($([regex]::Unescape($countryCodes -join "|")))$" -Because "folder '$($name)' should follow PasCal case naming convention."
        }

        It "Azure Functions folder '<name>' contains the required files" -TestCases $testCases {
            param (
                $fullPath
            )
            'function.json', 'index.js' | Should -BeExactly (Get-ChildItem $fullPath).Name -Because "folder '$($name)' should include the files function.json and index.json"
        }

        $testCases = $functionFolders.ForEach{
            $file = (Get-ChildItem $_.FullName).Where{ $_.Name -eq 'function.json' }
            $fileJson = Get-Content -Path $file -ErrorAction Stop
            @{
                name       = $_.Name
                path       = $_.FullName
                fileJson   = $fileJson ? $fileJson : $null
                fileObject = try {
                    $fileJson | ConvertFrom-Json
                }
                catch {
                    $null
                }

            }
        }

        It "Bindings file for '<name>' contains valid JSON" -TestCases $testCases {
            param($path, $fileJson)
            $validJson = try {
                ($fileJson  | Out-String ) | Test-Json -ErrorAction SilentlyContinue
            }
            catch {
                $false
            }
            $validJson | Should -Be $true -Because "file at $($path) should convert to JSON without parsing errors"
        }

        It "Bindings for '<name>' are properly configured" -TestCases $testCases {
            param($name, $path, $fileObject)
            $binding = $fileObject.bindings
            $bindingType = $binding.type
            $bindingType | Should -Not -BeNullOrEmpty -Because "Azure Function '$($name)' should have bindings configured"
            switch ($bindingType) {
                'timerTrigger' {
                    # all binding properties should be defined
                    $properties = @('name', 'type', 'direction', 'schedule')
                    $properties | Should -BeIn (($binding | Get-Member).Where{ $_.MemberType -eq 'NoteProperty' }).Name
                    # value for binding name should be exact
                    $binding.name | Should -BeExactly 'timer' -Because "timeTrigger binding should be named 'timer'"
                }
            }
        }
    }
}
