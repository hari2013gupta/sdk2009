package com.sdk2009.sdk2009.util

import android.util.Log
import android.widget.Toast
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_APP
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_SMS_MODULE
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status
import java.util.regex.Pattern

class SmsConsentUtil {
    companion object {

        fun startSmsUserConsent(activityBinding: ActivityPluginBinding) {
            SmsRetriever.getClient(activityBinding.activity).also {
                //We can add user phone number or leave it blank
                it.startSmsUserConsent(null)
                    .addOnSuccessListener {
                        Log.d(TAG_APP, "$TAG_SMS_MODULE :: LISTENING_SUCCESS")
                    }
                    .addOnFailureListener {
                        Log.d(TAG_APP, "$TAG_SMS_MODULE :: LISTENING_FAILURE")
                    }
            }
        }

        fun extractVerificationCode(
            message: String?
        ): Tuple<Boolean, String> {
            var tuple = Tuple(false, "")
            if (message == null || message.length < 6) {
                return tuple
            } else {
//            Extract the 6 digit integer from SMS
                val pattern = Pattern.compile("\\d{6}")
                val matcher = pattern.matcher(message)
                if (matcher.find()) {
                    tuple = Tuple(true, matcher.group(0) as String)
                }
            }
            return tuple
        }
    }
}