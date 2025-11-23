package com.example.energylog

import android.content.Context
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class PowerMonitorChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    private val batteryInfo = BatteryInfo(context)
    private val appUsageStats = AppUsageStats(context)
    private val performanceMonitor = PerformanceMonitor(context)
    private val logExporter = LogExporter(context)

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getBatteryInfo" -> handleGetBatteryInfo(result)
            "getPerformanceStats" -> handleGetPerformanceStats(result)
            "getTopUsedApps" -> handleGetTopUsedApps(call, result)
            "getAppUsage" -> handleGetAppUsage(call, result)
            "hasUsageAccessPermission" -> handleHasUsageAccessPermission(result)
            "openUsageAccessSettings" -> handleOpenUsageAccessSettings(result)
            "startLogging" -> handleStartLogging(result)
            "stopLogging" -> handleStopLogging(result)
            "exportToJSON" -> handleExportToJSON(call, result)
            "exportToCSV" -> handleExportToCSV(call, result)
            "getAvailableLogs" -> handleGetAvailableLogs(result)
            else -> result.notImplemented()
        }
    }

    private fun handleGetBatteryInfo(result: MethodChannel.Result) {
        try {
            result.success(batteryInfo.getBatteryInfo())
        } catch (e: Exception) {
            result.error("BATTERY_ERROR", e.message, null)
        }
    }

    private fun handleGetPerformanceStats(result: MethodChannel.Result) {
        try {
            result.success(performanceMonitor.getPerformanceStats())
        } catch (e: Exception) {
            result.error("PERFORMANCE_ERROR", e.message, null)
        }
    }

    private fun handleGetTopUsedApps(call: MethodCall, result: MethodChannel.Result) {
        try {
            val interval = call.argument<String>("interval") ?: "daily"
            result.success(appUsageStats.getTopUsedApps(interval))
        } catch (e: Exception) {
            result.error("USAGE_STATS_ERROR", e.message, null)
        }
    }

    private fun handleGetAppUsage(call: MethodCall, result: MethodChannel.Result) {
        try {
            val packageName = call.argument<String>("packageName") ?: return result.error(
                "INVALID_ARGUMENT", "Package name is required", null
            )
            val days = call.argument<Int>("days") ?: 1
            result.success(appUsageStats.getAppUsageForPackage(packageName, days))
        } catch (e: Exception) {
            result.error("APP_USAGE_ERROR", e.message, null)
        }
    }

    private fun handleHasUsageAccessPermission(result: MethodChannel.Result) {
        try {
            result.success(appUsageStats.hasUsageAccessPermission())
        } catch (e: Exception) {
            result.error("PERMISSION_CHECK_ERROR", e.message, null)
        }
    }

    private fun handleOpenUsageAccessSettings(result: MethodChannel.Result) {
        try {
            appUsageStats.openUsageAccessSettings()
            result.success(null)
        } catch (e: Exception) {
            result.error("SETTINGS_ERROR", e.message, null)
        }
    }

    private fun handleStartLogging(result: MethodChannel.Result) {
        try {
            BackgroundLogger.startPeriodicLogging(context)
            result.success(true)
        } catch (e: Exception) {
            result.error("LOGGING_ERROR", e.message, null)
        }
    }

    private fun handleStopLogging(result: MethodChannel.Result) {
        try {
            BackgroundLogger.stopPeriodicLogging(context)
            result.success(true)
        } catch (e: Exception) {
            result.error("LOGGING_ERROR", e.message, null)
        }
    }

    private fun handleExportToJSON(call: MethodCall, result: MethodChannel.Result) {
        try {
            val days = call.argument<Int>("days") ?: 7
            val filePath = logExporter.exportToJSON(days)
            result.success(mapOf("filePath" to filePath, "success" to true))
        } catch (e: Exception) {
            result.error("EXPORT_ERROR", e.message, null)
        }
    }

    private fun handleExportToCSV(call: MethodCall, result: MethodChannel.Result) {
        try {
            val days = call.argument<Int>("days") ?: 7
            val filePath = logExporter.exportToCSV(days)
            result.success(mapOf("filePath" to filePath, "success" to true))
        } catch (e: Exception) {
            result.error("EXPORT_ERROR", e.message, null)
        }
    }

    private fun handleGetAvailableLogs(result: MethodChannel.Result) {
        try {
            result.success(logExporter.getAvailableLogs())
        } catch (e: Exception) {
            result.error("LOGS_ERROR", e.message, null)
        }
    }
}