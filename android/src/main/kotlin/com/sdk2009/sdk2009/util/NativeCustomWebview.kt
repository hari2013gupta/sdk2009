package com.sdk2009.sdk2009.util

import android.content.Context
import com.sdk2009.sdk2009.sdkwebview.CustomWebView
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.StandardMessageCodec

class WebViewFactory(private val messenger: BinaryMessenger) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val methodChannel = MethodChannel(messenger, "basic_webview_plugin/webview_$viewId")
        return CustomWebView(context!!, args as? Map<String, Any>, methodChannel)
    }
}