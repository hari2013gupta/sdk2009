package com.sdk2009.sdk2009

import com.sdk2009.sdk2009.iconnect.Connectivity
import androidx.annotation.NonNull;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel


/**
 * The handler receives [MethodCall]s from the UIThread, gets the related information from
 * a @[Connectivity], and then send the result back to the UIThread through the [ ].
 */
internal class ConnectivityMethodChannelHandler(connectivity: Connectivity?) :
    MethodChannel.MethodCallHandler {
    private val connectivity: Connectivity

    /**
     * Construct the ConnectivityMethodChannelHandler with a `connectivity`. The `connectivity` must not be null.
     */
    init {
        checkNotNull(connectivity)
        this.connectivity = connectivity
    }

    override fun onMethodCall(call: MethodCall, @NonNull result: MethodChannel.Result) {
        if ("network_type" == call.method) {
            result.success(connectivity.networkTypes)
        } else {
            result.notImplemented()
        }
    }
}