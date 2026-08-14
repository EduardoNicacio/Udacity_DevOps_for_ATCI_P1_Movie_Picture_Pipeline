# PowerShell version of init.sh
$ErrorActionPreference = "Stop"

Write-Host "Fetching IAM github-action-user ARN"
$userarn = aws iam get-user --user-name github-action-user | ConvertFrom-Json | Select-Object -ExpandProperty User | Select-Object -ExpandProperty Arn

Write-Host "Downloading aws-iam-authenticator for Windows..."
$authenticatorUrl = "https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v0.6.2/aws-iam-authenticator_0.6.2_windows_amd64"
$authenticatorPath = ".\aws-iam-authenticator.exe"

Invoke-WebRequest -Uri $authenticatorUrl -OutFile $authenticatorPath

Write-Host "Updating permissions"
& $authenticatorPath add user --userarn=$userarn --username=github-action-role --groups=system:masters --kubeconfig="$env:USERPROFILE\.kube\config" --prompt=false

Write-Host "Cleaning up"
Remove-Item $authenticatorPath

Write-Host "Done!"