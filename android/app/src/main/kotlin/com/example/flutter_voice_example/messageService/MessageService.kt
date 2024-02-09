package com.example.flutter_voice_example

import android.content.Context
import android.content.Intent
import android.util.Log

const val MESSAGE_SERVICE = "MESSAGE_SERVICE"
const val TOKEN_PREFERENCES_KEY = "flutter.TOKEN_PREFERENCES_KEY"
const val FLUTTER_PREFERENCES = "FlutterSharedPreferences"

interface MessageService {
    fun enableMessageService(context: Context) : Boolean

    fun storeToken(context: Context, token: String) {
        Log.d(MESSAGE_SERVICE, "store token")
        val preferences = context.getSharedPreferences(FLUTTER_PREFERENCES, Context.MODE_WORLD_READABLE)
        preferences.edit().putString(TOKEN_PREFERENCES_KEY, token).apply()
    }

    fun broadcastToken(context: Context, token: String) {
        Log.d(MESSAGE_SERVICE, "broadcast token")
        val intent = Intent("com.exolve.demoapp.pushtoken")
        intent.putExtra("token", token)
        intent.setPackage(context.packageName)
        context.sendBroadcast(intent)
    }

}
