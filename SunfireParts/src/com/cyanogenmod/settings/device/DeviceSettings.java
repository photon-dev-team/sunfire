package com.cyanogenmod.settings.device;

import android.content.Intent;
import android.os.Bundle;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.util.Log;

public class DeviceSettings extends PreferenceActivity implements OnPreferenceChangeListener {

    private CheckBoxPreference hdmiAudioPref;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.main_preferences);

        hdmiAudioPref = (CheckBoxPreference) getPreferenceScreen().findPreference("hdmi_audio");
        hdmiAudioPref.setOnPreferenceChangeListener(this);
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == hdmiAudioPref) {
            /* switch the audio state accordingly */
            Intent audio = new Intent();
            if ((Boolean) newValue) {
                audio.setAction("com.cyanogenmod.dockaudio.ENABLE_DIGITAL_AUDIO");
            } else {
                audio.setAction("com.cyanogenmod.dockaudio.ENABLE_SPEAKER_AUDIO");
            }
            sendBroadcast(audio);
        }

        return true;
    }
}
