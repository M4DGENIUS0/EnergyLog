package com.energylog.app

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build
import android.os.Process
import java.util.Calendar
import kotlin.math.abs

class BatteryInfo(private val context: Context) {

    private val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
    private val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager

    fun getBatteryLevel(): Int {
        val batteryStatus = getBatteryIntent()
        val level = batteryStatus?.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) ?: -1
        val scale = batteryStatus?.getIntExtra(BatteryManager.EXTRA_SCALE, -1) ?: -1
        return if (level >= 0 && scale > 0) (level * 100 / scale.toFloat()).toInt() else -1
    }

    fun getBatteryVoltage(): Float {
        val batteryStatus = getBatteryIntent()
        // Voltage is usually in mV
        return batteryStatus?.getIntExtra(BatteryManager.EXTRA_VOLTAGE, -1)?.div(1000f) ?: -1f
    }

    fun getBatteryTemperature(): Float {
        val batteryStatus = getBatteryIntent()
        // Temperature is in tenths of a degree Centigrade
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

    fun getBatteryHealth(): String {
        val batteryStatus = getBatteryIntent()
        val health = batteryStatus?.getIntExtra(BatteryManager.EXTRA_HEALTH, -1) ?: -1
        return when (health) {
            BatteryManager.BATTERY_HEALTH_GOOD -> "Good"
            BatteryManager.BATTERY_HEALTH_OVERHEAT -> "Overheat"
            BatteryManager.BATTERY_HEALTH_DEAD -> "Dead"
            BatteryManager.BATTERY_HEALTH_OVER_VOLTAGE -> "Over Voltage"
            BatteryManager.BATTERY_HEALTH_UNSPECIFIED_FAILURE -> "Failure"
            BatteryManager.BATTERY_HEALTH_COLD -> "Cold"
            else -> "Unknown"
        }
    }

    fun getBatteryTechnology(): String {
        val batteryStatus = getBatteryIntent()
        return batteryStatus?.getStringExtra(BatteryManager.EXTRA_TECHNOLOGY) ?: "Unknown"
    }

    // Current in MicroAmperes (µA)
    fun getBatteryCurrentNow(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_NOW)
        } else {
            0
        }
    }

    // Average Current in MicroAmperes (µA)
    fun getBatteryCurrentAverage(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CURRENT_AVERAGE)
        } else {
            0
        }
    }

    // Charge Counter in MicroAmpere-hours (µAh)
    fun getBatteryChargeCounter(): Int {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CHARGE_COUNTER)
        } else {
            0
        }
    }

    // Energy Counter in NanoWatt-hours (nWh)
    fun getBatteryEnergyCounter(): Long {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            batteryManager.getLongProperty(BatteryManager.BATTERY_PROPERTY_ENERGY_COUNTER)
        } else {
            0L
        }
    }

    // Compute Time Remaining (in minutes)
    // This is an estimation: Capacity (Ah) / Current (A)
    fun getEstimatedTimeRemaining(): Long {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            val currentNow = abs(getBatteryCurrentNow()) // in µA
            if (currentNow == 0) return -1L

            // If discharging, we use remaining capacity
            // If charging, we might want to use (Total Capacity - Current Capacity) / Current
            // But Android's CHARGE_COUNTER is "Battery capacity in microampere-hours, as an integer."
            // It usually represents the remaining charge.

            val chargeCounter = getBatteryChargeCounter() // in µAh

            if (chargeCounter > 0) {
                 // hours = (µAh) / (µA)
                 // minutes = hours * 60
                 return (chargeCounter.toDouble() / currentNow.toDouble() * 60).toLong()
            }
        }
        return -1L
    }

    // Fetch Screen Time (in minutes) for the current day
    fun getScreenTime(): Long {
        if (!hasUsageStatsPermission()) {
            return -1L
        }

        val calendar = Calendar.getInstance()
        val endTime = calendar.timeInMillis
        calendar.set(Calendar.HOUR_OF_DAY, 0)
        calendar.set(Calendar.MINUTE, 0)
        calendar.set(Calendar.SECOND, 0)
        val startTime = calendar.timeInMillis

        val stats = usageStatsManager.queryUsageStats(
            UsageStatsManager.INTERVAL_DAILY, startTime, endTime
        )

        var totalTime = 0L
        if (stats != null) {
            for (usageStats in stats) {
                totalTime += usageStats.totalTimeInForeground
            }
        }
        return totalTime / 1000 / 60 // Convert ms to minutes
    }

    fun hasUsageStatsPermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName
            )
        } else {
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                context.packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    fun getBatteryInfo(): Map<String, Any> {
        val voltage = getBatteryVoltage()
        val currentNow = getBatteryCurrentNow() // µA
        val power = if (voltage > 0) (abs(currentNow) / 1000000.0 * voltage) else 0.0 // W = A * V

        return mapOf(
            "level" to getBatteryLevel(),
            "voltage" to voltage,
            "temperature" to getBatteryTemperature(),
            "status" to getBatteryStatus(),
            "health" to getBatteryHealth(),
            "technology" to getBatteryTechnology(),
            "currentNow" to currentNow,
            "currentAverage" to getBatteryCurrentAverage(),
            "chargeCounter" to getBatteryChargeCounter(),
            "energyCounter" to getBatteryEnergyCounter(),
            "power" to power, // Watts
            "timeRemaining" to getEstimatedTimeRemaining(), // Minutes
            "screenTime" to getScreenTime() // Minutes (-1 if permission denied)
        )
    }

    private fun getBatteryIntent(): Intent? {
        return context.registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
    }
}