package com.example.detail_location_detector

import android.annotation.SuppressLint
import android.content.Context
import android.net.wifi.WifiManager
import android.os.Build
import android.telephony.PhoneStateListener
import android.telephony.SignalStrength
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.resume
import kotlin.coroutines.suspendCoroutine


class MainActivity: FlutterActivity() {
    private val CHANNEL = "example.com/wifi_signal_strength"
    private lateinit var wifiManager: WifiManager
    private lateinit var telephonyManager: TelephonyManager


    @SuppressLint("MissingPermission")
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
        telephonyManager =
            applicationContext.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager


        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "getValue") {
                val wifiInfo = wifiManager.connectionInfo
                result.success(wifiInfo.rssi)
            } else if (call.method == "getCellular") {
//                val cellularSignalStrength = telephonyManager.signalStrength?.getGsmRssi()
//                result.success(cellularSignalStrength)
                val cellInfo = telephonyManager.allCellInfo
                if (cellInfo != null && cellInfo.isNotEmpty()) {
                    val cellSignalStrength = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        cellInfo[0].cellSignalStrength
                    } else {
                        TODO("VERSION.SDK_INT < R")
                    }
                    val cellularSignalStrength = cellSignalStrength.dbm
                    result.success(cellularSignalStrength)
                } else {
                    result.notImplemented()
                }
            }
        }
    }}
