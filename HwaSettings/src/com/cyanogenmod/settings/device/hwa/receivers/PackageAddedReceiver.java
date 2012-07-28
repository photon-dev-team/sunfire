package com.cyanogenmod.settings.device.hwa.receivers;

import java.io.File;
import java.util.Arrays;

import android.content.BroadcastReceiver;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.database.Cursor;
import android.net.Uri;
import android.os.AsyncTask;
import android.util.Log;

import com.cyanogenmod.settings.device.hwa.PackageListProvider;

public class PackageAddedReceiver extends BroadcastReceiver {

	protected static final String TAG = "PackageAddedReceiver";
	private ContentResolver mContentResolver;
	private String mPackageName;
	private PackageManager mPackageManager;

	@Override
	public void onReceive(Context context, Intent intent) {
		mContentResolver = context.getContentResolver();
		mPackageName = intent.getDataString().split(":")[1];
		mPackageManager = context.getPackageManager();
		new AddPackage().execute();
	}

	private class AddPackage extends AsyncTask<Void, Void, Void> {

		@Override
		protected Void doInBackground(Void... params) {
			ContentValues values = new ContentValues();
			File denyFolder = new File("/data/local/hwui.deny");
			if (!denyFolder.exists()) {
				denyFolder.mkdirs();
			}
			File[] files = denyFolder.listFiles();
			String[] packageBlacklist = new String[files.length];
			for (int i = 0; i < files.length; i++) {
				packageBlacklist[i] = files[i].getName();
			}
			boolean hwaEnabled = true;
			if (Arrays.asList(packageBlacklist).contains(mPackageName))
				hwaEnabled = false;
			ApplicationInfo info = null;
			try {
				info = mPackageManager.getApplicationInfo(mPackageName,
						PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
				Log.w(TAG, "Package " + mPackageName + " not found!!");
				return null;
			}
			boolean isSystem = false;
			if (info.sourceDir.startsWith("/system/app")) {
				isSystem = true;
			}
			values.put(PackageListProvider.APPLICATION_LABEL,
					(String) mPackageManager.getApplicationLabel(info));
			values.put(PackageListProvider.PACKAGE_NAME, mPackageName);
			values.put(PackageListProvider.HWA_ENABLED,
					String.valueOf(hwaEnabled));
			values.put(PackageListProvider.IS_SYSTEM, String.valueOf(isSystem));
			Cursor cursor = mContentResolver.query(Uri.withAppendedPath(
					PackageListProvider.PACKAGE_URI, mPackageName), null, null,
					null, null);
			if (cursor.getCount() <= 0) {
				// if package not already inserted
				mContentResolver.insert(Uri.withAppendedPath(
						PackageListProvider.PACKAGE_URI, mPackageName), values);
			}
			return null;
		}
	}
}
