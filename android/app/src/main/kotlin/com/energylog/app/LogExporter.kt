package com.energylog.app

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.io.FileWriter
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class LogExporter(private val context: Context) {

    fun exportToJSON(days: Int = 7): String {
        val logs = collectLogs(days)
        val jsonArray = JSONArray()

        logs.forEach { logFile ->
            val fileContent = logFile.readText()
            // Remove the trailing comma and newline, and close the array
            val cleanedContent = fileContent.trim().removeSuffix(",\n") + "\n]"
            try {
                val fileArray = JSONArray(cleanedContent)
                for (i in 0 until fileArray.length()) {
                    jsonArray.put(fileArray.getJSONObject(i))
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        val exportFileName = "energy_logs_export_${System.currentTimeMillis()}.json"
        val exportFile = File(context.getExternalFilesDir(null), exportFileName)

        FileWriter(exportFile).use { writer ->
            writer.write(jsonArray.toString(2))
        }

        return exportFile.absolutePath
    }

    fun exportToCSV(days: Int = 7): String {
        val logs = collectLogs(days)
        val csvContent = StringBuilder()

        // CSV Header
        csvContent.append("timestamp,battery_level,battery_voltage,battery_temperature,battery_status,cpu_usage,ram_used,ram_total,storage_used,storage_total\n")

        logs.forEach { logFile ->
            val fileContent = logFile.readText()
            val cleanedContent = fileContent.trim().removeSuffix(",\n") + "\n]"

            try {
                val jsonArray = JSONArray(cleanedContent)
                for (i in 0 until jsonArray.length()) {
                    val logEntry = jsonArray.getJSONObject(i)
                    val timestamp = logEntry.getLong("timestamp")
                    val battery = logEntry.getJSONObject("battery")
                    val performance = logEntry.getJSONObject("performance")
                    val cpu = performance.getJSONObject("cpu")
                    val ram = performance.getJSONObject("ram")
                    val storage = performance.getJSONObject("storage").getJSONObject("internal")

                    csvContent.append("$timestamp,${battery.getInt("level")},${battery.getDouble("voltage")},")
                    csvContent.append("${battery.getDouble("temperature")},${battery.getString("status")},")
                    csvContent.append("${cpu.getDouble("usagePercent")},${ram.getLong("usedMemory")},")
                    csvContent.append("${ram.getLong("totalMemory")},${storage.getLong("used")},")
                    csvContent.append("${storage.getLong("total")}\n")
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        val exportFileName = "energy_logs_export_${System.currentTimeMillis()}.csv"
        val exportFile = File(context.getExternalFilesDir(null), exportFileName)

        FileWriter(exportFile).use { writer ->
            writer.write(csvContent.toString())
        }

        return exportFile.absolutePath
    }

    fun getAvailableLogs(): List<Map<String, Any>> {
        return context.filesDir.listFiles()?.filter { it.name.startsWith("energy_log_") && it.name.endsWith(".json") }
            ?.map { file ->
                mapOf(
                    "fileName" to file.name,
                    "fileSize" to file.length(),
                    "lastModified" to file.lastModified(),
                    "entryCount" to countEntries(file)
                )
            } ?: emptyList()
    }

    private fun collectLogs(days: Int): List<File> {
        val calendar = java.util.Calendar.getInstance()
        calendar.add(java.util.Calendar.DAY_OF_YEAR, -days)
        val cutoffTime = calendar.timeInMillis

        return context.filesDir.listFiles()?.filter { file ->
            file.name.startsWith("energy_log_") &&
                    file.name.endsWith(".json") &&
                    file.lastModified() >= cutoffTime
        } ?: emptyList()
    }

    private fun countEntries(file: File): Int {
        return try {
            val content = file.readText()
            content.count { it == '}' } - 1 // Subtract 1 for the closing bracket
        } catch (e: Exception) {
            0
        }
    }
}