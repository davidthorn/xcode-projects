import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

interface JoinGame {
    player: "x" | "o"
    uid: string
}

const gamesPath = "/games"

const path = "/join/{gameId}"

const handler = async (snapshot: functions.database.DataSnapshot, context: functions.EventContext) => {

    const gameId = context.params.gameId
    const gameData: JoinGame = snapshot.val()
    
    await snapshot.ref.remove().catch(() => {
        console.log('An error occured whilst deleting the reference')
    })

    return admin.database().ref(gamesPath).child(gameId).child('players').child(gameData.player).set(gameData.uid)
    
}
 
export const onJoinCreate = functions.database.ref(path).onCreate(handler)