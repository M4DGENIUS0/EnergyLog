package com.energylog.app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import java.util.Timer
import java.util.TimerTask

class MainActivity : FlutterActivity() {
    private val BATTERY_CHANNEL = "com.energylog.app/battery_stream"
    private var batteryInfo: BatteryInfo? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        batteryInfo = BatteryInfo(this)

        // Enable edge-to-edge
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            WindowCompat.setDecorFitsSystemWindows(window, false)
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Method Channel for actions
        val powerMonitorChannel = PowerMonitorChannel(this)
        io.flutter.plugin.common.MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.energylog.app/battery_actions")
            .setMethodCallHandler(powerMonitorChannel)

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                private var timer: Timer? = null
                private var receiver: BroadcastReceiver? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    // Send initial data
                    events?.success(batteryInfo?.getBatteryInfo())

                    // 1. Listen for system broadcasts (state changes)
                    receiver = object : BroadcastReceiver() {
                        override fun onReceive(context: Context?, intent: Intent?) {
                            events?.success(batteryInfo?.getBatteryInfo())
                        }
                    }
                    val filter = IntentFilter().apply {
                        addAction(Intent.ACTION_BATTERY_CHANGED)
                        addAction(Intent.ACTION_POWER_CONNECTED)
                        addAction(Intent.ACTION_POWER_DISCONNECTED)
                    }
                    registerReceiver(receiver, filter)

                    // 2. Poll for live data (Current/Voltage changes often without broadcast)
                    timer = Timer()
                    timer?.schedule(object : TimerTask() {
                        override fun run() {
                            Handler(Looper.getMainLooper()).post {
                                events?.success(batteryInfo?.getBatteryInfo())
                            }
                        }
                    }, 0, 2000) // Update every 2 seconds
                }

                override fun onCancel(arguments: Any?) {
                    unregisterReceiver(receiver)
                    receiver = null
                    timer?.cancel()
                    timer = null
                }
            }
        )

        // System Info Channel (RAM)
        val systemInfo = SystemInfo(this)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, "com.energylog.app/system_stream").setStreamHandler(
            object : EventChannel.StreamHandler {
                private var timer: Timer? = null

                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    timer = Timer()
                    timer?.schedule(object : TimerTask() {
                        override fun run() {
                            Handler(Looper.getMainLooper()).post {
                                events?.success(systemInfo.getRamInfo())
                            }
                        }
                    }, 0, 1000) // Update every 1 second
                }

                override fun onCancel(arguments: Any?) {
                    timer?.cancel()
                    timer = null
                }
            }
        )
    }
}
