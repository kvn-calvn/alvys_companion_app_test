package io.alvys.app.alvys3

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.content.res.Configuration
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.window.layout.WindowMetricsCalculator
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationHub
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject

@Suppress("UNCHECKED_CAST")
class MainActivity : FlutterActivity() {
    private lateinit var locationTrackingServiceIntent: Intent
    private var startString: String? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NotificationHub.setListener(NHNotificationListener())
        locationTrackingServiceIntent = Intent(this, LocationTrackingService::class.java)


        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, "PLATFORM_CHANNEL")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "registerForNotification" -> {
                        val driverPhone: String? = call.argument<String>("driverPhone")
                        val connectionString: String? = call.argument<String>("connectionString")
                        val hubName: String? = call.argument<String>("hubName")

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
                        context.startForegroundService(locationTrackingServiceIntent)!!

                        result.success(1)
                    }
                    "stopLocationTracking" -> {
                        context.stopService(locationTrackingServiceIntent)
                        result.success(1)
                    }
                    "initialLink" -> {
                        if (startString != null) {
                            result.success(startString)
                        }
                    }
                    "isTablet" ->{
                        result.success( (context.resources.configuration.screenLayout and Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE)
                    }
                    else -> result.notImplemented()
                }
            }



//           mConnection = object : ServiceConnection {
//            // Called when the connection with the service is established
//            override fun onServiceConnected(className: ComponentName, service: IBinder) {
//                // Because we have bound to an explicit
//                // service that is running in our own process, we can
//                // cast its IBinder to a concrete class and directly access it.
//                val binder = service as LocationTrackingService.MyLocalBinder
//                mService = binder.getService()
//                isBound = true
//            }
//
//            // Called when the connection with the service disconnects unexpectedly
//            override fun onServiceDisconnected(className: ComponentName) {
//                Log.e("", "onServiceDisconnected")
//                isBound = false
//            }
//        }

    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = intent
        startString = intent.data?.toString()
    }
}
