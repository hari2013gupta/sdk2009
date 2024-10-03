package com.sdk2009.sdk2009.util

import android.annotation.TargetApi
import android.content.Context
import android.content.Intent
import android.content.pm.ResolveInfo
import android.net.Uri
import android.os.Build
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject


class IntentUtil {

    companion object {
        fun openUpiIntent(
            url: String, activityBinding: ActivityPluginBinding, result: MethodChannel.Result
        ) {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url))
            if (intent.resolveActivity(activityBinding.activity.packageManager) != null) {
                activityBinding.activity.startActivityForResult(intent, 121)
            } else {
//            Toast.makeText(activity.activity, "Please make sure you've installed UPI apps", Toast.LENGTH_LONG).show()
                result.success("Please make sure you've installed UPI apps")
            }
        }

        @TargetApi(Build.VERSION_CODES.DONUT)
        fun openUpiApp(activityBinding: ActivityPluginBinding, data: String, packageName: String) {
            val intent = Intent()
            intent.action = Intent.ACTION_VIEW
            intent.setPackage(packageName)
            intent.data = Uri.parse(data)
            activityBinding.activity.startActivityForResult(intent, 121)
        }

        fun getUpiAppList(context: Context): String {

            val uriBuilder:Uri.Builder =  Uri.Builder();
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
                if (!isWhatsapp(resolveInfo.activityInfo.packageName) && isAppUpiReady(resolveInfo.activityInfo.packageName, context)) {
                    val obj = JSONObject()
                    obj.put("name", resolveInfo.loadLabel(packageManager).toString())
                    obj.put("package_name", resolveInfo.activityInfo.packageName)
                    obj.put("icon", Common.getBitmapFromDrawable(resolveInfo.loadIcon(packageManager)))

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
            for (a in upiActivities){
                if (a.activityInfo.packageName == packageName) appUpiReady = true
            }
            return appUpiReady
        }
    }
}