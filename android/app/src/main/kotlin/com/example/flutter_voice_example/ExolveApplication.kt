package com.example.flutter_voice_example

import android.util.Log
import io.flutter.app.FlutterApplication
const val EXOLVE_APPLICATION = "EXOLVE_APPLICATION"
class ExolveApplication : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        Log.d(EXOLVE_APPLICATION, "ExolveApplication: OnCreate")
    }
}