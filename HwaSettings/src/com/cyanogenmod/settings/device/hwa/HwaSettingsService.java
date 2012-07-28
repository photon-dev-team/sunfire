package com.cyanogenmod.settings.device.hwa;

import java.io.File;
import java.io.IOException;

import android.app.ActivityManager;
import android.app.IntentService;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

public class HwaSettingsService extends IntentService implements
		Handler.Callback {

	private static final String TAG = "HwaSettingsService";
	private static final int HWA_ENABLED = 0;
	private static final int HWA_ENABLE_FAILED = 1;
	private static final int HWA_DISABLED = 2;
	private static final int HWA_DISABLE_FAILED = 3;

	private ContentResolver mContentResolver;
	private Context mContext;
	private ActivityManager mActivityManager;

	private Handler mHandler;

	public HwaSettingsService() {
		super("HwaSettingsService");
		mHandler = new Handler(this);
		Log.d(TAG, "HwaSettingsService stared");
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		Log.d(TAG, "New intent");
		mContentResolver = getContentResolver();
		mContext = this;
		mActivityManager = (ActivityManager) mContext
				.getSystemService(Context.ACTIVITY_SERVICE);
		Object[] objects = new Object[2];
		objects[0] = intent.getStringExtra(PackageListProvider.PACKAGE_NAME);
		objects[1] = intent.getBooleanExtra(PackageListProvider.HWA_ENABLED,
				true);
		new ChangeHwaSettings().execute(objects);
	}

	private class ChangeHwaSettings extends AsyncTask<Object[], Void, Void> {

		@Override
		protected Void doInBackground(Object[]... params) {
			String packageName = (String) params[0][0];
			Boolean hwaEnabled = (Boolean) params[0][1];
			Log.d(TAG, "Executing ChangeHwaSettings");
			Message msg = new Message();
			msg.obj = packageName;
			if (hwaEnabled) {
				boolean enabled = enableHwa(packageName);
				if (enabled) {
					msg.arg1 = HWA_ENABLED;
					mHandler.sendMessage(msg);
				} else {
					msg.arg1 = HWA_ENABLE_FAILED;
					mHandler.sendMessage(msg);
				}
			} else {
				boolean disabled = disableHwa(packageName);
				if (disabled) {
					msg.arg1 = HWA_DISABLED;
					mHandler.sendMessage(msg);
				} else {
					msg.arg1 = HWA_DISABLE_FAILED;
					mHandler.sendMessage(msg);
				}
			}
			mActivityManager.killBackgroundProcesses(packageName);
			return null;
		}

		private boolean enableHwa(String packageName) {
			boolean enabled = false;
			File file = new File("/data/local/hwui.deny/" + packageName);
			if (file.exists()) {
				enabled = file.delete();
			} else
				enabled = true;
			if (enabled) {
				ContentValues values = new ContentValues();
				values.put(PackageListProvider.HWA_ENABLED, "true");
				mContentResolver.update(Uri.withAppendedPath(
						PackageListProvider.PACKAGE_URI, packageName), values,
						null, null);
			} else {
				ContentValues values = new ContentValues();
				values.put(PackageListProvider.HWA_ENABLED, "false");
				mContentResolver.update(Uri.withAppendedPath(
						PackageListProvider.PACKAGE_URI, packageName), values,
						null, null);
			}
			return enabled;
		}

		private boolean disableHwa(String packageName) {
			boolean disabled = false;
			File file = new File("/data/local/hwui.deny/" + packageName);
			if (!file.exists()) {
				try {
					disabled = file.createNewFile();
				} catch (IOException e) {
					Log.w(TAG, "Creation of /data/local/hwui.deny/"
							+ packageName + " failed : IOException");
				}
			} else
				disabled = true;
			if (disabled) {
				ContentValues values = new ContentValues();
				values.put(PackageListProvider.HWA_ENABLED, "false");
				mContentResolver.update(Uri.withAppendedPath(
						PackageListProvider.PACKAGE_URI, packageName), values,
						null, null);
			} else {
				ContentValues values = new ContentValues();
				values.put(PackageListProvider.HWA_ENABLED, "true");
				mContentResolver.update(Uri.withAppendedPath(
						PackageListProvider.PACKAGE_URI, packageName), values,
						null, null);
			}
			return disabled;
		}
	}

	@Override
	public boolean handleMessage(Message msg) {
		switch (msg.arg1) {
		case HWA_ENABLED:
			Toast.makeText(
					mContext,
					mContext.getString(R.string.hwa_settings_hwa_enabled_toast,
							(String) msg.obj), Toast.LENGTH_SHORT).show();
			break;
		case HWA_ENABLE_FAILED:
			Toast.makeText(
					mContext,
					mContext.getString(
							R.string.hwa_settings_hwa_enable_failed_toast,
							(String) msg.obj), Toast.LENGTH_SHORT).show();
			break;
		case HWA_DISABLED:
			Toast.makeText(
					mContext,
					mContext.getString(
							R.string.hwa_settings_hwa_disabled_toast,
							(String) msg.obj), Toast.LENGTH_SHORT).show();
			break;
		case HWA_DISABLE_FAILED:
			Toast.makeText(
					mContext,
					mContext.getString(
							R.string.hwa_settings_hwa_disable_failed_toast,
							(String) msg.obj), Toast.LENGTH_SHORT).show();
			break;
		}
		return true;
	}
}
