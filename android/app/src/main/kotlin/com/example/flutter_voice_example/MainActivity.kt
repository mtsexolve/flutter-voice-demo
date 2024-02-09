package com.example.flutter_voice_example

import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.exolve.fluttervoicesdk.PushProvider
import com.exolve.fluttervoicesdk.communicator.CallClientWrapper
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        Log.d("MainActivity", "MainActivity: onCreate")
        ExolveMessageService().enableMessageService(this)
        PushProvider.broadcastCallIntent(this, intent)
    }

    override fun onResume() {
        super.onResume()
        Log.d("MainActivity", "MainActivity: onResume")
        CallClientWrapper.setAppInForeground()
    }

    override fun onPause() {
        super.onPause()
        Log.d("MainActivity", "MainActivity: onPause")
        CallClientWrapper.setAppInBackground()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        Log.d("MainActivity", "MainActivity: onNewIntent")
        PushProvider.broadcastCallIntent(this, intent)
    }

}
