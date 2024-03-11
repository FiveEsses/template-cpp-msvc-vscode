param(
    $configuration,
    $exportparam
)
$exportExe = 0
$isRelease = 1
if ($configuration -eq "debug")
{
    $isRelease = 0
}
if ($exportparam -ne '')
{
    echo "Exporrting EXEs..."
    $exportExe = 1
}

$initialPath = $PSScriptRoot

Write-Host "Building All C++ projects..."

$projectPath = "${PSScriptRoot}\projects"
$table = get-ChildItem -Path $projectPath -Force -Directory

foreach ($row in $table)
{
    Write-Host ""
    $foldername = $row.Name
    $dirname = Join-Path $projectPath $foldername
    if (!(Test-Path -Path "$dirname\main.cpp" -PathType leaf))
    {
        Write-Warning "   Skipping project '$foldername' -- No main.cpp found."
        continue
    }
    Write-Host "   Building project '$foldername'..."

    $binName = Join-Path $dirname '__bin'
    $tempName = Join-Path $dirname '__temp'
    if (Test-Path $binName)
    {
        Remove-Item -Path $binName -Recurse -Force
    }
    mkdir $binName
    if (!(Test-Path $tempName))
    {
        mkdir $tempName
    }
    else
    {
        Write-Host -NoNewLine "      Cleaning... "
        Remove-Item -Path "$tempName\*" -Recurse -Force
        Write-Host "Clean."
    }

    Write-Host -NoNewLine "      Prepping... "
    Get-ChildItem -Path $dirname -Exclude "$tempName" -Include "*.h", "*.cpp" -Recurse -File | Copy-Item -Destination "$tempName"
    Write-Host "Prepped."
    Write-Host -NoNewLine "      Building... "

    Set-Location -Path $binName

    if ($isRelease)
    {
        Invoke-Expression "& 'cl.exe' /EHsc /nologo /Fe${binName}\${foldername}.exe ${tempName}/**.cpp";
    }
    else
    {
        Invoke-Expression "& 'cl.exe' /Zi /EHsc /nologo /Fe${binName}\${foldername}.exe ${tempName}/**.cpp";
    }

    Set-Location -Path $initialPath

    if ($exportExe)
    {
        $exportPath = "${dirname}\__export"
        if (!(Test-Path $exportPath))
        {
            mkdir $exportPath
        }
        Remove-Item -Path "$exportPath\*" -Recurse -Force
        Copy-Item -Path "${binName}\${foldername}.exe" -Destination "${exportPath}" -Force
    }

    Write-Host "Built."
}

Write-Host ""
Write-Host "All C++ projects built."
Write-Host ""
Write-Host ""