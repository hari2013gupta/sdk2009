import Flutter
import UIKit
import Foundation

public class AnyEventHandler: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        // Example: self.eventSink?("Event data")
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

    // Method to trigger the event from the plugin
    public func triggerEvent(eventData: String) {
        if let eventSink = self.eventSink {
            eventSink(eventData) // Send event data to Flutter
        }
    }
}
