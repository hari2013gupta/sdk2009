package com.sdk2009.sdk2009.util

import android.annotation.SuppressLint
import android.content.Context
import android.content.ContextWrapper
import android.content.pm.PackageManager
import android.content.pm.PackageManager.NameNotFoundException
import android.content.pm.Signature
import android.os.Build
import android.util.Base64
import android.util.Log
import java.nio.charset.Charset
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.Arrays


/**
 * This is a helper class to generate your message hash to be included in your SMS message.
 *
 *
 * Without the correct hash, your app won't receive the message callback. This only needs to be
 * generated once per app and stored. Then you can remove this helper class from your code.
 */
class AppSignatureHelper(context: Context?) : ContextWrapper(context) {
    val appSignature: String
        /**
         * Get first app signature.
         */
        get() {
            val appSignatures = this.appSignatures
            return if (!appSignatures.isEmpty()) {
                appSignatures[0]
            } else {
                "NA"
            }
        }

    @get:SuppressLint("PackageManagerGetSignatures")
    val appSignatures: ArrayList<String>
        /**
         * Get all the app signatures for the current package
         */
        get() {
            val appCodes = ArrayList<String>()

            try {
                // Get all package signatures for the current package
                val packageName = packageName
                val signatures = getSignatures(packageName)

                // For each signature create a compatible hash
                for (signature in signatures) {
                    val hash = hash(packageName, signature.toCharsString())
                    if (hash != null) {
                        appCodes.add(String.format("%s", hash))
                    }
                }
            } catch (e: NameNotFoundException) {
                Log.e(TAG, "Unable to find package to obtain hash.", e)
            }
            return appCodes
        }

    @Throws(NameNotFoundException::class)
    private fun getSignatures(packageName: String): Array<Signature> {
        val packageManager = packageManager
        val signatures: Array<Signature> = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
            packageManager.getPackageInfo(
                packageName,
                PackageManager.GET_SIGNING_CERTIFICATES
            ).signingInfo.apkContentsSigners
        } else {
            packageManager.getPackageInfo(
                packageName,
                PackageManager.GET_SIGNATURES
            ).signatures
        }
        return signatures
    }

    companion object {
        val TAG: String = AppSignatureHelper::class.java.simpleName

        private const val HASH_TYPE = "SHA-256"
        const val NUM_HASHED_BYTES: Int = 9
        const val NUM_BASE64_CHAR: Int = 11

        private fun hash(packageName: String, signature: String): String? {
            val appInfo = "$packageName $signature"
            try {
                val messageDigest = MessageDigest.getInstance(HASH_TYPE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                    messageDigest.update(appInfo.toByteArray(StandardCharsets.UTF_8))
                } else {
                    messageDigest.update(appInfo.toByteArray(Charset.forName("UTF-8")))
                }
                var hashSignature = messageDigest.digest()

                // truncated into NUM_HASHED_BYTES
                hashSignature = Arrays.copyOfRange(hashSignature, 0, NUM_HASHED_BYTES)
                // encode into Base64
                var base64Hash =
                    Base64.encodeToString(hashSignature, Base64.NO_PADDING or Base64.NO_WRAP)
                base64Hash = base64Hash.substring(0, NUM_BASE64_CHAR)
                return base64Hash
            } catch (e: NoSuchAlgorithmException) {
                Log.e(TAG, "hash:NoSuchAlgorithm", e)
            }
            return null
        }
    }
}