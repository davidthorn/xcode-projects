import * as functions from 'firebase-functions'
import * as admin from 'firebase-admin'

interface GameData {
    winner?: {
        tiles?: number[],
        uid: string | 'DRAW'
    }
    tiles: {
        zero?: string
        one?: string
        two?: string
        three?: string
        four?: string
        five?: string
        six?: string
        seven?: string
        eight?: string
        
    }
    players: {
        x: string
        o: string
    }
}

interface Move {
    tile: string
    uid: string
}

const gamesPath = "/games"

const path = "/move/{gameId}"

const handler = async (snapshot: functions.database.DataSnapshot, context: functions.EventContext) => {

    const gameId = context.params.gameId
    const gameData: Move = snapshot.val()
    
    await snapshot.ref.remove().catch(() => {
        console.log('An error occured whilst deleting the reference')
    })

    await admin.database().ref(gamesPath)
    .child(gameId)
    .child("tiles")
    .child(gameData.tile).set(gameData.uid)

    const gameRef = await admin.database().ref(gamesPath).child(gameId)

    await gameRef.child('moves').push(gameData)
    
    const game: GameData = await gameRef.once('value' , (snap) => {
        return snap
    }).then(p => p.val())

    const t = game.tiles

    switch(true) {
        /// HORIZONTAL LINES
        case hasCombination(t.zero , t.one , t.two):
            game.winner = getWinner(0, 1, 2, t.zero!)
            await gameRef.child('winner').set(game.winner)
        break
        case hasCombination(t.three , t.four , t.five):
            game.winner = getWinner(3, 4, 5, t.three!)
            await gameRef.child('winner').set(game.winner)
        break
        case hasCombination(t.six , t.seven , t.eight):
            game.winner = getWinner(6, 7, 8, t.six!)
            await gameRef.child('winner').set(game.winner)
        break

        /// VERTICAL LINES
        case hasCombination(t.zero , t.three , t.six):
            game.winner = getWinner(0, 3, 6, t.zero!)
            await gameRef.child('winner').set(game.winner)
        break
        case hasCombination(t.one , t.four , t.seven):
            game.winner = getWinner(1, 4, 7, t.one!)
            await gameRef.child('winner').set(game.winner)
        break
        case hasCombination(t.two , t.five , t.eight):
            game.winner = getWinner(2, 5, 8, t.two!)
            await gameRef.child('winner').set(game.winner)
        break

        /// DIAGONAL LINES
        case hasCombination(t.zero , t.four , t.eight):
            game.winner = getWinner(0, 4, 8, t.zero!)
            await gameRef.child('winner').set(game.winner)
        break
        case hasCombination(t.two , t.four , t.six):
            game.winner = getWinner(2, 4, 6, t.two!)
            await gameRef.child('winner').set(game.winner)
        break
    }

    if(game.winner !== undefined) {
        return Promise.resolve(game)
    } 

    if (isDraw(game)) {
        game.winner = getWinner(-1, -1, -1, "DRAW")
        await gameRef.child('winner').set(game.winner)
        return Promise.resolve(game)
    }

    const nextMove  = game.players.x === gameData.uid ? game.players.o : game.players.x 

    await gameRef.child('nextMove').set(nextMove)
    return Promise.resolve(game)

}

const hasCombination = (a?: string , b?: string , c?: string ): boolean => {
    
    if (a === undefined || b === undefined || c === undefined) {
        return false
    }

    if (b !== a || c !== a || b !== c ) {
        return false
    }

    return true
    
}

const isDraw = (game: GameData): boolean => {
    console.log('checking draw: ' , {
        game,
        length: Object.values(game.tiles).filter(i => { return i !== undefined }).length
    })
    return Object.values(game.tiles).filter(i => { return i !== undefined }).length === 9
}

const getWinner = (a: number , b: number , c: number , uid: string | 'DRAW'): { tiles?: number[] , uid: string | 'DRAW' } => {
    return {
        tiles: uid === 'DRAW' ? [] : [a,b,c],
        uid
    }
}
 
export const onMoveCreate = functions.database.ref(path).onCreate(handler)