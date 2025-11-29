//package com.energylog.app
//
//import android.app.ActivityManager
//import android.content.Context
//import android.net.TrafficStats
//import android.os.Environment
//import android.os.StatFs
//import java.io.RandomAccessFile
//import java.util.concurrent.Executors
//import java.util.concurrent.ScheduledFuture
//import java.util.concurrent.TimeUnit
//
//class PerformanceMonitor(private val context: Context) {
//
//    private val scheduler = Executors.newScheduledThreadPool(1)
//    private var cpuMonitoringTask: ScheduledFuture<*>? = null
//
//    fun getCPUUsage(): Map<String, Any> {
//        return try {
//            val cpuReader = RandomAccessFile("/proc/stat", "r")
//            val load = cpuReader.readLine().split("\\s+".toRegex())
//            cpuReader.close()
//
//            val totalTime = load.subList(1, 5).sumOf { it.toLong() }
//            val idleTime = load[4].toLong()
//            val usage = if (totalTime > 0) {
//                ((totalTime - idleTime) * 100.0 / totalTime).toFloat()
//            } else {
//                0f
//            }
//
//            mapOf<String, Any>(
//                "usagePercent" to usage,
//                "cores" to Runtime.getRuntime().availableProcessors()
//            )
//        } catch (e: Exception) {
//            mapOf<String, Any>("usagePercent" to 0f, "cores" to 0, "error" to e.message.toString())
//        }
//    }
//
//    fun getRAMInfo(): Map<String, Any> {
//        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//        val memoryInfo = ActivityManager.MemoryInfo()
//        activityManager.getMemoryInfo(memoryInfo)
//
//        return mapOf<String, Any>(
//            "totalMemory" to memoryInfo.totalMem,
//            "availableMemory" to memoryInfo.availMem,
//            "threshold" to memoryInfo.threshold,
//            "lowMemory" to memoryInfo.lowMemory,
//            "usedMemory" to (memoryInfo.totalMem - memoryInfo.availMem)
//        )
//    }
//
//    fun getStorageInfo(): Map<String, Any> {
//        val internalStats = getPartitionStats(Environment.getDataDirectory().path)
//        val externalStats = getExternalStorageStats()
//
//        return mapOf<String, Any>(
//            "internal" to internalStats,
//            "external" to externalStats
//        )
//    }
//
//    fun getNetworkUsage(): Map<String, Any> {
//        return try {
//            val uid = android.os.Process.myUid()
//            val rxBytes = TrafficStats.getUidRxBytes(uid)
//            val txBytes = TrafficStats.getUidTxBytes(uid)
//
//            // TrafficStats.UNSUPPORTED is a long value, so we need to compare with long
//            val receivedBytes = if (rxBytes != TrafficStats.UNSUPPORTED.toLong()) rxBytes else 0L
//            val transmittedBytes = if (txBytes != TrafficStats.UNSUPPORTED.toLong()) txBytes else 0L
//            val totalBytes = if (rxBytes != TrafficStats.UNSUPPORTED.toLong() && txBytes != TrafficStats.UNSUPPORTED.toLong())
//                rxBytes + txBytes else 0L
//
//            mapOf<String, Any>(
//                "receivedBytes" to receivedBytes,
//                "transmittedBytes" to transmittedBytes,
//                "totalBytes" to totalBytes
//            )
//        } catch (e: Exception) {
//            mapOf<String, Any>(
//                "receivedBytes" to 0L,
//                "transmittedBytes" to 0L,
//                "totalBytes" to 0L,
//                "error" to e.message.toString()
//            )
//        }
//    }
//
//    fun getPerformanceStats(): Map<String, Any> {
//        return mapOf<String, Any>(
//            "cpu" to getCPUUsage(),
//            "ram" to getRAMInfo(),
//            "storage" to getStorageInfo(),
//            "network" to getNetworkUsage()
//        )
//    }
//
//    private fun getPartitionStats(path: String): Map<String, Long> {
//        return try {
//            val stat = StatFs(path)
//            val blockSize = stat.blockSizeLong
//            val totalBlocks = stat.blockCountLong
//            val availableBlocks = stat.availableBlocksLong
//
//            mapOf(
//                "total" to totalBlocks * blockSize,
//                "available" to availableBlocks * blockSize,
//                "used" to (totalBlocks - availableBlocks) * blockSize
//            )
//        } catch (e: Exception) {
//            mapOf("total" to 0L, "available" to 0L, "used" to 0L)
//        }
//    }
//
//    private fun getExternalStorageStats(): Map<String, Long> {
//        return if (Environment.getExternalStorageState() == Environment.MEDIA_MOUNTED) {
//            getPartitionStats(Environment.getExternalStorageDirectory().path)
//        } else {
//            mapOf("total" to 0L, "available" to 0L, "used" to 0L)
//        }
//    }
//
//    fun startCPUMonitoring(interval: Long = 1, callback: (Float) -> Unit) {
//        cpuMonitoringTask = scheduler.scheduleAtFixedRate({
//            val usage = getCPUUsage()
//            val usagePercent = usage["usagePercent"] as? Float ?: 0f
//            callback(usagePercent)
//        }, 0, interval, TimeUnit.SECONDS)
//    }
//
//    fun stopCPUMonitoring() {
//        cpuMonitoringTask?.cancel(true)
//        cpuMonitoringTask = null
//    }
//}