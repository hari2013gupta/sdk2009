package com.sdk2009.sdk2009.util

import android.content.Context
import android.webkit.WebChromeClient
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec

class WebViewFactory(private val messenger: BinaryMessenger) :
    PlatformViewFactory(StandardMessageCodec.INSTANCE) {
    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        val params = args as? Map<String, Any>
        return CustomWebView(context!!, viewId, params)
    }
}

class CustomWebView(private val context: Context, viewId: Int, args: Map<String, Any>?) :
    PlatformView {
    private val webView: WebView = WebView(context)

    init {
        val initialUrl = args?.get("initialUrl") as? String
        webView.webViewClient = WebViewClient()
        webView.webChromeClient = WebChromeClient()
        webView.settings.javaScriptEnabled = true
        if (!initialUrl.isNullOrEmpty()) {
            webView.loadUrl(initialUrl)
        }
    }

    override fun getView(): WebView {
        return webView
    }

    override fun dispose() {
        webView.destroy()
    }
}