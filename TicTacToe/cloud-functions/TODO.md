# TIC TAC TOE

## Overview

The player should be presented a (+) button in the navigation bar
When the users taps this button then they should be presented with a action sheet with the 
following options

Title: Select Your Player
Player X (Always goes first)
Player O (Always goes second)
Cancel

An game object should then be created under the following path

## Start Game

The player should create a new auto generated id at path /start
the auto generated id will be the game id that the application should listen out to 
prior to send in the following object

```json
{
    "player" : "X | O",
    "uid" : "uid of player"
}

```

This will then start the game and will wait for another person to join

An onCreate cloud function will then be triggered to listen out for these events
Once received it will then go ahead and create that game under games using the auto id as the id of the game 

## Join Game

If a user taps game on the list they will be presented with the following options

Title: Enter Game
Watch
Join as (x or o)
Cancel

If the user taps watch then they will enter the game without play rights
If the user taps then Join then a cloud function request should be made

The application should then send the following object to the /join/(gameId) path

```
{
    "player" : "X | O",
    "uid" : "uid of player"
}
```

An onCreate cloud function will then be triggered to listen out for these events
Once received the users uid will be entered into the player x or y of the other game using a transaction

The application requires to check if the player x or o id is the same as theirs to confirm that they got to play and not someone else.

# Move

The nextMove propery of the game will indicate which person can have the write permission to 
create a move in the game

so the rules will check if the /games/gameId/nextMove/{id} == uid
if it is then the user can write /moves queue
otherwise they will receive a permission denied

If all is ok then the move should be added via cloud functions to the moves in the game 
in the cloud functions

Cloud function onMoveCreate will listen to moves/gameId

```
"games": {
        "auto-generated-id-from-database" : {
            "nextMove" : "uid of person that can move next",
        }
}
```

