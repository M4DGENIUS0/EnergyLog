package com.example.energylog

import android.app.ActivityManager
import android.app.usage.StorageStatsManager
import android.content.Context
import android.net.TrafficStats
import android.os.Build
import android.os.Environment
import android.os.StatFs
import java.io.RandomAccessFile
import java.util.concurrent.Executors
import java.util.concurrent.ScheduledFuture
import java.util.concurrent.TimeUnit

class PerformanceMonitor(private val context: Context) {

    private val scheduler = Executors.newScheduledThreadPool(1)
    private var cpuMonitoringTask: ScheduledFuture<*>? = null

    fun getCPUUsage(): Map<String, Any> {
        return try {
            val cpuReader = RandomAccessFile("/proc/stat", "r")
            val load = cpuReader.readLine().split("\\s+".toRegex())
            cpuReader.close()

            val totalTime = load.subList(1, 5).sumOf { it.toLong() }
            val idleTime = load[4].toLong()
            val usage = if (totalTime > 0) {
                ((totalTime - idleTime) * 100.0 / totalTime).toFloat()
            } else {
                0f
            }

            mapOf(
                "usagePercent" to usage,
                "cores" to Runtime.getRuntime().availableProcessors()
            )
        } catch (e: Exception) {
            mapOf("usagePercent" to 0f, "cores" to 0, "error" to e.message)
        }
    }

    fun getRAMInfo(): Map<String, Any> {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        return mapOf(
            "totalMemory" to memoryInfo.totalMem,
            "availableMemory" to memoryInfo.availMem,
            "threshold" to memoryInfo.threshold,
            "lowMemory" to memoryInfo.lowMemory,
            "usedMemory" to (memoryInfo.totalMem - memoryInfo.availMem)
        )
    }

    fun getStorageInfo(): Map<String, Any> {
        val internalStats = getPartitionStats(Environment.getDataDirectory().path)
        val externalStats = getExternalStorageStats()

        return mapOf(
            "internal" to internalStats,
            "external" to externalStats
        )
    }

    fun getNetworkUsage(): Map<String, Any> {
        return try {
            val uid = android.os.Process.myUid()
            val rxBytes = TrafficStats.getUidRxBytes(uid)
            val txBytes = TrafficStats.getUidTxBytes(uid)

            mapOf(
                "receivedBytes" to (if (rxBytes != TrafficStats.UNSUPPORTED) rxBytes else 0),
                "transmittedBytes" to (if (txBytes != TrafficStats.UNSUPPORTED) txBytes else 0),
                "totalBytes" to (if (rxBytes != TrafficStats.UNSUPPORTED && txBytes != TrafficStats.UNSUPPORTED)
                    rxBytes + txBytes else 0)
            )
        } catch (e: Exception) {
            mapOf(
                "receivedBytes" to 0,
                "transmittedBytes" to 0,
                "totalBytes" to 0,
                "error" to e.message
            )
        }
    }

    fun getPerformanceStats(): Map<String, Any> {
        return mapOf(
            "cpu" to getCPUUsage(),
            "ram" to getRAMInfo(),
            "storage" to getStorageInfo(),
            "network" to getNetworkUsage()
        )
    }

    private fun getPartitionStats(path: String): Map<String, Long> {
        return try {
            val stat = StatFs(path)
            val blockSize = stat.blockSizeLong
            val totalBlocks = stat.blockCountLong
            val availableBlocks = stat.availableBlocksLong

            mapOf(
                "total" to totalBlocks * blockSize,
                "available" to availableBlocks * blockSize,
                "used" to (totalBlocks - availableBlocks) * blockSize
            )
        } catch (e: Exception) {
            mapOf("total" to 0L, "available" to 0L, "used" to 0L)
        }
    }

    private fun getExternalStorageStats(): Map<String, Long> {
        return if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
            getPartitionStats(Environment.getExternalStorageDirectory().path)
        } else {
            mapOf("total" to 0L, "available" to 0L, "used" to 0L)
        }
    }

    fun startCPUMonitoring(interval: Long = 1, callback: (Float) -> Unit) {
        cpuMonitoringTask = scheduler.scheduleAtFixedRate({
            val usage = getCPUUsage()
            val usagePercent = usage["usagePercent"] as? Float ?: 0f
            callback(usagePercent)
        }, 0, interval, TimeUnit.SECONDS)
    }

    fun stopCPUMonitoring() {
        cpuMonitoringTask?.cancel(true)
        cpuMonitoringTask = null
    }
}