param(
    [string]$commitMsg = "auto commit and push"
)
$maxRetries = 30
$retry = 0

function Flush-DnsCache {
    Write-Host 'Flushing DNS cache...'
    try {
        ipconfig /flushdns | Out-Null
        Write-Host 'DNS cache flushed.'
    } catch {
        Write-Host 'Failed to flush DNS cache.'
    }
}

git add .
git commit -m "$commitMsg"
if ($LASTEXITCODE -ne 0) {
    Write-Host 'Nothing to commit. Try pushing any unpushed commits.'
    do {
        Flush-DnsCache
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
} else {
    do {
        Flush-DnsCache
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
