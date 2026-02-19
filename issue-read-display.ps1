param(
    [string]$JsonPath,
    [string]$CommentsPath = "",
    [int]$DisplayOption = 3
)

if (-not (Test-Path $JsonPath)) {
    Write-Host '  [XX] ERROR: Failed to fetch issue data.' -ForegroundColor Red
    exit 1
}

$j = Get-Content $JsonPath -Raw | ConvertFrom-Json

if ($j.message -like '*Not Found*') {
    Write-Host '  [XX] ERROR: Issue not found. Check the URL.' -ForegroundColor Red
    exit 1
}

# Load comments if they exist
$comments = @()
if ((Test-Path $CommentsPath) -and ($DisplayOption -eq 2 -or $DisplayOption -eq 3)) {
    $commentsJson = Get-Content $CommentsPath -Raw
    if ($commentsJson -and $commentsJson.Trim() -ne "[]") {
        $comments = ConvertFrom-Json $commentsJson
    }
}

# Display based on option
if ($DisplayOption -eq 1) {
    # Option 1: Description only
    Write-Host ''
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host "  Issue #$($j.number): $($j.title)" -ForegroundColor Cyan
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host ''
    
    if ($j.body) {
        Write-Host $j.body
    } else {
        Write-Host '    (no description)' -ForegroundColor Gray
    }
    
    Write-Host ''
    Write-Host '  [OK] Description retrieved successfully' -ForegroundColor Green

} elseif ($DisplayOption -eq 2) {
    # Option 2: Conversation history only
    Write-Host ''
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host "  Issue #$($j.number): $($j.title) - Conversation History" -ForegroundColor Cyan
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host ''
    
    if ($comments.Count -eq 0) {
        Write-Host '    (no comments)' -ForegroundColor Gray
    } else {
        foreach ($idx in 0..($comments.Count - 1)) {
            $comment = $comments[$idx]
            Write-Host "  --- Comment $($idx + 1) ---" -ForegroundColor Yellow
            Write-Host "  Author : " -NoNewline
            Write-Host $comment.user.login -ForegroundColor Yellow
            Write-Host "  Date   : " -NoNewline
            Write-Host $comment.created_at -ForegroundColor Gray
            Write-Host ""
            Write-Host $comment.body
            Write-Host ""
        }
    }
    
    Write-Host '  [OK] Conversation history retrieved successfully' -ForegroundColor Green

} else {
    # Option 3: Everything (full issue + comments)
    Write-Host ''
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host "  Issue #$($j.number): $($j.title)" -ForegroundColor Cyan
    Write-Host '  =====================================================================' -ForegroundColor Cyan
    Write-Host ''
    
    Write-Host '  Status    : ' -NoNewline
    if ($j.state -eq 'open') {
        Write-Host $j.state -ForegroundColor Green
    } else {
        Write-Host $j.state -ForegroundColor Red
    }
    
    Write-Host '  Author    : ' -NoNewline
    Write-Host $j.user.login -ForegroundColor Yellow
    
    Write-Host '  Created   : ' -NoNewline
    Write-Host $j.created_at -ForegroundColor Gray
    
    Write-Host '  Updated   : ' -NoNewline
    Write-Host $j.updated_at -ForegroundColor Gray
    
    Write-Host "  Comments  : $($j.comments)" -ForegroundColor Gray
    
    Write-Host ''
    Write-Host '  -- Description -------------------------------------------------------' -ForegroundColor Cyan
    Write-Host ''
    
    if ($j.body) {
        Write-Host $j.body
    } else {
        Write-Host '    (no description)' -ForegroundColor Gray
    }
    
    Write-Host ''
    Write-Host '  -- Labels -------------------------------------------------------------' -ForegroundColor Cyan
    
    if ($j.labels.Count -gt 0) {
        $j.labels | ForEach-Object {
            Write-Host "    * $($_.name)" -ForegroundColor Magenta
        }
    } else {
        Write-Host '    (none)' -ForegroundColor Gray
    }
    
    Write-Host ''
    Write-Host '  -- Assignees ----------------------------------------------------------' -ForegroundColor Cyan
    
    if ($j.assignees.Count -gt 0) {
        $j.assignees | ForEach-Object {
            Write-Host "    * $($_.login)" -ForegroundColor Yellow
        }
    } else {
        Write-Host '    (none)' -ForegroundColor Gray
    }
    
    # Display comments
    if ($comments.Count -gt 0) {
        Write-Host ''
        Write-Host '  -- Conversation History -----------------------------------------------' -ForegroundColor Cyan
        Write-Host ''
        
        foreach ($idx in 0..($comments.Count - 1)) {
            $comment = $comments[$idx]
            Write-Host "  [Comment $($idx + 1)] by $($comment.user.login) on $($comment.created_at)" -ForegroundColor Yellow
            Write-Host ""
            Write-Host $comment.body
            Write-Host ""
        }
    }
    
    Write-Host ''
    Write-Host "  URL     : $($j.html_url)" -ForegroundColor Green
    Write-Host ''
    Write-Host '  [OK] Complete issue data retrieved successfully' -ForegroundColor Green
}
