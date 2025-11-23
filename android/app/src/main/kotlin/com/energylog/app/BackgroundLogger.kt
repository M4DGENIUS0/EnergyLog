package com.example.energylog

import android.content.Context
import androidx.work.CoroutineWorker
import androidx.work.Data
import androidx.work.PeriodicWorkRequest
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import org.json.JSONObject
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.TimeUnit

class BackgroundLogger(
    context: Context,
    params: WorkerParameters
) : CoroutineWorker(context, params) {

    override suspend fun doWork(): Result = withContext(Dispatchers.IO) {
        try {
            val batteryInfo = BatteryInfo(applicationContext).getBatteryInfo()
            val performanceStats = PerformanceMonitor(applicationContext).getPerformanceStats()
            val appUsageStats = AppUsageStats(applicationContext).getTopUsedApps("daily")

            val logEntry = mapOf(
                "timestamp" to System.currentTimeMillis(),
                "battery" to batteryInfo,
                "performance" to performanceStats,
                "topApps" to appUsageStats
            )

            saveLogToFile(logEntry)
            Result.success()
        } catch (e: Exception) {
            Result.failure()
        }
    }

    private fun saveLogToFile(logEntry: Map<String, Any>) {
        try {
            val dateFormat = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
            val fileName = "energy_log_${dateFormat.format(Date())}.json"
            val file = File(applicationContext.filesDir, fileName)

            val jsonLog = JSONObject(logEntry).toString(2) + ",\n"

            if (!file.exists()) {
                file.writeText("[\n")
            }

            file.appendText(jsonLog)
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

    companion object {
        fun startPeriodicLogging(context: Context) {
            val loggingWork = PeriodicWorkRequestBuilder<BackgroundLogger>(
                15, TimeUnit.MINUTES, // Every 15 minutes
                5, TimeUnit.MINUTES   // Flexible interval
            ).build()

            WorkManager.getInstance(context).enqueue(loggingWork)
        }

        fun stopPeriodicLogging(context: Context) {
            WorkManager.getInstance(context).cancelAllWork()
        }
    }
}