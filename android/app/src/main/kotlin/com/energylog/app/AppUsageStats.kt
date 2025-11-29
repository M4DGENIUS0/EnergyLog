//package com.energylog.app
//
//import android.app.usage.UsageStats
//import android.app.usage.UsageStatsManager
//import android.content.Context
//import android.content.Intent
//import android.content.pm.ApplicationInfo
//import android.content.pm.PackageManager
//import android.provider.Settings
//import java.util.Calendar
//import java.util.concurrent.TimeUnit
//
//class AppUsageStats(private val context: Context) {
//
//    private val usageStatsManager: UsageStatsManager? by lazy {
//        context.getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
//    }
//
//    fun hasUsageAccessPermission(): Boolean {
//        val currentTime = System.currentTimeMillis()
//        val stats = usageStatsManager?.queryUsageStats(
//            UsageStatsManager.INTERVAL_DAILY,
//            currentTime - TimeUnit.DAYS.toMillis(1),
//            currentTime
//        )
//        return stats != null
//    }
//
//    fun openUsageAccessSettings() {
//        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
//        context.startActivity(intent)
//    }
//
//    fun getTopUsedApps(interval: String = "daily"): List<Map<String, Any>> {
//        if (!hasUsageAccessPermission()) {
//            return emptyList()
//        }
//
//        val (intervalType, days) = when (interval.lowercase()) {
//            "weekly" -> Pair(UsageStatsManager.INTERVAL_WEEKLY, 7)
//            else -> Pair(UsageStatsManager.INTERVAL_DAILY, 1)
//        }
//
//        val calendar = Calendar.getInstance()
//        val endTime = calendar.timeInMillis
//        calendar.add(Calendar.DAY_OF_YEAR, -days)
//        val startTime = calendar.timeInMillis
//
//        val stats = usageStatsManager?.queryUsageStats(intervalType, startTime, endTime)
//            ?: return emptyList()
//
//        val packageManager = context.packageManager
//
//        return stats
//            .filter { it.totalTimeInForeground > 0 }
//            .sortedByDescending { it.totalTimeInForeground }
//            .take(10) // Top 10 apps
//            .map { usageStats ->
//                val appName = try {
//                    val applicationInfo = packageManager.getApplicationInfo(usageStats.packageName, 0)
//                    packageManager.getApplicationLabel(applicationInfo).toString()
//                } catch (e: PackageManager.NameNotFoundException) {
//                    usageStats.packageName
//                }
//
//                mapOf(
//                    "appName" to appName,
//                    "packageName" to usageStats.packageName,
//                    "usageTime" to usageStats.totalTimeInForeground,
//                    "lastUsed" to usageStats.lastTimeUsed,
////                    "launchCount" to usageStats.mLaunchCount
//                )
//            }
//    }
//
//    fun getAppUsageForPackage(packageName: String, days: Int = 1): Map<String, Any> {
//        if (!hasUsageAccessPermission()) {
//            return emptyMap()
//        }
//
//        val calendar = Calendar.getInstance()
//        val endTime = calendar.timeInMillis
//        calendar.add(Calendar.DAY_OF_YEAR, -days)
//        val startTime = calendar.timeInMillis
//
//        val stats = usageStatsManager?.queryUsageStats(
//            UsageStatsManager.INTERVAL_DAILY,
//            startTime,
//            endTime
//        ) ?: return emptyMap()
//
//        val packageStats = stats.find { it.packageName == packageName }
//
//        return if (packageStats != null) {
//            mapOf(
//                "packageName" to packageName,
//                "usageTime" to packageStats.totalTimeInForeground,
//                "lastUsed" to packageStats.lastTimeUsed,
////                "launchCount" to packageStats.mLaunchCount
//            )
//        } else {
//            emptyMap()
//        }
//    }
//}