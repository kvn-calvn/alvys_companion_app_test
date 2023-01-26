package io.alvys.app.alvys3

import android.content.Intent
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationHub

class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        val locationTrackingServiceIntent = Intent(this, LocationTrackingService::class.java)

        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, "PLATFORM_CHANNEL")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "registerForNotification" -> {
                        val driverPhone: String? = call.argument<String>("driverPhone")
                        val connectionString: String? = call.argument<String>("connectionString")
                        val hubName: String? = call.argument<String>("hubName")

                        NotificationHub.setListener(NHNotificationListener())
                        NotificationHub.start(this.application, hubName, connectionString)
                        NotificationHub.addTag(driverPhone)
                        NotificationHub.setEnabled(true)
                    }
                    "startLocationTracking" -> {
                        context.startService(locationTrackingServiceIntent)
                    }
                    "stopLocationTracking" -> {
                        context.stopService(locationTrackingServiceIntent)
                    }
                    else -> result.notImplemented()
                }
            }
    }


}
