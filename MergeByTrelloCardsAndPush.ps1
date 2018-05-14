param (
    [object[]]$TrelloListIds = $(throw "-TrelloListIds is required"),
    [string]$TargetBranch = $(throw "-TargetBranch is required"),
    [string]$TrelloKey = $($env:TrelloKey),
    [string]$TrelloToken = $($env:TrelloToken)
)

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

function TrelloApiGet([string] $relativeUrl) {
    $url = "https://api.trello.com/$($relativeUrl)?key=$TrelloKey&token=$TrelloToken"
    Write-debug "GET $url"
    return Invoke-RestMethod -Uri $url
}

"Getting cards in Trello lists..."
$cardIds = @()
foreach ($TrelloListId in $TrelloListIds) {
    $cardIds += ((TrelloApiGet "1/lists/$TrelloListId/cards") | %{$_.idShort})
}

"Comparing card numbers with available branches..."
$branchesWithCardIdsReadyForTest = (git branch -r) `
    | %{ $_.Trim() } `
    | Where-Object {
        foreach ($cardId in $cardIds) {
            if ($_.StartsWith("origin/$cardId")) { return $true }
        }
        
        return $false                                                             
    }

"Storing current branch"
$branch = git rev-parse --abbrev-ref HEAD

"Getting latest..."
git fetch --all

"Switching to '$TargetBranch' branch..."
git checkout test

"Resetting to match origin/master"
git reset --hard origin/master

"Merging..."
"git merge --no-edit $([string]::Join(" ", $branchesWithCardIdsReadyForTest))" | Invoke-Expression

"Pushing to origin..."
git push origin $TargetBranch -f

"Changing back to original branch"
git checkout $branch

"Finished"
