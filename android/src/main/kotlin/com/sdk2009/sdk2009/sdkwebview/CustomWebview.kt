package com.sdk2009.sdk2009.sdkwebview

import android.content.Context
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebViewClient
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class CustomWebView(
    context: Context,
    private val creationParams: Map<String, Any>?,
    private val methodChannel: MethodChannel
) : PlatformView, MethodChannel.MethodCallHandler {

    private val webView: WebView = WebView(context)

    init {
        // Initialize WebView settings
        webView.webViewClient = WebViewClient()
        webView.settings.javaScriptEnabled = true

        // Load the initial URL if provided
        val initialUrl = creationParams?.get("initialUrl") as? String
        if (!initialUrl.isNullOrEmpty()) {
            webView.loadUrl(initialUrl)
        }

        // Set up MethodChannel to handle Flutter method calls
        methodChannel.setMethodCallHandler(this)

        // Add a JavaScript interface
        webView.addJavascriptInterface(WebAppInterface(), "AndroidInterface")
    }

    override fun getView(): WebView {
        return webView
    }

    override fun dispose() {
        webView.destroy()
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "loadUrl" -> {
                val url = call.argument<String>("url")
                if (url != null) {
                    webView.loadUrl(url)
                    result.success(null)
                } else {
                    result.error("INVALID_URL", "URL is null", null)
                }
            }
            "reload" -> {
                webView.reload()
                result.success(null)
            }
            "goBack" -> {
                if (webView.canGoBack()) {
                    webView.goBack()
                    result.success(true)
                } else {
                    result.success(false)
                }
            }
            "evaluateJavascript" -> {
                val script = call.argument<String>("script")
                if (script != null) {
                    webView.evaluateJavascript(script) { value -> result.success(value) }
                } else {
                    result.error("INVALID_SCRIPT", "Script is null", null)
                }
            }
            else -> result.notImplemented()
        }
    }

    // JavaScript interface for communication
    private class WebAppInterface {
        @JavascriptInterface
        fun showToast(message: String) {
            // Example: This can be expanded for custom JS-to-Native communication
            println("Message from JavaScript: $message")
        }
    }
}
