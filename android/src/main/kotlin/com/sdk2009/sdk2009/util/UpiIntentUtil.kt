package com.sdk2009.sdk2009.util

import android.annotation.TargetApi
import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import android.util.Log
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.REQ_UPI_INTENT
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.util.ArrayList
import java.util.Locale


class UpiIntentUtil {

    companion object {
        fun openUpiIntent(
            url: String?, activityBinding: ActivityPluginBinding, result: MethodChannel.Result
        ) {
            Log.i("upi-app","------>url=$url")
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            val resolveIntent = intent.resolveActivity(activityBinding.activity.packageManager)
            val isUpiAppInstalled = isUpiAppInstalled(activityBinding.activity, url!!)
            Log.i("upi-app","------>resolveIntent=$resolveIntent, .isUpiAppInstalled=$isUpiAppInstalled")
            if (resolveIntent != null) {
                activityBinding.activity.startActivityForResult(intent, REQ_UPI_INTENT)
            } else {
                result.success("Please make sure you've installed UPI apps")
            }
        }

        private fun isUpiAppInstalled(activity: Activity, upiUrl: String): Boolean {
            val packageManager: PackageManager = activity.packageManager ?: return false
            val upiAppIntent = Intent(Intent.ACTION_VIEW, Uri.parse(upiUrl))
            val availableApps = packageManager.queryIntentActivities(upiAppIntent, PackageManager.MATCH_DEFAULT_ONLY)

            return availableApps.isNotEmpty()
        }

        @TargetApi(Build.VERSION_CODES.DONUT)
        fun openUpiApp(activityBinding: ActivityPluginBinding, data: String?, packageName: String?, result: MethodChannel.Result) {
            Log.i("upi-app","------>data=$data")
            Log.i("upi-app","------>packageName=$packageName")

            val intent = Intent()
            intent.action = Intent.ACTION_VIEW
            intent.setPackage(packageName)
            intent.data = Uri.parse(data)
            val resolveIntent = intent.resolveActivity(activityBinding.activity.packageManager)
            val isAppInstalled = isSpecificUpiAppInstalled(activityBinding.activity, packageName!!)
            Log.i("upi-app","------>resolveIntent=$resolveIntent, isAppInstalled->>>$isAppInstalled")
            if (resolveIntent != null) {
                activityBinding.activity.startActivityForResult(intent, REQ_UPI_INTENT)
            } else {
                result.success("Please make sure you've installed UPI apps")
            }
        }

        private fun isSpecificUpiAppInstalled(activity: Activity, packageName: String): Boolean {
            val packageManager: PackageManager = activity.packageManager ?: return false
            return try {
                packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES)
                true
            } catch (e: PackageManager.NameNotFoundException) {
                false
            }
        }
        fun getUpiAppList(context: Context): String {

            val uriBuilder: Uri.Builder = Uri.Builder();
            uriBuilder.scheme("upi").authority("pay");
            uriBuilder.appendQueryParameter("pa", "test@ybl");
            uriBuilder.appendQueryParameter("pn", "Test");
            uriBuilder.appendQueryParameter("tn", "Get All Apps");
            uriBuilder.appendQueryParameter("am", "1.0");
            uriBuilder.appendQueryParameter("cr", "INR");

            val application = JSONArray()
            val packageManager = context.packageManager
            val mainIntent = Intent(Intent.ACTION_MAIN, null)
            mainIntent.addCategory(Intent.CATEGORY_DEFAULT)
            mainIntent.addCategory(Intent.CATEGORY_BROWSABLE)
            mainIntent.action = Intent.ACTION_VIEW
            val uri = Uri.Builder().scheme("upi").authority("pay").build()
            mainIntent.data = uri

            val pkgAppsList: List<*> = context.packageManager.queryIntentActivities(mainIntent, 0)

            for (i in pkgAppsList.indices) {
                val resolveInfo = pkgAppsList[i] as ResolveInfo
                if (!isWhatsapp(resolveInfo.activityInfo.packageName) && isAppUpiReady(
                        resolveInfo.activityInfo.packageName,
                        context
                    )
                ) {
                    val obj = JSONObject()
                    obj.put("name", resolveInfo.loadLabel(packageManager).toString())
                    obj.put("package_name", resolveInfo.activityInfo.packageName)
                    obj.put(
                        "icon",
                        Common.getBitmapFromDrawable(resolveInfo.loadIcon(packageManager))
                    )

                    application.put(obj)
                }
            }
            val data = JSONObject()
            data.put("data", application)

            print(application)

            return data.toString()
        }

        private fun isWhatsapp(packageName: String): Boolean {
            return Common.clearNull(packageName).equals("com.whatsapp", ignoreCase = true)
        }

        private fun isAppUpiReady(packageName: String, context: Context): Boolean {
            var appUpiReady = false
            val upiIntent = Intent(Intent.ACTION_VIEW, Uri.parse("upi://pay"))

//        val upiIntent = Intent(Intent.ACTION_VIEW, Uri.parse("upi://mandate?pa=112233220@ipl&pn=OK%20TECHNOLOGIES&tr=EZM2023070112223506269543&am=2000.00 &cu=INR&orgid=400011&mc=5818&purpose=14&tn=Mandate%20for%20Sound%20box&validitystart=01072023&validityend=01072053&amrule=MAX&recur=ASPRESENTED&rev=Y&share=Y&block=N&txnType=CREATE&mode=13"))
            val pm = context.packageManager
            val upiActivities: List<ResolveInfo> = pm.queryIntentActivities(upiIntent, 0)
            for (a in upiActivities) {
                if (a.activityInfo.packageName == packageName) appUpiReady = true
            }
            return appUpiReady
        }

        /* upi operation send result
        * */
        internal fun upiPaymentDataOperation(result: Result, data: ArrayList<String?>) {
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
    }
}