param(
    [string]$commitMsg = "auto commit and push",
    [string]$githubIp = ""
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

function GitPush-WithCustomIp {
    param(
        [string]$ip
    )
    if ($ip -ne "") {
        Write-Host "Temporarily set github.com to $ip for git push. (SSL verify disabled)"
        git config --global url."https://$ip/".insteadOf "https://github.com/"
        git -c http.sslVerify=false -c http.extraHeader="Host: github.com" push origin main
        $result = $LASTEXITCODE
        git config --global --unset url."https://$ip/".insteadOf
        return $result
    } else {
        git push origin main
        return $LASTEXITCODE
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host 'Nothing to commit. Try pushing any unpushed commits.'
    do {
        Flush-DnsCache
        $pushResult = GitPush-WithCustomIp $githubIp
        if ($pushResult -eq 0) {
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
        $pushResult = GitPush-WithCustomIp $githubIp
        if ($pushResult -eq 0) {
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
