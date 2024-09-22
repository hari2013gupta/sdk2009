package com.sdk2009.sdk2009.util

import android.annotation.TargetApi
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.os.Build
import android.util.Base64
import java.io.ByteArrayOutputStream

class Common {
    companion object {
        fun clearNull(value: String?): String {
            return if (value.isNullOrEmpty()) "" else value.trim()
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
    }
}