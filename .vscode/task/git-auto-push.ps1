param(
    [string]$commitMsg = "auto commit and push"
)
$maxRetries = 10
$retry = 0
git add .
git commit -m "$commitMsg"
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Nothing to commit.'
} else {
    do {
        git push origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host 'Push succeeded.'
            break
        } else {
            Write-Host "Push failed. Retrying... ($($retry+1)/$maxRetries)"
            Start-Sleep -Seconds 3
            $retry++
        }
    } while ($retry -lt $maxRetries)
    if ($retry -eq $maxRetries) {
        Write-Host "Push failed after $maxRetries attempts."
    }
}
