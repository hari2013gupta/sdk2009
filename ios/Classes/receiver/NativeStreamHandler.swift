//
//  StreamHandler.swift
//  Runner
//
//  https://github.com/blackmenthor/flutter-native-sample/blob/master/ios/Runner/AppDelegate.swift

import Foundation

public class NativeStreamHandler: FlutterStreamHandler {

    var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }

}