package com.sdk2009.sdk2009.sdkwebview

import android.content.Context
import android.util.Log
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_APP
import com.sdk2009.sdk2009.Sdk2009Plugin.Companion.TAG_SMS_MODULE
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class WebViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        Log.d(TAG_APP, "WebViewFactory.viewId :: $viewId :: WebViewFactory")
        val methodChannel = MethodChannel(messenger, "sdk2009/webview_$viewId")
        val params = args as? Map<String, Any>
        return CustomWebView(context!!, params, methodChannel)
    }
}