package com.sdk2009.sdk2009.sdkwebview

import android.content.Context
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class WebViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val methodChannel = MethodChannel(messenger, "basic_webview_plugin/webview_$viewId")
        val params = args as? Map<String, Any>
        return CustomWebView(context!!, params, methodChannel)
    }
}