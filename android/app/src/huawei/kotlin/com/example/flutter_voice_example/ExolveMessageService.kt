  package com.example.flutter_voice_example

import com.huawei.agconnect.AGConnectOptionsBuilder
import com.huawei.hms.aaid.HmsInstanceId
import com.huawei.hms.push.HmsMessageService
import com.huawei.hms.push.HmsMessaging
import com.huawei.hms.push.RemoteMessage
import android.content.Context
import android.os.Build
import android.text.TextUtils
import android.util.Log
import androidx.annotation.RequiresApi
import com.exolve.fluttervoicesdk.PushProvider

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

const val EXOLVE_MESSAGE_SERVICE = "EXOLVE_MESSAGE_SERVICE"

class ExolveMessageService : HmsMessageService(), MessageService {

    override fun onMessageReceived(p0: RemoteMessage?) {
        super.onMessageReceived(p0)
        Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService(markedLog):HMS OnMessageReceived( messageId = ${p0?.messageId})" +
                "messageType - ${p0?.messageType} , data = ${p0?.data}")
        PushProvider.processPushNotification(this, p0?.data.toString())
    }

    override fun onNewToken(p0: String?) {
        super.onNewToken(p0)
        Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS OnNewToken token = $p0")
        p0?.let { PushProvider.setPushToken(context = this, token = p0, pushType = PushProvider.PushType.HMS) }
    }

    override fun enableMessageService(context: Context): Boolean {
        var result = false
        CoroutineScope(Dispatchers.IO).launch {
            HmsMessaging.getInstance(context).turnOnPush().addOnCompleteListener { task ->
                // Obtain the result.
                if (task.isSuccessful) {
                    result = true
                    Log.i(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS enableMessageService is successfully.")
                } else {
                    Log.w(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS enableMessageService is failed", task.exception)
                }
            }
            try {
                val appId = AGConnectOptionsBuilder().build(context).getString("client/app_id")
                val token = HmsInstanceId.getInstance(context).getToken(appId, "HCM")
                if (!TextUtils.isEmpty(token)) {
                    Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS enableMessageService: got token: $token")
                    storeToken(context, token)
                    broadcastToken(context, token)
                }
            } catch (e: Exception) {
                Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS enableMessageService: getToken failed, $e")
            }
        }
        return result
    }

    override fun onTokenError(p0: java.lang.Exception?) {
        super.onTokenError(p0)
        Log.d(EXOLVE_MESSAGE_SERVICE, "ExolveMessageService:HMS tokenError: token  message: ${p0?.message}")
    }

}