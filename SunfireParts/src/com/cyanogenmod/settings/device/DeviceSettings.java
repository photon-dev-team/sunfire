package com.cyanogenmod.settings.device;

import android.content.Intent;
import android.os.Bundle;
import android.preference.CheckBoxPreference;
import android.preference.Preference;
import android.preference.Preference.OnPreferenceChangeListener;
import android.preference.PreferenceActivity;
import android.util.Log;
import android.os.SystemProperties;

public class DeviceSettings extends PreferenceActivity implements OnPreferenceChangeListener {

    private CheckBoxPreference mHdmiAudioPref=null;
    private CheckBoxPreference mSwitchStoragePref=null;

    private static final String TAG = "SunfireParts";
    private static final String KEY_SWITCH_STORAGE = "key_switch_storage";
    private static final String KEY_HDMI_AUDIO = "hdmi_audio";
    private static final String ACTION_AUDIO_DIGITAL="com.cyanogenmod.dockaudio.ENABLE_DIGITAL_AUDIO";
    private static final String ACTION_AUDIO_SPEAKER="com.cyanogenmod.dockaudio.ENABLE_SPEAKER_AUDIO";

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        addPreferencesFromResource(R.xml.main_preferences);

        mHdmiAudioPref = (CheckBoxPreference) getPreferenceScreen().findPreference(KEY_HDMI_AUDIO);
        mHdmiAudioPref.setOnPreferenceChangeListener(this);
        mSwitchStoragePref = (CheckBoxPreference) getPreferenceScreen().findPreference(KEY_SWITCH_STORAGE);
        mSwitchStoragePref.setChecked((SystemProperties.getInt("persist.sys.vold.switchexternal", 0) == 1));
        mSwitchStoragePref.setOnPreferenceChangeListener(this);
        if (SystemProperties.get("ro.vold.switchablepair","").equals("")) {
            mSwitchStoragePref.setSummary(R.string.storage_switch_unavailable);
            mSwitchStoragePref.setEnabled(false);
        }
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == mHdmiAudioPref) {
            /* switch the audio state accordingly */
            String audioAction=((Boolean) newValue)?ACTION_AUDIO_DIGITAL:ACTION_AUDIO_SPEAKER;
            Log.d(TAG,"Sending intent with action "+audioAction);
            Intent audio = new Intent();
            audio.setAction(audioAction);
            sendBroadcast(audio);
        }
        if(preference == mSwitchStoragePref) {
            Log.d(TAG,"Setting persist.sys.vold.switchexternal to "+(mSwitchStoragePref.isChecked() ? "1" : "0"));
            SystemProperties.set("persist.sys.vold.switchexternal", ((Boolean) newValue) ? "1" : "0");
        }
        return true;
    }
}
