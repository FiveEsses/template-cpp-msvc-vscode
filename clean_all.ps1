Write-Host "Cleaning All CPP projects..."
Write-Host ""

Get-ChildItem '.\' -Recurse -Force -Directory -Include '__bin', '__temp', "__export" | Remove-Item -Recurse -Force

Write-Host ""
Write-Host "All C++ projects clean."
Write-Host ""
Write-Host ""