import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

interface LeaveGame {
    player: "x" | "o"
    uid: string
}

const gamesPath = "/games"

const path = "/leave/{gameId}"

const handler = async (snapshot: functions.database.DataSnapshot, context: functions.EventContext) => {

    const gameId = context.params.gameId
    const gameData: LeaveGame = snapshot.val()
    
    await snapshot.ref.remove().catch(() => {
        console.log('An error occured whilst deleting the reference')
    })

    return admin.database().ref(gamesPath)
    .child(gameId).child('players').child(gameData.player).remove()
    
}
 
export const onLeaveCreate = functions.database.ref(path).onCreate(handler)