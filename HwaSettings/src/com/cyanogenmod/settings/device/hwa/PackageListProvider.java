package com.cyanogenmod.settings.device.hwa;

import android.content.ContentProvider;
import android.content.ContentResolver;
import android.content.ContentValues;
import android.content.Context;
import android.content.UriMatcher;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteQueryBuilder;
import android.net.Uri;
import android.util.Log;

public class PackageListProvider extends ContentProvider {

	public static final String _ID = "_id";
	public static final String PACKAGE_NAME = "package_name";
	public static final String APPLICATION_LABEL = "application_label";
	public static final String HWA_ENABLED = "hwa_enabled";
	public static final String IS_SYSTEM = "system_app";

	public static final String AUTHORITY = "com.cyanogenmod.settings.device.hwa.PackageListProvider";
	public static final String BASE_PATH = "dir";

	public static final Uri CONTENT_URI = Uri.parse("content://" + AUTHORITY
			+ "/" + BASE_PATH);
	public static final Uri CONTENT_FILTER_URI = Uri.parse("content://"
			+ AUTHORITY + "/" + BASE_PATH + "/filter");
	public static final Uri PACKAGE_URI = Uri.parse("content://" + AUTHORITY
			+ "/" + BASE_PATH + "/package");
	public static final Uri SCAN_URI = Uri.parse("content://" + AUTHORITY + "/"
			+ BASE_PATH + "/scan");

	protected static final String TAG = "PackageListProvider";

	private Context mContext;
	private DatabaseHelper mDatabaseHelper;
	private SQLiteDatabase mDatabase;
	private ContentResolver mContentResolver;

	private static final UriMatcher sURIMatcher = new UriMatcher(
			UriMatcher.NO_MATCH);
	private static final int PACKAGES = 0;
	private static final int PACKAGE = 1;
	private static final int PACKAGE_SCAN = 2;
	private static final int PACKAGE_FILTER = 3;

	static {
		sURIMatcher.addURI(AUTHORITY, BASE_PATH, PACKAGES);
		sURIMatcher.addURI(AUTHORITY, BASE_PATH + "/package/*", PACKAGE);
		sURIMatcher.addURI(AUTHORITY, BASE_PATH + "/scan", PACKAGE_SCAN);
		sURIMatcher.addURI(AUTHORITY, BASE_PATH + "/filter/*", PACKAGE_FILTER);
	}

	@Override
	public int delete(Uri uri, String selection, String[] selectionArgs) {
		switch (sURIMatcher.match(uri)) {
		case PACKAGE:
			String packageName = uri.getLastPathSegment();
			int rows = mDatabase.delete(DatabaseHelper.PACKAGE_TABLE,
					PACKAGE_NAME + " IS ? ", new String[] { packageName });
			mContentResolver.notifyChange(uri, null);
			return rows;
		}
		return 0;
	}

	@Override
	public String getType(Uri uri) {
		return null;
	}

	@Override
	public Uri insert(Uri uri, ContentValues values) {
		switch (sURIMatcher.match(uri)) {
		case PACKAGE_SCAN:
			DatabaseTools.scanPackages(mDatabase, mContext);
			mContentResolver.notifyChange(uri, null);
			break;
		case PACKAGE:
			mDatabase.insert(DatabaseHelper.PACKAGE_TABLE, null, values);
			mContentResolver.notifyChange(uri, null);
			break;
		}
		return uri;
	}

	@Override
	public boolean onCreate() {
		mContext = getContext();
		mContentResolver = mContext.getContentResolver();
		mDatabaseHelper = new DatabaseHelper(mContext);
		mDatabase = mDatabaseHelper.getWritableDatabase();
		return true;
	}

	@Override
	public Cursor query(Uri uri, String[] projection, String selection,
			String[] selectionArgs, String sortOrder) {
		SQLiteQueryBuilder queryBuilder = new SQLiteQueryBuilder();
		queryBuilder.setTables(DatabaseHelper.PACKAGE_TABLE);
		switch (sURIMatcher.match(uri)) {
		case PACKAGES:
			break;
		case PACKAGE_FILTER:
			String query = uri.getLastPathSegment();
			queryBuilder.appendWhere(APPLICATION_LABEL + " LIKE '" + query
					+ "%'");
		}
		Cursor cursor = queryBuilder.query(mDatabase, projection, selection,
				selectionArgs, null, null, sortOrder);
		cursor.setNotificationUri(mContentResolver, uri);
		return cursor;
	}

	@Override
	public int update(Uri uri, ContentValues values, String selection,
			String[] selectionArgs) {
		switch (sURIMatcher.match(uri)) {
		case PACKAGE:
			String packageName = uri.getLastPathSegment();
			int rows = mDatabase.update(DatabaseHelper.PACKAGE_TABLE, values,
					PACKAGE_NAME + " IS ? ", new String[] { packageName });
			Log.d(TAG, "Db update completed");
			mContentResolver.notifyChange(uri, null);
			return rows;
		}
		return 0;
	}
}
