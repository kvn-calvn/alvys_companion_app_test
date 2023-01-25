package io.alvys.app.alvys3

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationHub

class MainActivity: FlutterActivity() {


override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    val locationTrackingServiceIntent = Intent(this, LocationTrackingService::class.java)

    super.configureFlutterEngine(flutterEngine)
    val messenger = flutterEngine.dartExecutor.binaryMessenger
    MethodChannel(messenger, "PLATFORM_CHANNEL")
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "registerForNotification" -> {
                    val driverId: String? = call.argument<String>("driverId")
                    val connectionString: String? = call.argument<String>("connectionString")
                    val hubName: String? = call.argument<String>("hubName")

                    NotificationHub.start(this.application, hubName, connectionString)
                    NotificationHub.addTag(driverId)
                    NotificationHub.setEnabled(true)

                }
                "startLocationTracking" -> {

                    context.startService(locationTrackingServiceIntent)

                }
           
                else -> result.notImplemented()
            }
        }
}


}
