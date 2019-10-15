package com.example.flutter_ok_sdk

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class FlutterOkSdkPlugin : MethodCallHandler {
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_ok_sdk")
            channel.setMethodCallHandler(FlutterOkSdkPlugin())
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "login") {
            okLoginManager.requestAuthorization(this, getString(R.string.ok_redirect_url),
                    OkAuthType.WEBVIEW_OAUTH,
                    OkScope.VALUABLE_ACCESS)
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }
}

//
//override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//  super.onActivityResult(requestCode, resultCode, data)
//
//
//  if (okLoginManager.onAuthActivityResult(requestCode, resultCode, data, okAuthCallback)) {
//    return
//  }
//}