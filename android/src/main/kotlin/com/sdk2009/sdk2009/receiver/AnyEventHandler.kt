package com.sdk2009.sdk2009.receiver

import io.flutter.plugin.common.EventChannel;

object AnyEventHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        this.eventSink = events
        // Trigger events from native code when needed
        // Example: this.eventSink.success("Event data");
    }

    override fun onCancel(arguments: Any?) {
        this.eventSink = null
    }

    // Method to trigger the event from the plugin
    fun triggerEvent(eventData: String?) {
        eventSink?.success(eventData) // Send event data to Flutter
    }
}