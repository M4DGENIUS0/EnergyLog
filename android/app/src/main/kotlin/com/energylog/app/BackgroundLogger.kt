//package com.energylog.app
//
//import android.content.Context
//import kotlinx.coroutines.Dispatchers
//import kotlinx.coroutines.withContext
//import org.json.JSONObject
//import java.io.File
//import java.text.SimpleDateFormat
//import java.util.*
//import java.util.concurrent.Executors
//import java.util.concurrent.ScheduledFuture
//import java.util.concurrent.TimeUnit
//
//class BackgroundLogger(private val context: Context) {
//
//    private val scheduler = Executors.newScheduledThreadPool(1)
//    private var loggingTask: ScheduledFuture<*>? = null
//
//    suspend fun logCurrentData(): Map<String, Any> {
//        return withContext(Dispatchers.IO) {
//            try {
//                val batteryInfo = BatteryInfo(context).getBatteryInfo()
//                val performanceStats = PerformanceMonitor(context).getPerformanceStats()
//                val appUsageStats = AppUsageStats(context).getTopUsedApps("daily")
//
//                val logEntry = mapOf(
//                    "timestamp" to System.currentTimeMillis(),
//                    "battery" to batteryInfo.mapValues { it.value.toString() },
//                    "performance" to performanceStats.mapValues { it.value.toString() },
//                    "topApps" to appUsageStats // Remove mapValues - keep as is
//                )
//
//                saveLogToFile(logEntry)
//                mapOf("success" to true, "logEntry" to logEntry)
//            } catch (e: Exception) {
//                mapOf("success" to false, "error" to e.message.orEmpty())
//            }
//        }
//    }
//
//
//    private fun saveLogToFile(logEntry: Map<String, Any>) {
//        try {
//            val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
//            val fileName = "energy_log_${dateFormat.format(Date())}.json"
//            val file = File(context.filesDir, fileName)
//
//            val jsonLog = JSONObject(logEntry).toString(2) + ",\n"
//
//            if (!file.exists()) {
//                file.writeText("[\n")
//            }
//
//            file.appendText(jsonLog)
//        } catch (e: Exception) {
//            e.printStackTrace()
//        }
//    }
//
//    fun startPeriodicLogging(intervalMinutes: Long = 15) {
//        stopPeriodicLogging() // Stop any existing logging
//
//        loggingTask = scheduler.scheduleAtFixedRate({
//            try {
//                // We'll log synchronously for now - in production you might want to use a coroutine
//                val batteryInfo = BatteryInfo(context).getBatteryInfo()
//                val performanceStats = PerformanceMonitor(context).getPerformanceStats()
//                val appUsageStats = AppUsageStats(context).getTopUsedApps("daily")
//
//                val logEntry = mapOf(
//                    "timestamp" to System.currentTimeMillis(),
//                    "battery" to batteryInfo,
//                    "performance" to performanceStats,
//                    "topApps" to appUsageStats
//                )
//
//                saveLogToFile(logEntry)
//            } catch (e: Exception) {
//                e.printStackTrace()
//            }
//        }, 0, intervalMinutes, TimeUnit.MINUTES)
//    }
//
//    fun stopPeriodicLogging() {
//        loggingTask?.cancel(true)
//        loggingTask = null
//    }
//
//    fun getLogFiles(): List<Map<String, Any>> {
//        return try {
//            context.filesDir.listFiles()?.filter { file ->
//                file.name.startsWith("energy_log_") && file.name.endsWith(".json")
//            }?.map { file ->
//                mapOf(
//                    "fileName" to file.name,
//                    "fileSize" to file.length(),
//                    "lastModified" to file.lastModified(),
//                    "entryCount" to countEntries(file)
//                )
//            } ?: emptyList()
//        } catch (e: Exception) {
//            emptyList()
//        }
//    }
//
//    private fun countEntries(file: File): Int {
//        return try {
//            val content = file.readText()
//            content.count { it == '}' } - 1 // Subtract 1 for the closing bracket
//        } catch (e: Exception) {
//            0
//        }
//    }
//
//    fun cleanup() {
//        stopPeriodicLogging()
//        scheduler.shutdown()
//    }
//}