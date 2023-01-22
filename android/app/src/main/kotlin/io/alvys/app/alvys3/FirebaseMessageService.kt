package io.alvys.app.alvys3
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage

class FirebaseMessageService: FirebaseMessagingService(){


    override fun onMessageReceived(message: RemoteMessage) {
        super.onMessageReceived(message)
        // Check if message contains a data payload.
        if (message.data.isNotEmpty()) {
            Log.d("FCM_PAYLOAD", "Message data payload: ${message.data}")


        }
    }
}