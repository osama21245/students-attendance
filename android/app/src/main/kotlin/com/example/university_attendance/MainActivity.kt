package com.example.university_attendance

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.hardware.display.DisplayManager
import android.hardware.display.VirtualDisplay
import android.media.MediaRecorder
import android.media.projection.MediaProjection
import android.media.projection.MediaProjectionManager
import android.os.Bundle
import android.os.Environment
import android.util.DisplayMetrics
import android.view.WindowManager
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val SCREEN_RECORD_REQUEST_CODE = 1000
    private val REQUEST_PERMISSIONS = 1
    private val CHANNEL = "com.example/screen_record"

    private var mediaProjectionManager: MediaProjectionManager? = null
    private var mediaProjection: MediaProjection? = null
    private var virtualDisplay: VirtualDisplay? = null
    private var mediaRecorder: MediaRecorder? = null
    private var pendingResult: MethodChannel.Result? = null

    // Define the storage path
    private val videoFilePath: String
        get() {
            val videoDir = File(getExternalFilesDir(null), "ScreenRecordings")
            if (!videoDir.exists()) {
                videoDir.mkdirs()
            }
            return "${videoDir.absolutePath}/screen_recording_${System.currentTimeMillis()}.mp4"
        }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "startRecording" -> startScreenRecording(result)
                "stopRecording" -> stopScreenRecording(result)
                else -> result.notImplemented()
            }
        }
    }

    private fun startScreenRecording(result: MethodChannel.Result) {
        checkAndRequestPermissions()
        mediaProjectionManager = getSystemService(MEDIA_PROJECTION_SERVICE) as MediaProjectionManager
        val permissionIntent = mediaProjectionManager!!.createScreenCaptureIntent()
        pendingResult = result
        startActivityForResult(permissionIntent, SCREEN_RECORD_REQUEST_CODE)
    }

    private fun stopScreenRecording(result: MethodChannel.Result) {
        mediaRecorder?.let {
            try {
                it.stop()
                it.reset()
                mediaRecorder = null
                virtualDisplay?.release()
                mediaProjection?.stop()
                result.success("Recording stopped and saved to: ${videoFilePath}")
            } catch (e: Exception) {
                result.error("ERROR", "Failed to stop recording: ${e.message}", null)
            }
        } ?: run {
            result.error("UNAVAILABLE", "Recording not started", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (requestCode == SCREEN_RECORD_REQUEST_CODE) {
            if (resultCode == Activity.RESULT_OK) {
                mediaProjection = mediaProjectionManager!!.getMediaProjection(resultCode, data!!)
                startRecording()
                pendingResult?.success("Recording started")
                pendingResult = null
            } else {
                pendingResult?.error("PERMISSION_DENIED", "Screen recording permission denied", null)
                pendingResult = null
            }
        }
        super.onActivityResult(requestCode, resultCode, data)
    }

    private fun startRecording() {
        mediaRecorder = MediaRecorder().apply {
            setAudioSource(MediaRecorder.AudioSource.MIC)
            setVideoSource(MediaRecorder.VideoSource.SURFACE)
            setOutputFormat(MediaRecorder.OutputFormat.MPEG_4)
            setOutputFile(videoFilePath) // Use the defined video file path
            setVideoSize(1280, 720) // Specify video size
            setVideoEncoder(MediaRecorder.VideoEncoder.H264)
            setAudioEncoder(MediaRecorder.AudioEncoder.AAC)
            setVideoEncodingBitRate(512 * 1000)
            setVideoFrameRate(30)

            try {
                prepare()
            } catch (e: IOException) {
                e.printStackTrace()
            } catch (e: IllegalStateException) {
                e.printStackTrace()
            }
        }

        createVirtualDisplay()
        mediaRecorder?.start()
    }

    private fun createVirtualDisplay() {
        val metrics = DisplayMetrics()
        (getSystemService(WINDOW_SERVICE) as WindowManager).defaultDisplay.getMetrics(metrics)

        virtualDisplay = mediaProjection?.createVirtualDisplay(
            "MainActivity",
            1280, 720, metrics.densityDpi,
            DisplayManager.VIRTUAL_DISPLAY_FLAG_AUTO_MIRROR,
            mediaRecorder?.surface, null, null
        )
    }

    private fun checkAndRequestPermissions() {
        val permissions = arrayOf(
            Manifest.permission.RECORD_AUDIO,
            Manifest.permission.WRITE_EXTERNAL_STORAGE
        )

        val permissionsToRequest = permissions.filter {
            ContextCompat.checkSelfPermission(this, it) != PackageManager.PERMISSION_GRANTED
        }

        if (permissionsToRequest.isNotEmpty()) {
            ActivityCompat.requestPermissions(this, permissionsToRequest.toTypedArray(), REQUEST_PERMISSIONS)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_PERMISSIONS) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permissions granted, proceed with recording
            } else {
                // Permissions denied, show message to the user
            }
        }
    }
}
