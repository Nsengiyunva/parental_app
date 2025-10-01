package com.example.parental_app

import android.app.PendingIntent
import android.content.Intent
import android.net.VpnService
import android.os.ParcelFileDescriptor
import android.util.Log

class ParentalVpnService : VpnService() {

    private var vpnInterface: ParcelFileDescriptor? = null
    private val TAG = "ParentalVpnService"

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startVpn()
        return START_STICKY
    }

    private fun startVpn() {
        val builder = Builder()
        builder.addAddress("10.0.0.2", 32)
        builder.addRoute("0.0.0.0", 0)
        builder.setSession("ParentalControlVPN")
        val pendingIntent = PendingIntent.getActivity(
            this, 0, Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        builder.setConfigureIntent(pendingIntent)
        vpnInterface = builder.establish()
        Log.d(TAG, "VPN started")
    }

    override fun onDestroy() {
        super.onDestroy()
        vpnInterface?.close()
        vpnInterface = null
        Log.d(TAG, "VPN stopped")
    }
}
