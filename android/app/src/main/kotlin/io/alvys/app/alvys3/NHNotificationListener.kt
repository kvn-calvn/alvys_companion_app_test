package io.alvys.app.alvys3

import android.content.Context
import android.util.Log
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationListener
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationMessage

class NHNotificationListener : NotificationListener {

    override fun onPushNotificationReceived(context: Context, message: NotificationMessage) {
        if (message.data.isNotEmpty()) {
            Log.d("NH_NOTIFICATION", "Message data payload: ${message.data}")
        }

        Log.d("NH_NOTIFICATION", "Title: ${message.title}")
        Log.d("NH_NOTIFICATION", "Body: ${message.body}")
    }
}