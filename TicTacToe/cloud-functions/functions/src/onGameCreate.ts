import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

interface StartGame {
    player: "x" | "o"
    uid: string
}

const gamesPath = "/games"

const path = "/start/{gameId}"

const handler = async (snapshot: functions.database.DataSnapshot, context: functions.EventContext) => {

    const gameId = context.params.gameId
    const gameData: StartGame = snapshot.val()

    const players = gameData.player == 'x' ? { x: gameData.uid } : { o: gameData.uid }

    await snapshot.ref.remove().catch(() => {
        console.log('An error occured whilst deleting the reference')
    })

    return admin.database().ref(gamesPath).child(gameId).set({
        id: gameId,
        startedAt : admin.database.ServerValue.TIMESTAMP,
        nextMove : gameData.uid,
        players
    })
    
}
 
export const onGameCreate = functions.database.ref(path).onCreate(handler)