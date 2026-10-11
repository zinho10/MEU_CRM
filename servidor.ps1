#requires -Version 5.1
$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Port = 8765
$JsonPath = Join-Path $Root "estoque.json"

function Get-Db {
  if (!(Test-Path $JsonPath)) { '{"produtos":[],"categorias":[],"unidades":[],"clientes":[],"fornecedores":[],"funcionarios":[],"compras":[],"vendas":[],"movimentacoes":[],"inventario":[],"financeiro":[],"contasbancarias":[],"centroscustos":[],"formasPagamento":[],"usuarios":[],"auditoria":[]}' | Set-Content $JsonPath -Encoding UTF8 }
  $raw=Get-Content $JsonPath -Raw -Encoding UTF8
  if ([string]::IsNullOrWhiteSpace($raw)) { $raw='{}' }
  $db=$raw|ConvertFrom-Json
  foreach($k in @('produtos','categorias','unidades','clientes','fornecedores','funcionarios','compras','vendas','movimentacoes','inventario','financeiro','contasbancarias','centroscustos','formasPagamento','usuarios','auditoria')) {
    if($null -eq $db.PSObject.Properties[$k]) { $db|Add-Member -NotePropertyName $k -NotePropertyValue @() }
  }
  return $db
}
function Save-Db($db) {
  $json=$db|ConvertTo-Json -Depth 30
  $tmp="$JsonPath.tmp"
  $json|Set-Content $tmp -Encoding UTF8
  Move-Item $tmp $JsonPath -Force
}
function Send-Response($ctx,$status,$type,$body) {
  $bytes=[Text.Encoding]::UTF8.GetBytes([string]$body);$ctx.Response.StatusCode=$status;$ctx.Response.ContentType=$type;$ctx.Response.ContentEncoding=[Text.Encoding]::UTF8;$ctx.Response.ContentLength64=$bytes.Length;$ctx.Response.OutputStream.Write($bytes,0,$bytes.Length);$ctx.Response.Close()
}
$listener=New-Object System.Net.HttpListener;$listener.Prefixes.Add("http://127.0.0.1:$Port/")
try{$listener.Start()}catch{Write-Host "Nao foi possivel iniciar a porta $Port.`n$($_.Exception.Message)" -ForegroundColor Red;Read-Host 'ENTER';exit 1}
Write-Host "CONTROLE DE ESTOQUE - SERVIDOR LOCAL" -ForegroundColor Cyan
Write-Host "Banco: $JsonPath";Write-Host "Acesse: http://127.0.0.1:$Port";Write-Host "Nao feche esta janela."
while($listener.IsListening){
 try{
  $ctx=$listener.GetContext();$req=$ctx.Request;$path=$req.Url.AbsolutePath
  if($path -eq '/api/db' -and $req.HttpMethod -eq 'GET'){ $db=Get-Db;Send-Response $ctx 200 'application/json; charset=utf-8' ($db|ConvertTo-Json -Depth 30);continue }
  if($path -eq '/api/db' -and $req.HttpMethod -eq 'POST'){
    $reader=New-Object IO.StreamReader($req.InputStream,$req.ContentEncoding);$body=$reader.ReadToEnd();$reader.Close();$db=$body|ConvertFrom-Json
    foreach($k in @('produtos','categorias','unidades','clientes','fornecedores','funcionarios','compras','vendas','movimentacoes','inventario','financeiro','contasbancarias','centroscustos','formasPagamento','usuarios','auditoria')){if($null -eq $db.PSObject.Properties[$k]){$db|Add-Member -NotePropertyName $k -NotePropertyValue @()}}
    Save-Db $db;Send-Response $ctx 200 'application/json; charset=utf-8' '{"ok":true}';continue
  }
  if($path -eq '/api/backup' -and $req.HttpMethod -eq 'GET'){$bytes=[IO.File]::ReadAllBytes($JsonPath);$ctx.Response.StatusCode=200;$ctx.Response.ContentType='application/json';$ctx.Response.AddHeader('Content-Disposition','attachment; filename="backup_erp.json"');$ctx.Response.ContentLength64=$bytes.Length;$ctx.Response.OutputStream.Write($bytes,0,$bytes.Length);$ctx.Response.Close();continue}
  $file=$path.TrimStart('/') -replace '/','\\';if([string]::IsNullOrWhiteSpace($file)){$file='index.html'};$full=Join-Path $Root $file
  if(!(Test-Path $full -PathType Leaf)){Send-Response $ctx 404 'text/plain; charset=utf-8' 'Arquivo nao encontrado.';continue}
  $ext=[IO.Path]::GetExtension($full).ToLower();$mime=@{'.html'='text/html; charset=utf-8';'.css'='text/css; charset=utf-8';'.js'='application/javascript; charset=utf-8';'.json'='application/json; charset=utf-8'}[$ext];if(!$mime){$mime='application/octet-stream'};$bytes=[IO.File]::ReadAllBytes($full);$ctx.Response.StatusCode=200;$ctx.Response.ContentType=$mime;$ctx.Response.ContentLength64=$bytes.Length;$ctx.Response.OutputStream.Write($bytes,0,$bytes.Length);$ctx.Response.Close()
 }catch{try{Send-Response $ctx 500 'text/plain; charset=utf-8' ('Erro: '+$_.Exception.Message)}catch{}}
}
