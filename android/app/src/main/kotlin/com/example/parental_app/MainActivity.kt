package com.example.parental_app

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "parental_control/vpn"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when(call.method) {
                    "startVpn" -> {
                        val intent = Intent(this, ParentalVpnService::class.java)
                        startService(intent)
                        result.success(true)
                    }
                    "stopVpn" -> {
                        val intent = Intent(this, ParentalVpnService::class.java)
                        stopService(intent)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
