package com.sdk2009.sdk2009

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.content.Context.RECEIVER_EXPORTED
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.media.RingtoneManager
import android.net.ConnectivityManager
import android.os.Build
import android.util.Base64
import android.util.Log
import android.widget.Toast
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.sdk2009.sdk2009.iconnect.Connectivity
import com.sdk2009.sdk2009.iconnect.ConnectivityBroadcastReceiver
import com.sdk2009.sdk2009.receiver.AnyEventHandler
import com.sdk2009.sdk2009.receiver.SmsVerificationReceiver
import com.sdk2009.sdk2009.util.AppSignatureHelper
import com.sdk2009.sdk2009.util.Common
import com.sdk2009.sdk2009.util.SmsConsentUtil
import com.sdk2009.sdk2009.util.TimeHandler
import com.sdk2009.sdk2009.util.UpiIntentUtil
import com.sdk2009.sdk2009.util.WebViewFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject
import java.util.*


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

    private var activity: Activity? = null
    private lateinit var activityBinding: ActivityPluginBinding
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private var appContext: Context? = null
    private lateinit var result: MethodChannel.Result

    private var iConnectReceiver: ConnectivityBroadcastReceiver? = null
    private lateinit var iConnect: Connectivity

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
        this.appContext = flutterBinding.applicationContext
        val messenger = flutterBinding.binaryMessenger
        channel = MethodChannel(messenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)

        // Time Listener Event Channel
        eventChannel = EventChannel(
            flutterBinding.binaryMessenger, "time_handler_event"
        ) // timeHandlerEvent event name
        eventChannel.setStreamHandler(TimeHandler) // TimeHandler is an event class
        eventChannel.setStreamHandler(AnyEventHandler) // AnyEventHandler is an event class

        setupChannels(this.appContext!!)

        flutterBinding.platformViewRegistry.registerViewFactory(
            "sdk2009/webview", WebViewFactory(messenger))

    }

    /// following lines under observation----------------
    //here is the implementation of that new method
//  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
//     this.mContext = applicationContext;
//     methodChannel = new MethodChannel(messenger, "com.myplugin/my_plugin");
//     methodChannel.setMethodCallHandler(this);
// }
    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
