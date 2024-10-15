package com.sdk2009.sdk2009.util

import android.annotation.TargetApi
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.BatteryManager
import android.os.Build
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.util.Base64
import java.io.ByteArrayOutputStream

class Common {
    companion object {
        fun clearNull(value: String?): String {
            return if (value.isNullOrEmpty()) "" else value.trim()
        }

        @TargetApi(Build.VERSION_CODES.LOLLIPOP_MR1)
        fun getDialogStyle(context: Context): Int {
            val nightModeFlags: Int = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
            when (nightModeFlags) {
                Configuration.UI_MODE_NIGHT_NO -> return android.R.style.Theme_DeviceDefault_Light_Dialog_Alert
            }
            return android.R.style.Theme_DeviceDefault_Dialog_Alert
        }

        @TargetApi(Build.VERSION_CODES.FROYO)
        fun getBitmapFromDrawable(drawable: Drawable): String? {
            val bmp: Bitmap = Bitmap.createBitmap(
                drawable.intrinsicWidth,
                drawable.intrinsicHeight,
                Bitmap.Config.ARGB_8888
            )
            val canvas = Canvas(bmp)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            val byteArrayOS = ByteArrayOutputStream()
            bmp.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOS)

            return Base64.encodeToString(byteArrayOS.toByteArray(), Base64.NO_WRAP)
        }

        fun getBatteryLevel(activityBinding: ActivityPluginBinding): Int {
            val batteryLevel: Int
            if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
                val batteryManager =
                    activityBinding.activity.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
                batteryLevel =
                    batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
            } else {
                val intent =
                    ContextWrapper(activityBinding.activity.applicationContext).registerReceiver(
                        null,
                        IntentFilter(Intent.ACTION_BATTERY_CHANGED)
                    )
                batteryLevel =
                    intent!!.getIntExtra(
                        BatteryManager.EXTRA_LEVEL,
                        -1
                    ) * 100 / intent.getIntExtra(
                        BatteryManager.EXTRA_SCALE,
                        -1
                    )
            }
            return batteryLevel;
        }
    }
}