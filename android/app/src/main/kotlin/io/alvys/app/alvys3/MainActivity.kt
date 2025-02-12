package io.alvys.app.alvys3

import android.content.Intent
import android.graphics.Point
import android.os.Build
import android.os.Bundle
import android.view.WindowManager
import androidx.core.app.ActivityCompat
import com.microsoft.windowsazure.messaging.notificationhubs.NotificationHub
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.json.JSONObject
import kotlin.math.hypot
import android.Manifest
import android.content.pm.PackageManager
import androidx.core.content.ContextCompat


@Suppress("UNCHECKED_CAST")
class MainActivity : FlutterActivity() {
    private lateinit var locationTrackingServiceIntent: Intent
    private var startString: String? = null
    private var locationPermissionRequestCode = 1010
    private var channel = "PLATFORM_CHANNEL"
    private fun WindowManager.currentDeviceRealSize(): Pair<Int, Int> {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            return Pair(
                maximumWindowMetrics.bounds.width(),
                maximumWindowMetrics.bounds.height())
        } else {
            val size = Point()
            @Suppress("DEPRECATION")
            defaultDisplay.getRealSize(size)
            Pair(size.x, size.y)
        }
    }
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        NotificationHub.setListener(NHNotificationListener())
        locationTrackingServiceIntent = Intent(this, LocationTrackingService::class.java)


        val messenger = flutterEngine.dartExecutor.binaryMessenger

        MethodChannel(messenger, channel)
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
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            val permissions = arrayOf(
                                Manifest.permission.FOREGROUND_SERVICE_LOCATION
                            )
                            ActivityCompat.requestPermissions(this, permissions, locationPermissionRequestCode)
                        }

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
                    "unregisterNotification" -> {
                        NotificationHub.clearTags()
                        NotificationHub.setEnabled(false)
                    }
                    "initialLink" -> {
                        if (startString != null) {
                            result.success(startString)
                        }
                    }
                    // "nativeApiKeys" -> {
                    //     val appCenterKey = call.argument<String>("appcenterKey")
                    //     //Log.e("MSG1", appCenterKey.toString())

                    //     AppCenter.start(
                    //         application, appCenterKey,
                    //         Analytics::class.java, Crashes::class.java
                    //     )
                    // }
                    "isTablet" ->{
                        val (width, height) = windowManager.currentDeviceRealSize()
                        val widthInInches: Double = (width / resources.displayMetrics.xdpi).toDouble()
                        val heightInInches: Double = (height / resources.displayMetrics.ydpi).toDouble()
                        val screenSize = hypot(widthInInches, heightInInches)
//                        Log.e("Density", resources.displayMetrics.xdpi.toString())
//                        Log.e("Width", widthInInches.toString())
//                        Log.e("Height", heightInInches.toString())
//                        Log.e("Size", screenSize.toString())
                        result.success((if (widthInInches < heightInInches)  widthInInches else heightInInches) >=5)
                        // result.success( (context.resources.configuration.screenLayout and Configuration.SCREENLAYOUT_SIZE_MASK) >= Configuration.SCREENLAYOUT_SIZE_LARGE)
                    }
                    "requestLocationPermissions" -> {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
                            val permissions = arrayOf(
                                Manifest.permission.FOREGROUND_SERVICE_LOCATION
                            )

                            if (permissions.all { ContextCompat.checkSelfPermission(this, it) == PackageManager.PERMISSION_GRANTED }) {
                                result.success(true) // Permissions already granted
                            } else {
                                ActivityCompat.requestPermissions(this, permissions, locationPermissionRequestCode)
                                result.success(false) // Requesting permissions
                            }
                        } else {
                           result.success(true)
                        }
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
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

//        if (requestCode == locationPermissionRequestCode) {
//            val granted = grantResults.all { it == PackageManager.PERMISSION_GRANTED }
//            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, channel).invokeMethod("permissionResult", granted)
//        }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val intent = intent
        startString = intent.data?.toString()
    }
}
