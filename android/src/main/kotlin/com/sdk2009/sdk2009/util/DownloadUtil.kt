package com.sdk2009.sdk2009.util

import android.app.Activity
import android.app.DownloadManager
import android.content.BroadcastReceiver
import io.flutter.plugin.common.MethodChannel
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Environment
import android.util.Log
import android.widget.Toast
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DownloadUtil {
    companion object {
        val TAG = DownloadUtil::class.qualifiedName;
        private var downloadID: Long = 0
        private lateinit var activity: Activity

        var mediaFolder = "ScmMedia"

        var videosType = ".mp4"
        var videosMineType = "video/mp4"

        var imagesType = ".png"
        var imagesMineType = "image/png"
        var imagesPathQ = "Pictures/$mediaFolder"

        var appName = "SECOM Sights"

        @Suppress("DEPRECATION")
        var imagesPath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
            .toString() + "/$mediaFolder"

        fun time2Name(): String {
            return SimpleDateFormat("yyyy_MM_dd_HH_mm_ss", Locale.JAPAN).format(Date()).toString()
        }

        fun imageSnapshotName(cameraName: String): String {
            return "$appName-$cameraName-${
                SimpleDateFormat("yyyy-MM-dd_HH-mm-ss", Locale.JAPAN).format(
                    Date()
                )
            }"
        }
        fun beginDownload(
            activity: Activity,
            url: String,
            fileName: String,
            result: MethodChannel.Result
        ) {
            this.activity = activity

            val request = DownloadManager.Request(Uri.parse(url))
            request.setTitle(fileName)
            request.setDescription("Downloading...")
            request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName)
            request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED)

            val downloadManager =
                activity?.getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
            // enqueue puts the download request in the queue.
            val downloadId = downloadManager.enqueue(request)
            downloadStatus(downloadManager)

            result.success(downloadId)
        }

        fun downloadStatus(downloadManager: DownloadManager) {

            // using query method
            var finishDownload = false
            var progress: Int
            while (!finishDownload) {
                val cursor =
                    downloadManager.query(DownloadManager.Query().setFilterById(downloadID))
                if (cursor.moveToFirst()) {
                    val status = cursor.getInt(cursor.getColumnIndex(DownloadManager.COLUMN_STATUS))
                    when (status) {
                        DownloadManager.STATUS_FAILED -> {
                            finishDownload = true
                        }

                        DownloadManager.STATUS_PAUSED -> {
                        }

                        DownloadManager.STATUS_PENDING -> {
                        }

                        DownloadManager.STATUS_RUNNING -> {
                            val total =
                                cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_TOTAL_SIZE_BYTES))
                            if (total >= 0) {
                                val downloaded =
                                    cursor.getLong(cursor.getColumnIndex(DownloadManager.COLUMN_BYTES_DOWNLOADED_SO_FAR))
                                progress = (downloaded * 100L / total).toInt()
                                // if you use downloadmanger in async task, here you can use like this to display progress.
                                // Don't forget to do the division in long to get more digits rather than double.
                                //  publishProgress((int) ((downloaded * 100L) / total));
                                Log.d(
                                    TAG,
                                    "beginDownload: downloadID$downloadID progress $progress"
                                )
                            }
                        }

                        DownloadManager.STATUS_SUCCESSFUL -> {
                            progress = 100
                            Log.d(TAG, "beginDownload: downloadID$downloadID progress $progress")
                            // if you use aysnc task
                            // publishProgress(100);
                            finishDownload = true
                            Toast.makeText(this.activity, "Download Completed", Toast.LENGTH_SHORT)
                                .show()
                        }
                    }
                }
            }

        }

        // using broadcast method
        private val onDownloadComplete: BroadcastReceiver = object : BroadcastReceiver() {
            override fun onReceive(context: Context?, intent: Intent) {
                //Fetching the download id received with the broadcast
                val id = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, -1)
                //Checking if the received broadcast is for our enqueued download by matching download id
                if (downloadID == id) {
//                    Toast.makeText(this.activity, "Download Completed", Toast.LENGTH_SHORT).show()
                }
            }
        }

        fun registerReceiver() {}
        fun unregisterReceiver(onDownloadComplete: BroadcastReceiver) {
            unregisterReceiver(this.onDownloadComplete)
        }
    }
}