param(
    [string]$JFlexJarPath
)

$ErrorActionPreference = 'Stop'
$projectRoot = $PSScriptRoot

Push-Location $projectRoot
try {
    foreach ($tool in @('javac', 'jar', 'java')) {
        if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
            throw "Required command '$tool' was not found in PATH."
        }
    }

    if (-not $JFlexJarPath) {
        $JFlexJarPath = $env:JFLEX_JAR
    }
    if (-not $JFlexJarPath) {
        $bundledJFlexJar = Get-ChildItem -LiteralPath '.\external_jars' -Filter 'jflex-full*.jar' -File |
            Select-Object -First 1
        if ($bundledJFlexJar) {
            $JFlexJarPath = $bundledJFlexJar.FullName
        }
    }
    if (-not $JFlexJarPath -or -not (Test-Path -LiteralPath $JFlexJarPath -PathType Leaf)) {
        throw "JFlex standalone JAR not found. Place a jflex-full*.jar in .\external_jars, set the JFLEX_JAR environment variable, or pass -JFlexJarPath."
    }

    $requiredFiles = @(
        '.\jflex\LEX_FILE.lex',
        '.\external_jars\java-cup-11b-runtime.jar',
        '.\manifest\MANIFEST.MF',
        '.\input\Input.txt'
    )
    foreach ($file in $requiredFiles) {
        if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
            throw "Required file not found: $file"
        }
    }

    Clear-Host

    Write-Host '[0] Remove previous LEXER program'
    if (Test-Path -LiteralPath '.\LEXER') {
        Remove-Item -LiteralPath '.\LEXER' -Force
    }

    Write-Host '[1] Remove class files and generated Lexer.java'
    if (Test-Path -LiteralPath '.\src\Lexer.java') {
        Remove-Item -LiteralPath '.\src\Lexer.java' -Force
    }
    if (Test-Path -LiteralPath '.\bin') {
        Get-ChildItem -LiteralPath '.\bin' -Filter '*.class' -File |
            Remove-Item -Force
    }

    Write-Host '[2] Generate Lexer.java with JFlex'
    & java -cp $JFlexJarPath jflex.Main -q -d '.\src' '.\jflex\LEX_FILE.lex'
    if ($LASTEXITCODE -ne 0) {
        throw "JFlex failed with exit code $LASTEXITCODE."
    }

    Write-Host '[3] Compile Java sources for Java 8'
    New-Item -ItemType Directory -Force -Path '.\bin' | Out-Null
    $sourceFiles = Get-ChildItem -LiteralPath '.\src' -Filter '*.java' -File |
        ForEach-Object { $_.FullName }
    if (-not $sourceFiles) {
        throw 'No Java source files were found in .\src.'
    }
    & javac -source 8 -target 8 -cp '.\external_jars\java-cup-11b-runtime.jar' -d '.\bin' $sourceFiles
    if ($LASTEXITCODE -ne 0) {
        throw "javac failed with exit code $LASTEXITCODE."
    }

    Write-Host '[4] Package classes into LEXER'
    & jar cfm 'LEXER' '.\manifest\MANIFEST.MF' -C '.\bin' .
    if ($LASTEXITCODE -ne 0) {
        throw "jar failed with exit code $LASTEXITCODE."
    }

    Write-Host '[5] Run the lexer'
    New-Item -ItemType Directory -Force -Path '.\output' | Out-Null
    & java -jar '.\LEXER' '.\input\Input.txt' '.\output\OutputTokens.txt'
    if ($LASTEXITCODE -ne 0) {
        throw "java failed with exit code $LASTEXITCODE."
    }
}
finally {
    Pop-Location
}
