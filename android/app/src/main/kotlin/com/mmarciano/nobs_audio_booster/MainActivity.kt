package com.mmarciano.nobs_audio_booster

import android.media.audiofx.Equalizer
import android.media.audiofx.LoudnessEnhancer
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.mmarciano.nobs_audio_booster/dsp"
    private var loudnessEnhancer: LoudnessEnhancer? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "setBoostLevel" -> {
                        val boost = call.argument<Int>("level") ?: 1000
                        setBoostLevel(boost)
                        result.success("Boost impostato a $boost")
                    }
                    "resetBoost" -> {
                        resetBoost()
                        result.success("Boost disattivato")
                    }
                    else -> result.notImplemented()
                }
            }
    }

    private fun setBoostLevel(level: Int) {
        if (loudnessEnhancer == null) {
            loudnessEnhancer = LoudnessEnhancer(0)
        }
        loudnessEnhancer?.setTargetGain(level)
        loudnessEnhancer?.enabled = true
    }

    private fun resetBoost() {
        loudnessEnhancer?.release()
        loudnessEnhancer = null
    }
}

