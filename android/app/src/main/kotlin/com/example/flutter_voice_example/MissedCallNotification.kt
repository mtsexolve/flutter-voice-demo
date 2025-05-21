package com.example.flutter_voice_example

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build



class MissedCallNotification(private val context: Context) {

    private val missedCallsChannelId = "missed_calls_channel"

    private val intent  = Intent(context, MainActivity::class.java).apply {
        flags = Intent.FLAG_ACTIVITY_NEW_TASK
    }

    private val pendingIntent = PendingIntent.getActivity(
        context,
        0,
        intent,
        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
    )

    init {
        createNotificationChannel()
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            missedCallsChannelId,
            "Missed Calls",
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Show notifications about missed calls"
        }
        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.createNotificationChannel(channel)
    }

    fun showMissedCallNotification(number: String) {
        val notification = Notification.Builder(context, missedCallsChannelId)
            .setSmallIcon(android.R.drawable.sym_call_missed)
            .setContentText(String.format("Missed call from %s", number))
            .setVisibility(Notification.VISIBILITY_PUBLIC)
            .setCategory(if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) Notification.CATEGORY_MISSED_CALL else Notification.CATEGORY_CALL)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true)
            .build()

        val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        notificationManager.notify(1, notification)
    }   
}