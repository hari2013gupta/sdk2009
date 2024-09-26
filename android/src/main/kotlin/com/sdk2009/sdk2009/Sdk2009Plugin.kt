package com.sdk2009.sdk2009

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

import java.util.*
import io.flutter.plugin.common.EventChannel
import java.text.SimpleDateFormat
import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.location.LocationListener
import android.location.LocationManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.sdk2009.sdk2009.util.IntentUtil

/** Sdk2009Plugin
 *
 * 1# GET PLATFORM VERSION
 * 2# GET TIMER EVENT CHANNEL LISTENER WITH STREAM
 * 3# GET LOCATION EVENT CHANNEL LISTENER WITH STREAM
 * 4# GET UPI APP INTENT LIST
 *
 *
 * */
class Sdk2009Plugin : FlutterPlugin, MethodCallHandler, ActivityAware,
    PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    private lateinit var eventChannel: EventChannel
//    private lateinit var locationEventChannel: EventChannel

    private lateinit var activityBinding: ActivityPluginBinding
    private lateinit var result: Result

    override fun onAttachedToEngine(flutterBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterBinding.binaryMessenger, "sdk2009")
        channel.setMethodCallHandler(this)

        // Time Listener Event Channel
        eventChannel = EventChannel(
            flutterBinding.binaryMessenger, "time_handler_event"
        ); // timeHandlerEvent event name
        eventChannel.setStreamHandler(TimeHandler) // TimeHandler is event class

        // Location Listener Event Channel
//        locationEventChannel = EventChannel( binding.binaryMessenger, "location_handler_event"); // timeHandlerEvent event name
//        locationEventChannel.setStreamHandler(LocationHandler) // LocationHandler is event class
    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        activityBinding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, callResult: Result) {
        result = callResult
        when (call.method) {
            "get_available_upi" -> {
                callResult.success(IntentUtil.getUpiAppList(activityBinding.activity.applicationContext))
            }

            "native_intent" -> {
                val url = call.argument<String>("url")
                IntentUtil.openUpiIntent(url!!, activityBinding, result)
            }

            "launch_upi_app" -> {
                val url = call.argument<String>("url")
                val packageName = call.argument<String>("package")
                IntentUtil.openUpiApp(activityBinding, url!!, packageName!!)
            }

            "get_platform_version" -> {
                result.success("Android ${Build.VERSION.RELEASE}")
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    object TimeHandler : EventChannel.StreamHandler {
        // Handle event in main thread.
        private var handler = Handler(Looper.getMainLooper())

        // Declare our eventSink later it will be initialized
        private var eventSink: EventChannel.EventSink? = null

        @SuppressLint("SimpleDateFormat")
        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
            eventSink = sink
            // every second send the time
            val r: Runnable = object : Runnable {
                override fun run() {
                    handler.post {
                        val dateFormat = SimpleDateFormat("HH:mm:ss")
                        val time = dateFormat.format(Date())
                        eventSink?.success(time)
                    }
                    handler.postDelayed(this, 1000)
                }
            }
            handler.postDelayed(r, 1000)
        }

        override fun onCancel(p0: Any?) {
            eventSink = null
        }
    }

//    object LocationHandler : EventChannel.StreamHandler {
//
//        // Declare our locationEventSink later it will be initialized
////        var locationEventSink: EventChannel.EventSink? = null
//
//        override fun onListen(p0: Any?, sink: EventChannel.EventSink) {
////            val locationEventSink: EventChannel.EventSink = sink
////            locationEventSink = sink
//            // every location change send the location
//            val listener = object : LocationListener {
//                override fun onLocationChanged(location: android.location.Location) {
//                }
//
//                override fun onStatusChanged(provider: String, status: Int, extras: Bundle) {
//                }
//
//                override fun onProviderEnabled(provider: String) {
//                    sink.success(true)
//                }
//
//                override fun onProviderDisabled(provider: String) {
//                    sink.success(false)
//                }
//            }
//
//            val locationManager = activity.activeContext()
//                .getSystemService(Context.LOCATION_SERVICE) as LocationManager
//            locationManager.requestLocationUpdates(
//                LocationManager.GPS_PROVIDER, 2000, 10f, listener
//            )
//        }
//
//        override fun onCancel(p0: Any) {
////            locationEventSink = null
//        }
//    }

    private fun upiPaymentDataOperation(data: ArrayList<String?>) {
        try {
            var str = data[0]
            var paymentCancel = ""
            if (str == null) str = "discard"
            var status = ""
            var approvalRefNo = ""
            val response = str.split("&".toRegex()).toTypedArray()
            Log.i("PASSED ARRAY", data.toString())
            for (i in response.indices) {
                val equalStr = response[i].split("=".toRegex()).toTypedArray()
                if (equalStr.size >= 2) {
                    if (equalStr[0].equals("Status", ignoreCase = true)) {
                        status = equalStr[1].lowercase(Locale.getDefault())
                    } else if (equalStr[0].equals(
                            "ApprovalRefNo",
                            ignoreCase = true
                        ) || equalStr[0].equals("txnRef", ignoreCase = true)
                    ) {
                        approvalRefNo = equalStr[1]
                    }
                } else {
                    paymentCancel = "Payment cancelled by user."
                }
            }
            if (status == "success") {
                result.success("Success!!$str")

            } else if ("Payment cancelled by user." == paymentCancel || status.contains("failure")) {
                result.success("Payment cancelled by user")
            } else {
                result.success("Transaction failed.Please try again")
            }
        } catch (e: Exception) {
            Log.i("Exception Native", e.toString())
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {

        if (requestCode == 121) {
            if (Activity.RESULT_OK == resultCode || resultCode == 11) {
                if (data != null) {
                    val trxt = data.getStringExtra("response")
                    Log.d("UPI", "onActivityResult:-------> $trxt");//txnId=&responseCode=00&ApprovalRefNo=null&Status=SUCCESS&txnRef=

                    val dataList = ArrayList<String?>()
                    dataList.add(trxt)

                    upiPaymentDataOperation(dataList)
                } else {
                    Log.d("UPI", "onActivityResult:-------> " + "Return data is null");
                    val dataList = ArrayList<String?>()
                    dataList.add("nothing")

                    upiPaymentDataOperation(dataList)
                }
            } else {
                val dataList = ArrayList<String?>()
                dataList.add("nothing")

                upiPaymentDataOperation(dataList)
            }
        }
        return true
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(activityBinding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
    }

}
