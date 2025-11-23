package com.example.energylog

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager

class BatteryInfo(private val context: Context) {

    fun getBatteryLevel(): Int {
        val batteryStatus = getBatteryIntent()
        val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        return if (level >= 0 && scale > 0) (level * 100 / scale.toFloat()).toInt() else -1
    }

    fun getBatteryVoltage(): Float {
        val batteryStatus = getBatteryIntent()
        return batteryStatus?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)?.div(1000f) ?: -1f
    }

    fun getBatteryTemperature(): Float {
        val batteryStatus = getBatteryIntent()
        return batteryStatus?.getIntExtra(BatteryManager.EXTRA_TEMPERATURE, -1)?.div(10f) ?: -1f
    }

    fun getBatteryStatus(): String {
        val batteryStatus = getBatteryIntent()
        val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1
        return when (status) {
            BatteryManager.BATTERY_STATUS_CHARGING -> "Charging"
            BatteryManager.BATTERY_STATUS_DISCHARGING -> "Discharging"
            BatteryManager.BATTERY_STATUS_FULL -> "Full"
            BatteryManager.BATTERY_STATUS_NOT_CHARGING -> "Not Charging"
            else -> "Unknown"
        }
    }

    fun getBatteryInfo(): Map<String, Any> {
        return mapOf(
            "level" to getBatteryLevel(),
            "voltage" to getBatteryVoltage(),
            "temperature" to getBatteryTemperature(),
            "status" to getBatteryStatus(),
            "health" to getBatteryHealth(),
            "technology" to getBatteryTechnology()
        )
    }

    private fun getBatteryHealth(): String {
        val batteryStatus = getBatteryIntent()
        val health = batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1
        return when (health) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Failure"
            else -> "Unknown"
        }
    }

    private fun getBatteryTechnology(): String {
        val batteryStatus = getBatteryIntent()
        return batteryStatus?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Unknown"
    }

    private fun getBatteryIntent(): Intent? {
        return context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }
}