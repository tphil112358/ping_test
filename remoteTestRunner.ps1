<#
.REMOTE TEST RUNNER
    This program automates the test runner call remotely by running a C++ .exe file, making a CSV file from the output, and
    pushing the CSV to github, where it can be accessed. 
#>

function updateCSV
{
    $basePath = "C:\Users\typhi\Desktop\Encap Design\230.12.Ponder\x64\Debug\"  # Base path of the test runner file
    $FileName = "Lab12.exe"

    $csvFilename = "TestResults.csv"

    $outputFullPath = Join-Path -Path $basePath -ChildPath $csvFileName
    $testRunnerFullPath = Join-Path -Path $basePath -ChildPath $FileName

    if (-not (Test-Path $testRunnerFullPath))
    {
        Write-Host "Error: Test runner not found at $testRunnerFullPath"
        exit 1
    }   

    $testOutput = & $testRunnerFullPath 2>&1

    if (-not $testOutput)
    {
        Write-Host "Error: No output captured."
        exit 1
    }

    try
    {
        $formattedOutput | Export-Csv -Path $outputFullPath -NoTypeInformation -Verbose
        Write-Host "Test results saved to $outputFullPath"
    } 
    catch
    {
        Write-Host "Error: Output in incorrect format or contains illegal characters."
        exit 1
    }
}

function gitpush
{
    git add $outputFullPath
    git commit -a -m "Test ran at $((Get-Date).ToString())"
    git push
}

function main
{
    updateCSV
    gitpush
}

main