package com.sdk2009.sdk2009.receiver

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.REQ_USER_CONSENT
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_APP
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_SMS_MODULE
import com.sdk2009.sdk2009.util.SDK2009Logger

import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import com.google.android.gms.auth.api.phone.SmsRetriever
import com.google.android.gms.common.api.CommonStatusCodes
import com.google.android.gms.common.api.Status


class SmsVerificationReceiver(activityBinding: ActivityPluginBinding) : BroadcastReceiver() {
    private var activity: Activity = activityBinding.activity
    override fun onReceive(context: Context, intent: Intent) {
        if (SmsRetriever.SMS_RETRIEVED_ACTION == intent.action) {
            val extras = intent.extras
            val smsRetrieverStatus = extras?.get(SmsRetriever.EXTRA_STATUS) as Status

            when (smsRetrieverStatus.statusCode) {
                CommonStatusCodes.SUCCESS -> {
                    // Get consent intent
                    SDK2009Logger.kLog.info("$TAG_SMS_MODULE :: receiver registered successfully!")
                    val consentIntent =
                        extras?.getParcelable<Intent>(SmsRetriever.EXTRA_CONSENT_INTENT)
                    try {
                        // Start activity to show consent dialog to user, activity must be started in
                        // 5 minutes, otherwise you'll receive another TIMEOUT intent
                        consentIntent?.let {
                            activity.startActivityForResult(
                                it,
                                REQ_USER_CONSENT
                            )
                        }
                    } catch (e: ActivityNotFoundException) {
                        Log.d(
                            TAG_APP,
                            "$TAG_SMS_MODULE :: CATCH_ERROR: ActivityNotFoundException"
                        )
                        // Handle the exception ...
                    }
                }

                // handle the error.
                CommonStatusCodes.TIMEOUT -> {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: REG_REC_TIMEOUT")
                }

                CommonStatusCodes.NETWORK_ERROR -> {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: REG_REC_NETWORK_ERROR")
                }

                CommonStatusCodes.ERROR -> {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: REG_REC_UNKNOWN_ERROR")
                }

                else -> {
                    Log.d(TAG_APP, "$TAG_SMS_MODULE :: REG_REC_INTERNAL_ERROR")
                }
            }
        }
    }
}