//   companion object {
//     @JvmStatic
//     fun registerWith(registrar: Registrar) {
//       val channel = MethodChannel(registrar.messenger(), "flutter_plugin_name")
//       channel.setMethodCallHandler(FlutterMapboxTurnByTurnPlugin())
//     }
//   }
    /// above lines under observation end----------------
    override fun onAttachedToActivity(activityBinding: ActivityPluginBinding) {
        this.activityBinding = activityBinding
        this.activity = activityBinding.activity

        // Location Listener Event Channel
//        locationEventChannel = EventChannel( binding.binaryMessenger, "location_handler_event"); // timeHandlerEvent event name
//        locationEventChannel.setStreamHandler(LocationHandler) // LocationHandler is event class

        // register receiver here

        // activity result listener from here
        activityBinding.addActivityResultListener(this)
    }

    private fun setupChannels(context: Context) {
        val connectivityManager =
            context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager

        this.iConnect = Connectivity(connectivityManager)

//        val methodChannelHandler =
//            ConnectivityMethodChannelHandler(connectivity)
        iConnectReceiver = ConnectivityBroadcastReceiver(context, this.iConnect)

//        channel.setMethodCallHandler(methodChannelHandler)
        eventChannel.setStreamHandler(iConnectReceiver)
    }

    override fun onMethodCall(call: MethodCall, callResult: MethodChannel.Result) {
        result = callResult
        when (call.method) {

            "native_toast" -> {
                val args = call.arguments as Map<String, String>
                val msg = args["msg"]
                Toast.makeText(appContext, msg, Toast.LENGTH_SHORT).show()
                result.success("OK")
            }

            "native_alert" -> {
                val args = call.arguments as? HashMap<String, String>
                if (args == null) {
                    result.error("No args", "Args is a null object.", "")
                } else {
                    val windowTitle = args.getOrDefault("window_title", "")
                    val text = args.getOrDefault("alert_text", "")
                    val alertStyle = args.getOrDefault("alert_style", "ok")

                    AlertDialog.Builder(
                        this.activity,
                        Common.getDialogStyle(appContext)
                    ).setTitle(windowTitle).setMessage(text).apply {
                        when (alertStyle) {
                            "abort_retry_ignore" ->
                                setPositiveButton(R.string.retry) { _, _ -> result.success("retry") }
                                    .setNeutralButton(R.string.ignore) { _, _ -> result.success("ignore") }
                                    .setNegativeButton(R.string.abort) { _, _ -> result.success("abort") }

                            "cancel_try_continue" ->
                                setPositiveButton(R.string.try_again) { _, _ -> result.success("try_again") }
                                    .setNeutralButton(R.string.continue_button) { _, _ ->
                                        result.success(
                                            "continue"
                                        )
                                    }
                                    .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }

                            "ok_cancel" ->
                                setPositiveButton(R.string.ok) { _, _ -> result.success("ok") }
                                    .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }

                            "retry_cancel" ->
                                setPositiveButton(R.string.retry) { _, _ -> result.success("retry") }
                                    .setNegativeButton(R.string.cancel) { _, _ -> result.success("cancel") }

                            "yes_no" ->
                                setPositiveButton(R.string.yes) { _, _ -> result.success("yes") }
                                    .setNegativeButton(R.string.no) { _, _ -> result.success("no") }

                            "yes_no_cancel" ->
                                setPositiveButton(R.string.yes) { _, _ -> result.success("yes") }
                                    .setNeutralButton(R.string.cancel) { _, _ -> result.success("cancel") }
                                    .setNegativeButton(R.string.no) { _, _ -> result.success("no") }

                            else -> setPositiveButton(R.string.ok) { _, _ -> result.success("ok") }
                        }
                    }.create().show()
                }
            }

            "native_custom_alert" -> {
                val args = call.arguments as? HashMap<String, String>
                if (args == null) {
                    result.error("No args", "Args is a null object.", "")
                } else {
                    val windowTitle = args.getOrDefault("window_title", "")
                    val text = args.getOrDefault("alert_text", "")
                    val positiveButtonTitle = args.getOrDefault("positive_button_title", "")
                    val negativeButtonTitle = args.getOrDefault("negative_button_title", "")
                    val neutralButtonTitle = args.getOrDefault("neutral_button_title", "")
                    val base64Icon = args.getOrDefault("base64_icon", "")

                    val builder = AlertDialog.Builder(
                        this.activity,
                        Common.getDialogStyle(appContext)
                    ).setTitle(windowTitle).setMessage(text)
                    var buttonCount = 0
                    if (positiveButtonTitle.isNotEmpty()) {
                        builder.setPositiveButton(positiveButtonTitle) { _, _ -> result.success("positive_button") }
                        buttonCount += 1
                    }
                    if (negativeButtonTitle.isNotEmpty()) {
                        builder.setNegativeButton(negativeButtonTitle) { _, _ -> result.success("negative_button") }
                        buttonCount += 1
                    }
                    if (negativeButtonTitle.isNotEmpty()) {
                        builder.setNeutralButton(neutralButtonTitle) { _, _ -> result.success("neutral_button") }
                        buttonCount += 1
                    }
                    if (buttonCount == 0) {
                        builder.setPositiveButton("OK") { _, _ -> result.success("other") }
                        buttonCount += 1
                    }

                    if (base64Icon.isNotEmpty()) {
                        val decodedString = Base64.decode(base64Icon, Base64.DEFAULT)
                        val decodedByte: Bitmap =
                            BitmapFactory.decodeByteArray(decodedString, 0, decodedString.size)
                        val icon: Drawable = BitmapDrawable(activity?.resources, decodedByte)
                        builder.setIcon(icon)
                    }

                    builder.create().show()
                }
            }

            "native_sound" -> {
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

                val signatureHelper = AppSignatureHelper(activity!!.applicationContext)
                val appSignature = signatureHelper.appSignature
                jsonInfo.put("battery_level", batteryLevel)
                jsonInfo.put("platform_version", platformVersion)
                jsonInfo.put("appSignature", appSignature)

                result.success(jsonInfo.toString())
            }

            "get_platform_views" -> {
//                pluginBinding
//                    .platformViewRegistry
//                    .registerViewFactory("@views/native-view", NativeViewFactory())
                result.success("ok")
            }

            "android_sms_consent" -> {
                val msg = call.argument<String>("code")
                result.success(msg)
            }

            "native_receiver_register" -> {

                SmsConsentUtil.startSmsUserConsent(this.activityBinding)

                val intentFilter = IntentFilter(SmsRetriever.SMS_RETRIEVED_ACTION)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                    activity?.registerReceiver(
                        SmsVerificationReceiver(activityBinding),
                        intentFilter,
                        RECEIVER_EXPORTED
                    )
                } else {
                    activity?.registerReceiver(
                        SmsVerificationReceiver(activityBinding),
                        intentFilter
                    )
                }
                result.success("msg")
            }

            "native_receiver_unregister" -> {
                activity!!.unregisterReceiver(SmsVerificationReceiver(activityBinding))
                result.success("msg")
            }

            "network_type" -> {
                result.success(iConnect.networkTypes.toString())
            }

            "native_generate_hashcode" -> {
//                val hash =AppSignatureHelper
                result.success("hash")
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)

//        channel.setStreamHandler(null);
        iConnectReceiver?.onCancel(null);
//        channel = null;
//        eventChannel = null;
        iConnectReceiver = null;

        appContext = null
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
        // unregister receiver
        activity = null
    }

}
