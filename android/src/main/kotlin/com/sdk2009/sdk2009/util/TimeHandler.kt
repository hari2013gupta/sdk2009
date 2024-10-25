package com.sdk2009.sdk2009.util

import io.flutter.plugin.common.EventChannel
import android.annotation.SuppressLint
import android.os.Handler
import android.os.Looper
import java.text.SimpleDateFormat
import java.util.Date

object TimeHandler : EventChannel.StreamHandler {
    // Handle event in main thread.
    private var handler = Handler(Looper.getMainLooper())

    // Declare our eventSink later it will be initialized
    private var eventSink: EventChannel.EventSink? = null

    @SuppressLint("SimpleDateFormat")
    override fun onListen(p0: Any?, events: EventChannel.EventSink) {
        eventSink = events
        // every second send the time
        val r: Runnable = object : Runnable {
            override fun run() {
                handler.post {
                    val dateFormat = SimpleDateFormat("HH:mm:ss")
                    val time = dateFormat.format(Date())
                    eventSink?.success(time)
                }
                handler.postDelayed(this, 1000)
            }
        }
        handler.postDelayed(r, 1000)
    }

    override fun onCancel(p0: Any?) {
        eventSink = null
    }
}