package com.cyanogenmod.settings.device.hwa;

import java.io.File;
import java.util.Arrays;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

public class DatabaseTools {

	protected static final String TAG = "DatabaseTools";

	public static void scanPackages(SQLiteDatabase database, Context context) {
		File denyFolder = new File("/data/local/hwui.deny");
		if (!denyFolder.exists()) {
			denyFolder.mkdirs();
		}
		File[] files = denyFolder.listFiles();
		String[] packageBlacklist = new String[files.length];
		for (int i = 0; i < files.length; i++) {
			packageBlacklist[i] = files[i].getName();
		}
		Cursor cursor = database.query(DatabaseHelper.PACKAGE_TABLE,
				new String[] { PackageListProvider.PACKAGE_NAME }, null, null,
				null, null, null);
		String[] databasePackages = new String[cursor.getCount()];
		if (cursor.moveToFirst()) {
			do
				databasePackages[cursor.getPosition()] = cursor
						.getString(cursor
								.getColumnIndex(PackageListProvider.PACKAGE_NAME));
			while (cursor.moveToNext());
		}
		cursor.close();
		PackageManager pm = context.getPackageManager();
		List<ApplicationInfo> list = pm
				.getInstalledApplications(PackageManager.GET_META_DATA);
		String[] installedPackages = new String[list.size()];
		for (int i = 0; i < list.size(); i++) {
			ApplicationInfo info = list.get(i);
			boolean hwaEnabled = true;
			String packageName = info.packageName;
			installedPackages[i] = info.packageName;
			if (Arrays.asList(packageBlacklist).contains(packageName))
				hwaEnabled = false;
			else
				hwaEnabled = true;
			boolean isSystem = false;
			if (info.sourceDir.startsWith("/system/app")) {
				isSystem = true;
			}
			ContentValues values = new ContentValues();
			values.put(PackageListProvider.APPLICATION_LABEL,
					(String) pm.getApplicationLabel(info));
			values.put(PackageListProvider.PACKAGE_NAME, packageName);
			values.put(PackageListProvider.HWA_ENABLED,
					String.valueOf(hwaEnabled));
			values.put(PackageListProvider.IS_SYSTEM, String.valueOf(isSystem));
			if (Arrays.asList(databasePackages).contains(packageName)) {
				database.update(DatabaseHelper.PACKAGE_TABLE, values,
						PackageListProvider.PACKAGE_NAME + " IS ?",
						new String[] { packageName });
			} else
				database.insert(DatabaseHelper.PACKAGE_TABLE, null, values);
		}
		for (int i = 0; i < databasePackages.length; i++) {
			if (Arrays.asList(installedPackages).contains(databasePackages[i])) {
				database.delete(DatabaseHelper.PACKAGE_TABLE,
						PackageListProvider.PACKAGE_NAME + " IS ?",
						new String[] { databasePackages[i] });
			}
		}
	}
}
