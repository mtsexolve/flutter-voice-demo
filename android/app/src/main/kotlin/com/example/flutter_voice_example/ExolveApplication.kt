package com.example.flutter_voice_example

import android.util.Log
import io.flutter.app.FlutterApplication
import com.exolve.fluttervoicesdk.call.CallListener
import com.example.flutter_voice_example.MissedCallNotification

const val EXOLVE_APPLICATION = "EXOLVE_APPLICATION"
class ExolveApplication : FlutterApplication() {
    
    lateinit var missedCallNotification : MissedCallNotification

    override fun onCreate() {
        super.onCreate()
        Log.d(EXOLVE_APPLICATION, "ExolveApplication: OnCreate")

        missedCallNotification = MissedCallNotification(applicationContext)
        CallListener.getInstance().setMissedCallCallback { number ->
            missedCallNotification.showMissedCallNotification(number)
        }
    }
}