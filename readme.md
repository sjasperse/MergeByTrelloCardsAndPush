Merge byTrello Cards and Push
===============================
 A simple powershell script to help automate taking a few cards from 1 or more trello lists, and merging them into a single branch to push into our TEST environment.

Example
--------
 
```
PS> cd {path-to-repo}
PS> . "{path-to-this-script}\MergeByTrelloCardsAndPush.ps1" -TrelloListIds 12345678901234567890asdf,12345678901234567890asdf -TargetBranch test
```

What it does
---------
 1. It takes an array of trello list ids, and finds all the cards that belong in them.
 2. Finds which branches have a name which starts with the trello card number (short id)
 3. Checks out the specified target branch
 4. Resets that branch to be at the same commit as master
 5. Merges all the branches which match card ids
 6. Does a force push back to the target branch on origin
 7. Switches back to the starting branch

What you need to get started
---------
 In order to pull the trello lists and cards, the script needs trello authentication and authorization information. 
 Both a key and a token are required. Those can be generated from here: https://trello.com/app-key. 

These can either be supplied via command line parameters:
```
PS> . "{path-to-this-script}\MergeByTrelloCardsAndPush.ps1" -TrelloListIds 12345678901234567890asdf,12345678901234567890asdf -TargetBranch test -TrelloKey {key} -TrelloToken {token}
```

Or via environment variables

**Profile.ps1**
```
$env:TrelloKey = "{key}" 
$env:TrelloToken = "{token}"
```
```
PS> . "{path-to-this-script}\MergeByTrelloCardsAndPush.ps1" -TrelloListIds 12345678901234567890asdf,12345678901234567890asdf
```

