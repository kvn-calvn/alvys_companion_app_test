package io.alvys.app.alvys3

import android.Manifest
import android.annotation.SuppressLint
import android.app.*
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Binder
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
    private val localBinder = MyLocalBinder()
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
        //prepareForegroundNotification()
        startLocationUpdates()
        return START_STICKY
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
    @SuppressLint("MissingPermission")
    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_COARSE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
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
            //.setSmallIcon("")
            .setContentIntent(pendingIntent)
            .build()
        startForeground(1, notification)
    }

    override fun onBind(intent: Intent?): IBinder {

        val driverInfoString = intent?.getStringExtra("DRIVER-INFO").toString()
        driverInfo = JSONObject(driverInfoString)

        Log.d("ONBIND_INTENT",  driverInfo.get("url").toString())
        Log.d("ONBIND_INTENT", "$driverInfoString")
        return localBinder
    }

    inner class MyLocalBinder : Binder() {
        fun getService() : LocationTrackingService {
            return this@LocationTrackingService
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