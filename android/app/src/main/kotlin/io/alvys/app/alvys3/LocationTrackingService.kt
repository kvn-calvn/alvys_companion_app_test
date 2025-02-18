package io.alvys.app.alvys3

import android.Manifest
import android.annotation.SuppressLint
import android.app.*
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*
import org.json.JSONObject


class LocationTrackingService : Service() {

    private val INTERVAL_IN_MILLISECONDS = 900000 //Every 15mins
    private var mFusedLocationClient: FusedLocationProviderClient? = null
    private var locationRequest: LocationRequest? = null
//    private val localBinder = MyLocalBinder()
    private var driverInfo = JSONObject()

    override fun onCreate() {
        super.onCreate()
        initData()
    }

    //Location Callback
    private val locationCallback: LocationCallback = object : LocationCallback() {
        override fun onLocationResult(locationResult: LocationResult) {
            super.onLocationResult(locationResult)
            val currentLocation: Location? = locationResult.lastLocation
            if (currentLocation != null) {
                val driverName = driverInfo.get("DriverName").toString()
                val token = driverInfo.get("token").toString()
                val tripNumber = driverInfo.get("tripNumber").toString()
                val tripId = driverInfo.get("tripId").toString()
                val companyCode = driverInfo.get("companyCode").toString()
                val driverId = driverInfo.get("DriverId").toString()
                val url = driverInfo.get("url").toString()
                val lat = currentLocation.latitude
                val lng = currentLocation.longitude
                val speed = "${((currentLocation.speed)*3600/1000)} km/h"

                PostUserLocation().sendLocation(driverName,driverId,tripNumber,tripId,lat, lng,url,token, companyCode, speed)
                Log.d("Locations", "${currentLocation.latitude}" + " " + currentLocation.longitude)
            }
            //Share/Publish Location
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
      if(intent != null)  {
          val driverInfoString = intent.getStringExtra("DRIVER-INFO").toString()
          driverInfo = JSONObject(driverInfoString)
          prepareForegroundNotification()
          startLocationUpdates()
          return START_STICKY
        }
        return START_REDELIVER_INTENT
    }

    override fun stopService(name: Intent?): Boolean {
        Log.e("", "Stop location tracking service called")
        mFusedLocationClient!!.removeLocationUpdates(locationCallback)
        return super.stopService(name)
    }

    override fun onDestroy() {
        Log.e("", "Destroy location tracking service called")
        mFusedLocationClient!!.removeLocationUpdates(locationCallback)
        super.onDestroy()
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    private fun hasRequiredPermissions(): Boolean {
        return ActivityCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED &&
                ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED &&
             ( if  (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE)
                ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.FOREGROUND_SERVICE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED else true)
    }

    @SuppressLint("MissingPermission")
    private fun startLocationUpdates() {
        if ( !hasRequiredPermissions()) {
           Log.e("LocationService", "Missing required permissions")

            return
        }else {
            mFusedLocationClient!!.requestLocationUpdates(
                locationRequest!!,
                locationCallback, Looper.myLooper()
            )
        }

    }

    private fun prepareForegroundNotification() {
        val serviceChannel = NotificationChannel(
            "CHANNEL_ID_01",
            "Location Service",
            NotificationManager.IMPORTANCE_NONE,
        )
        val manager: NotificationManager = getSystemService(NotificationManager::class.java)
        manager.createNotificationChannel(serviceChannel)
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(
            this,
            1,
            notificationIntent, PendingIntent.FLAG_IMMUTABLE
        )
        val notification: Notification = Notification.Builder(this, "CHANNEL_ID_01")
            //.setContentTitle(getString(R.string.app_name))
            .setContentTitle("Your location will be tracked when assigned a trip.")
            .setSmallIcon(R.mipmap.ic_notification)
            .setContentIntent(pendingIntent)
            .build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(1, notification, FOREGROUND_SERVICE_TYPE_LOCATION)
        }
        else {
            startForeground(1, notification)
        }
    }

    private fun initData() {

        locationRequest = LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, INTERVAL_IN_MILLISECONDS.toLong())
            .apply {
                setWaitForAccurateLocation(true)
            }.build()

        mFusedLocationClient =
            LocationServices.getFusedLocationProviderClient(this)
    }
}