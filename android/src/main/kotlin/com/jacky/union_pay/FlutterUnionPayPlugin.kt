package com.jacky.union_pay

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StringCodec;
import android.app.Activity
import android.content.Intent
import android.util.Log
import android.widget.Toast
import com.unionpay.UPPayAssistEx

import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import org.json.JSONObject
import java.util.*
import kotlin.collections.HashMap


/** FlutterUnionPayPlugin */
class FlutterUnionPayPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener  {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var messageChannel: BasicMessageChannel<String>? = null
  private var activity: Activity? = null

  companion object {
    const val PAYMENT_CANCEL = 0
    const val PAYMENT_SUCCESS = 1
    const val PAYMENT_FAIL = 2

    const val PACKAGE_NAME = "flutter_union_pay"
    const val MESSAGE_CHANNEL_NAME = "flutter_union_pay.message"
  }


  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, PACKAGE_NAME)
    messageChannel = BasicMessageChannel(flutterPluginBinding.binaryMessenger, MESSAGE_CHANNEL_NAME, StringCodec.INSTANCE)
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "version" -> {
        result.success(UPPayAssistEx.VERSION)
      }
      "installed" -> {
        Log.e("ctx", activity.toString())
        Toast.makeText(activity, "test", Toast.LENGTH_LONG).show()
        val installed = UPPayAssistEx.checkWalletInstalled(activity)
        result.success(installed)
      }
      "pay" -> {
        val tn = call.argument<String>("tn")
        val env = call.argument<String>("env")
        Log.e("tn+env", tn +"<<>>"+ env)
        val ret = UPPayAssistEx.startPay(activity, null, null, tn, env)
        Log.e("ret", ret.toString())
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }


  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener(this)
  }


  override fun onDetachedFromActivityForConfigChanges() {
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    onAttachedToActivity(binding)
  }

  override fun onDetachedFromActivity() {
  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
    if (data == null) {
      return true
    }
    var payload: HashMap<String, Any?> = HashMap()
    val paymentStatus = data.extras?.getString("pay_result")
    when (paymentStatus?.toLowerCase(Locale.ROOT)) {
      "success" -> payload["code"] = PAYMENT_SUCCESS
      "fail"-> payload["code"] = PAYMENT_FAIL
      "cancel"-> payload["code"] = PAYMENT_CANCEL
    }
    Log.i("payload",payload.toString())
    messageChannel?.send(JSONObject(payload).toString())
    return true
  }
}
