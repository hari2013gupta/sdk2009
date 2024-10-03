package com.sdk2009.sdk2009

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry

import java.util.*
import android.app.Activity
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import android.widget.Toast
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import com.sdk2009.sdk2009.receiver.SmsVerificationReceiver
import com.sdk2009.sdk2009.util.Common
import com.sdk2009.sdk2009.util.UpiIntentUtil
import com.sdk2009.sdk2009.util.SmsConsentUtil
import com.sdk2009.sdk2009.util.TimeHandler
import org.json.JSONObject

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

    private lateinit var activity: Activity
    private lateinit var activityBinding: ActivityPluginBinding
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var contextBinding: Context
    private lateinit var result: Result

    companion object {
        const val TAG_APP = "sdk2009plugin"
        const val TAG_UPI_INTENT = "upi_intent"
        const val TAG_SMS_MODULE = "sms_user_consent"
        const val CHANNEL_NAME = "sdk2009"
        const val REQ_USER_CONSENT = 100
        const val REQ_UPI_INTENT = 121
    }

    override fun onAttachedToEngine(flutterBinding: FlutterPlugin.FlutterPluginBinding) {
        this.pluginBinding = flutterBinding
        this.contextBinding = flutterBinding.applicationContext
        channel = MethodChannel(flutterBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        // Time Listener Event Channel
        eventChannel = EventChannel(
            flutterBinding.binaryMessenger, "time_handler_event"
        ) // timeHandlerEvent event name
        eventChannel.setStreamHandler(TimeHandler) // TimeHandler is an event class

    }

    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        this.activity = activityBinding.activity

        // Location Listener Event Channel
//        locationEventChannel = EventChannel( binding.binaryMessenger, "location_handler_event"); // timeHandlerEvent event name
//        locationEventChannel.setStreamHandler(LocationHandler) // LocationHandler is event class

        SmsConsentUtil.startSmsUserConsent(this.activityBinding)

        val intentFilter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            activity.registerReceiver(SmsVerificationReceiver(activityBinding), intentFilter, RECEIVER_EXPORTED)
        } else {
            activity.registerReceiver(SmsVerificationReceiver(activityBinding), intentFilter)
        }
        // activity result listener from here
        activityBinding.addActivityResultListener(this)
    }

    override fun onMethodCall(call: MethodCall, callResult: Result) {
        result = callResult
        when (call.method) {

            "native_toast" -> {
                val args = call.arguments as Map<String, String>
                val msg = args["msg"]
                Toast.makeText(activity.applicationContext, msg, Toast.LENGTH_SHORT).show()
                result.success("OK")
            }

            "play_alert_sound" -> {
                val notification = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
                val ringTone =
                    RingtoneManager.getRingtone(this.activity, notification)
                ringTone.play()
                result.success(null)
            }

            "get_available_upi" -> {
                callResult.success(UpiIntentUtil.getUpiAppList(this.activityBinding.activity.applicationContext))
            }

            "native_intent" -> {
                val url = call.argument<String>("url")
                UpiIntentUtil.openUpiIntent(url!!, this.activityBinding, result)
            }

            "launch_upi_app" -> {
                val url = call.argument<String>("url")
                val packageName = call.argument<String>("package")
                UpiIntentUtil.openUpiApp(activityBinding, url!!, packageName!!)
            }

            "get_platform_info" -> {
                val jsonInfo = JSONObject()
                val batteryLevel = Common.getBatteryLevel(activityBinding)
                val platformVersion = Build.VERSION.RELEASE
                jsonInfo.put("battery_level", batteryLevel)
                jsonInfo.put("platform_version", platformVersion)

                result.success(jsonInfo.toString())
            }

            "android_sms_consent" -> {
                val msg = call.argument<String>("code")
                result.success(msg)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
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

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        when (requestCode) {
            REQ_USER_CONSENT -> {

                // Obtain the phone number from the result
                if (resultCode == Activity.RESULT_OK && data != null) {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: MESSAGE_RECEIVED")
                    val message = data.getStringExtra(SmsRetriever.EXTRA_SMS_MESSAGE)
//                    Extract the verification code from the message
                    val tupleResult =
                        SmsConsentUtil.extractVerificationCode(message)
                    if (tupleResult.item1) {
                        val mChannel =
                            MethodChannel(pluginBinding.binaryMessenger, CHANNEL_NAME)
                        mChannel.invokeMethod("android_sms_consent", tupleResult.item2)
                    } else {
                        Log.d(TAG_APP, "$TAG_SMS_MODULE :: $message :: verification code not found")
                    }
                } else {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: Consent denied")
                    // Consent denied. User can type OTC manually.
                }
            }

            REQ_UPI_INTENT -> {
                if (Activity.RESULT_OK == resultCode || resultCode == 11) {
                    if (data != null) {
                        val upiResponse = data.getStringExtra("response")
                        Log.d(TAG_APP, "$TAG_UPI_INTENT :: onActivityResult: $upiResponse")
                        /// txnId=&responseCode=00&ApprovalRefNo=null&Status=SUCCESS&txnRef=

                        val dataList = ArrayList<String?>()
                        dataList.add(upiResponse)

                        UpiIntentUtil.upiPaymentDataOperation(result, dataList)
                    } else {
                        Log.d(TAG_APP, "$TAG_UPI_INTENT :: onActivityResult: no data found")
                        val dataList = ArrayList<String?>()
                        dataList.add("nothing")

                        UpiIntentUtil.upiPaymentDataOperation(result, dataList)
                    }
                } else {
                    val dataList = ArrayList<String?>()
                    dataList.add("nothing")

                    UpiIntentUtil.upiPaymentDataOperation(result, dataList)
                }
            }

            else -> {
                Log.d(TAG_APP, "$TAG_UPI_INTENT :: onActivityResult: unknown request code")
            }
        }
        return true
    }

    override fun onDetachedFromActivityForConfigChanges() {
    }

    override fun onReattachedToActivityForConfigChanges(activityBinding: ActivityPluginBinding) {
    }

    override fun onDetachedFromActivity() {
        activity.unregisterReceiver(SmsVerificationReceiver(activityBinding))
    }

}
