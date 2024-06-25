package io.alvys.app.alvys3

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.TaskStackBuilder
import android.content.Context
import android.content.Context.NOTIFICATION_SERVICE
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import androidx.core.net.toUri
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationListener
//import com.microsoft.windowsazure.messaging.notificationhubs.NotificationMessage
import java.util.Random

import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage


class NHNotificationListener : NotificationListener {

    override fun onPushNotificationReceived(context: Context, message: RemoteMessage) {
        Log.d("NH_NOTIFICATION", "Title: $message")
        if (message.notification?.title?.isNotEmpty() == true) {
            Log.d("NH_NOTIFICATION", "Message data payload: ${message.data}")
            showNotification(context, message)
        }

        Log.d("NH_NOTIFICATION", "Title: ${message.notification!!.title}")
        Log.d("NH_NOTIFICATION", "Body: ${message.notification!!.body}")
    }

    private fun showNotification(context: Context, message: RemoteMessage) {

        val notificationManager =
            context.getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        val NOTIFICATION_CHANNEL_ID = "CHANNEL_ID_02"

        val uriString = message.data["link"]

        Log.d("NH_NOTIFICATION", "Message data payload: $uriString")


        val flag =
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O)
                PendingIntent.FLAG_IMMUTABLE
            else
                0

        val notificationChannel = NotificationChannel(
            NOTIFICATION_CHANNEL_ID, "Alvys Notification", NotificationManager.IMPORTANCE_DEFAULT
        )
        notificationChannel.enableLights(true)
        notificationChannel.lightColor = Color.BLUE
        notificationChannel.enableLights(true)
        notificationManager.createNotificationChannel(notificationChannel)

        val clickIntent = Intent(
            Intent.ACTION_VIEW, uriString?.toUri(), context, MainActivity::class.java
        )

        val clickPendingIntent: PendingIntent = TaskStackBuilder.create(context).run {
            addNextIntentWithParentStack(clickIntent)
            getPendingIntent(1, flag)
        }

        val notification: Notification = Notification.Builder(context,
            NOTIFICATION_CHANNEL_ID
        )
            .setContentTitle(message.notification?.title ?: "")
            .setContentText(message.notification?.body ?: "")
            .setSmallIcon(R.mipmap.ic_notification)
            .setContentIntent(clickPendingIntent)
            .setAutoCancel(true)
            .build()

        notificationManager.notify(Random().nextInt(), notification)
    }


}