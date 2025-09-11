param (
    [string]$sourceFile,
    [string]$dump,
    [string]$zipalign
)

# 定义源文件和目标文件
$tempDir = "temp"
$outputDir = "temp/output"

# 检查命令行参数是否传入
if ([string]::IsNullOrEmpty($sourceFile)) {
    Write-Host "error: please define the source file by powershell terminal."
    Write-Host "usage: ./foobar.ps1 -sourceFile 'foo/bar/foobar.apk'"
    exit
}

if ([string]::IsNullOrEmpty($dump)) {
    Write-Host "error: llvm-objdump.exe path error."
    Write-Host "usage: ./foobar.ps1 -dump foo/bar/bin/llvm-objdump.exe"
    Write-Host "example path: 'C:\Program Files\Unity\Hub\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\NDK\toolchains\llvm\prebuilt\windows-x86_64\bin\llvm-objdump.exe'"
    exit
}

if ([string]::IsNullOrEmpty($zipalign)) {
    Write-Host "error: zipalign.exe path error."
    Write-Host "usage: ./foobar.ps1 -zipalign foo/bar/bin/zipalign.exe"
    Write-Host "example path: 'C:\Program Files\Unity\Hub\Editor\2022.3.62f1\Editor\Data\PlaybackEngines\AndroidPlayer\SDK\build-tools\35.0.0\zipalign.exe'"
    exit
}

# 检查源文件是否存在

if (-not (Test-Path $sourceFile)) {
    Write-Host "Error: source file '$sourceFile' is not exist."
    exit
}

if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}

# 确保临时目录和输出目录存�?
if (-not (Test-Path $tempDir)) {
    New-Item -ItemType Directory -Path $tempDir | Out-Null
}

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

# 定义目标压缩文件路径
$targetZipFile = Join-Path -Path $tempDir -ChildPath "apk.zip"

# .apk 文件复制并重命名 .zip 文件
Copy-Item -Path $sourceFile -Destination $targetZipFile -Force

# 解压 .zip 文件见到输出目录
Expand-Archive -Path $targetZipFile -DestinationPath $outputDir -Force

Write-Host "expand archive completed."

$soFiles = Get-ChildItem -Path $outputDir -Recurse -Filter "*.so"

$soDumpOutput = @()

$soDumpOutput += "android 35+ page-size 16kb result:" + "`n"

$soDumpOutput += "all outputs must be 2**14, so files that are not 2**14 need to be recompiled to support android-16kb-page-size." + "`n"

if ($soFiles.Count -eq 0){
    Write-Host "not found any .so file"
    $soDumpOutput += "not found any .so file"
} else {
    foreach ($soFile in $soFiles){
        Write-Host "    -> processing '$($soFile.FullName) ...'"
        $soDumpOutput += $soFile.FullName
        $soDumpOutput += (& $dump -p $soFile.FullName | Select-String -Pattern "LOAD" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) }) + "`n"
    }
    Write-Host "    <- process end."
}

Write-Host "    --> processing zipalign ..."

$zipalignOutput = (& $zipalign -v -c -P 16 4 $sourceFile | Out-String)
$lastLine = $zipalignOutput -split "`r?`n" | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Last 1
Write-Host "    <-- zipalign end."

$soDumpOutput += "zipalign result:"
$soDumpOutput += "      $lastLine"

$name = [System.IO.Path]::GetFileNameWithoutExtension($sourceFile)
$resultPath = "result-$name.txt"

if (Test-Path $resultPath) {
    Remove-Item -Path $resultPath -Force
}

Set-Content -Path $resultPath -Value $soDumpOutput -Encoding utf8

Remove-Item -Path $tempDir -Recurse -Force

Write-Host "analytics completed."
