package com.example.flutter_ok_sdk

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.content.res.Resources
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.PluginRegistry.Registrar
import org.json.JSONException
import org.json.JSONObject

import ru.ok.android.sdk.Odnoklassniki
import ru.ok.android.sdk.OkListener
import ru.ok.android.sdk.util.OkAuthType
import ru.ok.android.sdk.util.OkScope

class FlutterOkSdkPlugin : MethodCallHandler, PluginRegistry.ActivityResultListener {

    internal var methodChannelResult: MethodChannel.Result? = null

    private lateinit var okLoginManager: Odnoklassniki
    var activity: Activity? = null

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "flutter_ok_sdk")
            val plugin = FlutterOkSdkPlugin()
            registrar.addActivityResultListener(plugin)
            plugin.activity = registrar.activity()
            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "login") {
            methodChannelResult = result

            okLoginManager = Odnoklassniki.createInstance(
                    activity!!.applicationContext,
                    getResourceFromContext(activity!!.applicationContext, "ok_sdk_app_id"),
                    getResourceFromContext(activity!!.applicationContext, "ok_sdk_app_key")
            )

            okLoginManager.requestAuthorization(activity!!,
                    getResourceFromContext(activity!!.applicationContext, "ok_redirect_url"),
                    OkAuthType.WEBVIEW_OAUTH,
                    OkScope.VALUABLE_ACCESS
            )
//            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    private fun getResourceFromContext(context: Context, resName: String): String {
        val stringRes = context.resources.getIdentifier(resName, "string", context.packageName)
        if (stringRes == 0) {
            throw IllegalArgumentException(String.format("The 'R.string.%s' value it's not defined in your project's resources file.", resName))
        }
        return context.getString(stringRes)
    }

    private val okAuthCallback = object : OkListener {
        override fun onSuccess(json: JSONObject) {
            try {
                println(json)
                val token = json.getString("access_token")
                val secretKey = json.getString("session_secret_key")
                val expires_in = json.getString("expires_in")
                val hashmap = HashMap<String, String>()
                hashmap["access_token"] = token
                hashmap["secret"] = secretKey
                hashmap["expires_in"] = expires_in
                methodChannelResult?.let {
                    it.success(hashmap)
                }
            } catch (exception: JSONException) {
                onError(exception.localizedMessage)
            }

        }

        override fun onError(error: String?) {
            methodChannelResult?.let {
                it.error("UNAVAILABLE", "OK login error", null)
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        // TODO: check if needs super
        // super.onActivityResult(requestCode, resultCode, data)
        if (okLoginManager.onAuthActivityResult(requestCode, resultCode, data, okAuthCallback)) {
            return true
        }
        return true
    }
}
