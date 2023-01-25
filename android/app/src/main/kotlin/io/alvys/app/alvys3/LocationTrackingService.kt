package io.alvys.app.alvys3

import android.Manifest
import android.app.*
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.annotation.Nullable
import androidx.core.app.ActivityCompat
import com.google.android.gms.location.*


class LocationTrackingService: Service() {

    //region data
    private val UPDATE_INTERVAL_IN_MILLISECONDS = 3000
    private var mFusedLocationClient: FusedLocationProviderClient? = null
    private var locationRequest: LocationRequest? = null

    //endregion

    //endregion
    //onCreate
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
                Log.d("Locations", "${currentLocation.latitude}"  +" "  + currentLocation.longitude)
            }
            //Share/Publish Location
        }
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        prepareForegroundNotification()
        startLocationUpdates()
        return START_STICKY
    }

    private fun startLocationUpdates() {
        if (ActivityCompat.checkSelfPermission(
                this,
                Manifest.permission.ACCESS_FINE_LOCATION
            ) != PackageManager.PERMISSION_GRANTED && ActivityCompat.checkSelfPermission(
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
        }
        mFusedLocationClient!!.requestLocationUpdates(
            locationRequest!!,
            locationCallback, Looper.myLooper()
        )
    }

    private fun prepareForegroundNotification() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                "CHANNEL_ID_01",
                "Location Service Channel",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager: NotificationManager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(
            this,
            1,
            notificationIntent, PendingIntent.FLAG_IMMUTABLE
        )
        val notification: Notification = Notification.Builder(this, "CHANNEL_ID_01")
            .setContentTitle(getString(R.string.app_name))
            .setContentTitle("Your location will be tracked when assigned a trip.")
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentIntent(pendingIntent)
            .build()
        startForeground(1,notification)
    }

    @Nullable
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun initData() {

        locationRequest =  LocationRequest.Builder(Priority.PRIORITY_HIGH_ACCURACY, 10000)
            .apply {
                setWaitForAccurateLocation(false)
                setMinUpdateIntervalMillis(UPDATE_INTERVAL_IN_MILLISECONDS.toLong())
                setMaxUpdateDelayMillis(100000)
            }.build()

        mFusedLocationClient =
            LocationServices.getFusedLocationProviderClient(this)
    }
}