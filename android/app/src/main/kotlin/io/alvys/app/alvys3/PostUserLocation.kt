package io.alvys.app.alvys3

import android.util.Log
import com.google.gson.GsonBuilder
import com.google.gson.JsonParser
import kotlinx.coroutines.*
import org.json.JSONObject
import java.io.OutputStreamWriter
import java.net.HttpURLConnection
import java.net.URL

class PostUserLocation {
    @OptIn(DelicateCoroutinesApi::class)
    fun sendLocation(driverName: String, driverId: String, tripNumber: String, tripId: String, lat: Double, lng: Double, postURL: String, token: String, companyCode: String,speed: String) {
            // Create JSON using JSONObject
            val jsonObject = JSONObject()
            jsonObject.put("Driver1Name", driverName)
            jsonObject.put("Driver1Id", driverId)
            jsonObject.put("TripNumber", tripNumber)
            jsonObject.put("Latitude", "$lat")
            jsonObject.put("Longitude", "$lng")
            jsonObject.put("TripNumber", tripNumber)
            jsonObject.put("TripId", tripId)
            //jsonObject.put("Speed", speed)

            // Convert JSONObject to String
            val jsonObjectString = jsonObject.toString()
            val handler =
                CoroutineExceptionHandler { _, _ -> }
            val scope = CoroutineScope(SupervisorJob() + handler)
            scope.launch(Dispatchers.IO) {
                val url = URL(postURL)
                val httpURLConnection = url.openConnection() as HttpURLConnection
                httpURLConnection.requestMethod = "POST"
                httpURLConnection.setRequestProperty("Authorization", "Basic $token")
                httpURLConnection.setRequestProperty("CompanyCode", companyCode)
                httpURLConnection.setRequestProperty(
                    "Content-Type",
                    "application/json"
                ) // The format of the content we're sending to the server
                httpURLConnection.setRequestProperty(
                    "Accept",
                    "application/json"
                ) // The format of response we want to get from the server
                httpURLConnection.doInput = true
                httpURLConnection.doOutput = true

                // Send the JSON we created
                val outputStreamWriter = OutputStreamWriter(httpURLConnection.outputStream)
                outputStreamWriter.write(jsonObjectString)
                Log.d("REQUEST", jsonObjectString)
                outputStreamWriter.flush()

                // Check if the connection is successful
                val responseMsg = httpURLConnection.responseMessage
                val responseCode = httpURLConnection.responseCode
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    val response = httpURLConnection.inputStream.bufferedReader()
                        .use { it.readText() }  // defaults to UTF-8
                    withContext(Dispatchers.Main) {

                        // Convert raw JSON to pretty JSON using GSON library
                        val gson = GsonBuilder().setPrettyPrinting().create()
                        val prettyJson = gson.toJson(JsonParser.parseString(response))
                        Log.d("Pretty Printed JSON :", prettyJson)

                    }
                } else {
                    Log.e("HTTPURLCONNECTION_ERROR", responseCode.toString())
                    Log.e("HTTPURLCONNECTION_ERROR", responseMsg.toString())
                }
            }
    }
}