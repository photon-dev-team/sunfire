package com.cyanogenmod.settings.device;

import android.content.Intent;
import android.os.Bundle;
import android.os.SystemProperties;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.PreferenceScreen;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.util.Log;

public class DeviceSettings extends PreferenceActivity implements OnPreferenceChangeListener {

    private static final String SWITCH_STORAGE_PREF = "pref_switch_storage";

    private CheckBoxPreference hdmiAudioPref;
    private CheckBoxPreference mSwitchStoragePref;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.main_preferences);

        hdmiAudioPref = (CheckBoxPreference) getPreferenceScreen().findPreference("hdmi_audio");
        hdmiAudioPref.setOnPreferenceChangeListener(this);

	mSwitchStoragePref = (CheckBoxPreference) findPreference(SWITCH_STORAGE_PREF);
        mSwitchStoragePref.setChecked((SystemProperties.getInt("persist.sys.vold.switchexternal", 0) == 1));

        if (SystemProperties.get("ro.vold.switchablepair","").equals("")) {
            mSwitchStoragePref.setSummaryOff(R.string.pref_storage_switch_unavailable);
            mSwitchStoragePref.setEnabled(false);
        }
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

    @Override
    public boolean onPreferenceTreeClick(PreferenceScreen preferenceScreen, Preference preference) {
	if (preference == mSwitchStoragePref) {
            SystemProperties.set("persist.sys.vold.switchexternal",
                    mSwitchStoragePref.isChecked() ? "1" : "0");
            return true;
        }

        return false;
    }
}
