package com.cyanogenmod.settings.device;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;

public class OlympusReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        /* This receiver is triggered by four intents:
         * BOOT_COMPLETED: HDMI audio is disabled
         * ENABLE_DIGITAL_AUDIO: HDMI audio is enabled
         * ENABLE_SPEAKER_AUDIO: HDMI audio is disabled
         * ENABLE_ANALOG_AUDIO: HDMI audio is disabled
         */
        boolean status = intent.getAction().equals("com.cyanogenmod.dockaudio.ENABLE_DIGITAL_AUDIO");

        SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(context);
        SharedPreferences.Editor editor = sharedPrefs.edit();
        editor.putBoolean("hdmi_audio", status);
        editor.commit();
    }
}
