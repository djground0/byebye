# Define a message to display before logging out users (optional)
$logoutMessage = "This computer is being logged out for maintenance. Please save your work."

# Get all logged-in user sessions (excluding system accounts)
$sessions = query session | Where-Object { $_ -match '^\s*\d+\s+\w+' } | ForEach-Object {
    $parts = $_ -split '\s+', 6
    [PSCustomObject]@{
        SessionID = $parts[2]
        UserName = $parts[1]
    }
}

# Send a message to each user and log them out
foreach ($session in $sessions) {
    if ($session.UserName -ne "services" -and $session.UserName -ne "SYSTEM") {
        Write-Host "Logging out user: $($session.UserName) (Session ID: $($session.SessionID))"
        
        # Optionally send a message before logging out
        if ($logoutMessage) {
            msg $session.SessionID $logoutMessage
            Start-Sleep -Seconds 5  # Give users time to see the message
        }
        
        # Log out the user gracefully
        logoff $session.SessionID
    }
}

Write-Host "All users have been logged out."