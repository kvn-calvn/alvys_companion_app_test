package io.alvys.app.alvys3

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.util.Log
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationHub
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

@Suppress("UNCHECKED_CAST")
class MainActivity : FlutterActivity() {

    private var isBound = false
    private lateinit var mConnection : ServiceConnection
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
                        //Format and send data from flutter channel to tracking service
                        locationTrackingServiceIntent.putExtra(
                            "DRIVER-INFO",
                            JSONObject(call.arguments as Map<String, String>).toString()
                        )
                        bindService(locationTrackingServiceIntent, mConnection, Context.BIND_AUTO_CREATE)

                        context.startService(locationTrackingServiceIntent)
                    }
                    "stopLocationTracking" -> {
                        context.stopService(locationTrackingServiceIntent)
                    }
                    else -> result.notImplemented()
                }
            }

        var mService: LocationTrackingService

           mConnection = object : ServiceConnection {
            // Called when the connection with the service is established
            override fun onServiceConnected(className: ComponentName, service: IBinder) {
                // Because we have bound to an explicit
                // service that is running in our own process, we can
                // cast its IBinder to a concrete class and directly access it.
                val binder = service as LocationTrackingService.MyLocalBinder
                mService = binder.getService()
                isBound = true
            }

            // Called when the connection with the service disconnects unexpectedly
            override fun onServiceDisconnected(className: ComponentName) {
                Log.e("", "onServiceDisconnected")
                isBound = false
            }
        }
    }


}
