import * as admin from 'firebase-admin'

const serviceAccount = require("../service-key.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: `https://${serviceAccount.project_id}.firebaseio.com`
});

export * from './onGameCreate';
export * from './onJoinCreate';
export * from './onLeaveCreate';
export * from './onMoveCreate';

