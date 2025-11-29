package com.energylog.app

import android.app.ActivityManager
import android.content.Context

class SystemInfo(private val context: Context) {

    fun getRamInfo(): Map<String, Long> {
        val activityManager = context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        val memoryInfo = ActivityManager.MemoryInfo()
        activityManager.getMemoryInfo(memoryInfo)

        return mapOf(
            "total" to memoryInfo.totalMem,
            "free" to memoryInfo.availMem,
            "used" to (memoryInfo.totalMem - memoryInfo.availMem),
            "threshold" to memoryInfo.threshold
        )
    }
}
