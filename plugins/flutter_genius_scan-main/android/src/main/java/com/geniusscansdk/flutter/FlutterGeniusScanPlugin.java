package com.geniusscansdk.flutter;

import android.app.Activity;
import android.content.Intent;

import com.geniusscansdk.scanflow.PluginBridge;
import com.geniusscansdk.scanflow.PromiseResult;

import java.util.HashMap;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** FlutterGeniusScanPlugin */
public class FlutterGeniusScanPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {

  private FlutterPluginBinding flutterPluginBinding;
  private MethodChannel channel;
  private Activity activity;
  private Result scanWithConfigurationResult;

  // @Deprecated
  // public static void registerWith(PluginRegistry.Registrar registrar) {
  //   FlutterGeniusScanPlugin plugin = new FlutterGeniusScanPlugin();
  //   plugin.channel = new MethodChannel(registrar.messenger(), "flutter_genius_scan");
  //   plugin.activity = registrar.activity();
  //   plugin.channel.setMethodCallHandler(plugin);
  //   registrar.addActivityResultListener(plugin);
  // }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    flutterPluginBinding = binding;
    channel = new MethodChannel(binding.getBinaryMessenger(), "flutter_genius_scan");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (channel != null) {
       channel.setMethodCallHandler(null);
       channel = null;
    }
    flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
    binding.addActivityResultListener(this);
  }

  @Override
  public void onDetachedFromActivity() {
    if (channel == null) {
      return;
    }

    channel.setMethodCallHandler(null);
    channel = null;
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onMethodCall(MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "setLicenseKey": {
        PluginBridge.setLicenseKey(
                activity,
                call.argument("licenseKey"),
                call.<Boolean>argument("autoRefresh")
        );
        result.success(null);
        break;
      }
      case "scanWithConfiguration":
        scanWithConfigurationResult = result;
        PluginBridge.scanWithConfiguration(activity, call.<HashMap<String, Object>>arguments());
        break;
      case "generateDocument": {
        PromiseResult promiseResult = PluginBridge.generateDocument(
                activity,
                call.<HashMap<String, Object>>argument("document"),
                call.<HashMap<String, Object>>argument("configuration")
        );
        returnResultFromPromiseResult(result, promiseResult);
        break;
      }
      default:
        result.notImplemented();
        break;
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    PromiseResult promiseResult = PluginBridge.getPromiseResultFromActivityResult(activity, requestCode, resultCode, data);
    if (promiseResult != null && scanWithConfigurationResult != null) {
      returnResultFromPromiseResult(scanWithConfigurationResult, promiseResult);
      return true;
    }
    return false;
  }

  private void returnResultFromPromiseResult(Result result, PromiseResult promiseResult) {
    if (promiseResult.isError) {
      result.error(promiseResult.errorCode, promiseResult.errorMessage, null);
    } else {
      result.success(promiseResult.result);
    }
  }
}
