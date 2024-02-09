package com.example.flutter_voice_example

import android.content.Context
import android.util.Log
import com.exolve.fluttervoicesdk.PushProvider
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.messaging.FirebaseMessaging
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
const val EXOLVE_MESSAGE_SERVICE = "EXOLVE_MESSAGE_SERVICE"
class ExolveMessageService : FirebaseMessagingService(), MessageService {

    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService(markedLog):FCM OnMessageReceived( messageId = ${message.messageId})" +
                "sender - ${message.senderId} , data = ${message.data}")
        PushProvider.processPushNotification(this, message.data.toString())
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:FCM OnNewToken token = $token")
        storeToken(this, token)
        broadcastToken(this, token)
        PushProvider.setPushToken(context = this, token = token, pushType = PushProvider.PushType.FIREBASE)
    }

    override fun enableMessageService(context: Context): Boolean {
        var result = false
        CoroutineScope(Dispatchers.IO).launch {
            FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
                if (!task.isSuccessful) {
                    Log.w(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:FCM: registration token failed", task.exception)
                    return@OnCompleteListener
                }
                val token = task.result
                Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:FCM: message service is enabled token is $token")
                storeToken(context, token)
                broadcastToken(context, token)
                result = true
            })
        }
        return result
    }

}