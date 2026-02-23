param(
  [Parameter(Mandatory = $true)]
  [string]$Nome,

  [string]$Descricao = "Exercicio de Dart em aula"
)

$ErrorActionPreference = "Stop"

function Get-Slug {
  param([string]$Value)

  $slug = $Value.ToLower().Trim()
  $slug = $slug -replace "\s+", "_"
  $slug = $slug -replace "[^a-z0-9_-]", ""
  return $slug
}

$repoRoot = Split-Path -Parent $PSScriptRoot
$slug = Get-Slug -Value $Nome

if ([string]::IsNullOrWhiteSpace($slug)) {
  throw "Nome invalido. Use letras, numeros, espaco, '_' ou '-'."
}

$destino = Join-Path $repoRoot "exercicios/dart/$slug"

if (Test-Path $destino) {
  throw "Ja existe um exercicio com esse nome: exercicios/dart/$slug"
}

$dartCmd = Get-Command dart -ErrorAction SilentlyContinue
if (-not $dartCmd) {
  throw "Dart nao encontrado no PATH. Instale o Dart SDK e tente novamente."
}

New-Item -ItemType Directory -Path $destino | Out-Null

Push-Location $destino
try {
  dart create -t console-simple --force .
  if ($LASTEXITCODE -ne 0) {
    throw "Falha ao executar 'dart create'."
  }
} finally {
  Pop-Location
}

$dataHoje = Get-Date -Format "yyyy-MM-dd"
$readmeTemplatePath = Join-Path $repoRoot "templates/dart_console/README.md"
$changelogTemplatePath = Join-Path $repoRoot "templates/dart_console/CHANGELOG.md"

$readmeTemplate = Get-Content -Raw -Path $readmeTemplatePath
$readmeConteudo = $readmeTemplate.Replace("{{NOME}}", $slug).Replace("{{DESCRICAO}}", $Descricao)
Set-Content -Path (Join-Path $destino "README.md") -Value $readmeConteudo -Encoding utf8

$changelogTemplate = Get-Content -Raw -Path $changelogTemplatePath
$changelogConteudo = $changelogTemplate.Replace("{{DATA}}", $dataHoje).Replace("{{DESCRICAO}}", $Descricao)
Set-Content -Path (Join-Path $destino "CHANGELOG.md") -Value $changelogConteudo -Encoding utf8

Write-Host ""
Write-Host "Exercicio criado com sucesso:"
Write-Host "  exercicios/dart/$slug"
Write-Host ""
Write-Host "Proximos passos:"
Write-Host "  cd exercicios/dart/$slug"
Write-Host "  dart pub get"
Write-Host "  dart run"
