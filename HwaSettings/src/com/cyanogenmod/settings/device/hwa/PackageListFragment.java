package com.cyanogenmod.settings.device.hwa;

import android.app.ListFragment;
import android.app.LoaderManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.CursorLoader;
import android.content.Intent;
import android.content.Loader;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.database.ContentObserver;
import android.database.Cursor;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.SearchView;
import android.widget.SimpleCursorAdapter;
import android.widget.TextView;

public class PackageListFragment extends ListFragment implements
		LoaderManager.LoaderCallbacks<Cursor>, SearchView.OnQueryTextListener,
		OnItemClickListener, ListView.OnScrollListener {

	protected static final String TAG = "PackageListFragment";
	private static final int PACKAGE_LIST_LOADER = 0;
	private PackageListAdapater adapter;
	private SearchView mSearchView;
	protected Context mContext;
	private String mCurFilter = "";
	private ListView mListView;
	private ContentResolver mContentResolver;
	private LoaderManager mLoaderManager;
	private boolean mBusy;

	private LayoutInflater mInflater;
	private Cursor mCursor;
	private PackageManager mPackageManager;
	public static PackageObserver mPackageObserver;

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		mContext = getActivity();
		mListView = (ListView) getListView();
		mContentResolver = mContext.getContentResolver();
		mPackageObserver = new PackageObserver(new Handler());
		mContentResolver.registerContentObserver(
				PackageListProvider.CONTENT_URI, true, mPackageObserver);
		mLoaderManager = getLoaderManager();
		mSearchView = (SearchView) getActivity().findViewById(
				R.id.hwa_package_list_search_view);
		String[] from = new String[] { PackageListProvider.APPLICATION_LABEL,
				PackageListProvider.PACKAGE_NAME,
				PackageListProvider.HWA_ENABLED, PackageListProvider._ID };
		int[] to = new int[] { R.id.hwa_settings_name,
				R.id.hwa_settings_packagename, R.id.hwa_settings_enabled };
		adapter = new PackageListAdapater(getActivity(),
				R.layout.hwa_settings_row, null, from, to, 0);
		setListAdapter(adapter);
		setListShown(false);
		mListView.setTextFilterEnabled(true);
		mListView.setOnItemClickListener(this);
		mListView.setOnScrollListener(this);
		mSearchView.setOnQueryTextListener(this);
		mSearchView.setSubmitButtonEnabled(false);
		startLoading();
	}

	private void startLoading() {
		getListView().invalidateViews();
		mLoaderManager.initLoader(PACKAGE_LIST_LOADER, null, this);
	}

	private void restartLoading() {
		mLoaderManager.restartLoader(PACKAGE_LIST_LOADER, null, this);
	}

	@Override
	public Loader<Cursor> onCreateLoader(int id, Bundle args) {
		Uri baseUri;
		if (mCurFilter != null) {
			baseUri = Uri.withAppendedPath(
					PackageListProvider.CONTENT_FILTER_URI,
					Uri.encode(mCurFilter));
		} else {
			baseUri = PackageListProvider.CONTENT_URI;
		}
		CursorLoader cursorLoader = new CursorLoader(mContext, baseUri, null,
				null, null, PackageListProvider.HWA_ENABLED + ", "
						+ PackageListProvider.IS_SYSTEM + ", "
						+ PackageListProvider.APPLICATION_LABEL);
		return cursorLoader;
	}

	@Override
	public void onLoadFinished(Loader<Cursor> cursorLoader, Cursor cursor) {
		adapter.swapCursor(cursor);
		adapter.notifyDataSetChanged();
		setListShown(true);
	}

	@Override
	public void onLoaderReset(Loader<Cursor> arg0) {
		adapter.swapCursor(null);
	}

	@Override
	public boolean onQueryTextChange(String newText) {
		String newFilter = !TextUtils.isEmpty(newText) ? newText : null;
		if (mCurFilter == null && newFilter == null) {
			return true;
		}
		if (mCurFilter != null && mCurFilter.equals(newFilter)) {
			return true;
		}
		mCurFilter = newFilter;
		if (newText.length() > 0)
			mListView.setFilterText(newText);
		else
			mListView.clearTextFilter();
		restartLoading();
		return true;
	}

	@Override
	public boolean onQueryTextSubmit(String query) {
		return false;
	}

	@Override
	public void onScrollStateChanged(AbsListView view, int scrollState) {
		switch (scrollState) {
		case OnScrollListener.SCROLL_STATE_IDLE:
			mBusy = false;

			int count = view.getChildCount();
			for (int i = 0; i < count; i++) {
				View v = view.getChildAt(i);
				ImageView icon = (ImageView) v
						.findViewById(R.id.hwa_settings_app_icon);
				if (icon.getTag() != null) {
					String packageName = (String) ((TextView) v
							.findViewById(R.id.hwa_settings_packagename))
							.getText();
					try {
						icon.setImageDrawable(mPackageManager
								.getApplicationIcon(packageName));
					} catch (NameNotFoundException e) {
						icon.setTag(null);
						e.printStackTrace();
					}
					icon.setTag(null);
				}
			}

			break;
		case OnScrollListener.SCROLL_STATE_TOUCH_SCROLL:
			mBusy = true;
			break;
		case OnScrollListener.SCROLL_STATE_FLING:
			mBusy = true;
			break;
		}
	}

	@Override
	public void onScroll(AbsListView view, int firstVisibleItem,
			int visibleItemCount, int totalItemCount) {
	}

	@Override
	public void onItemClick(AdapterView<?> parent, View view, int position,
			long id) {
		CheckBox hwaCheck = (CheckBox) view
				.findViewById(R.id.hwa_settings_enabled);
		boolean enableHwa = !hwaCheck.isChecked();
		String packageName = (String) ((TextView) view
				.findViewById(R.id.hwa_settings_packagename)).getText();
		Intent service = new Intent(mContext, HwaSettingsService.class);
		service.putExtra(PackageListProvider.PACKAGE_NAME, packageName);
		service.putExtra(PackageListProvider.HWA_ENABLED, enableHwa);
		mContext.startService(service);
	}

	public class PackageListAdapater extends SimpleCursorAdapter {

		private static final String TAG = "PackageListAdapater";
		private Drawable defaultIcon = PackageListFragment.this.getResources()
				.getDrawable(R.drawable.ic_default);

		public PackageListAdapater(Context context, int layout, Cursor c,
				String[] from, int[] to, int flags) {
			super(context, layout, c, from, to, flags);
			mInflater = LayoutInflater.from(context);
			mPackageManager = context.getPackageManager();
		}

		public View getView(int position, View convertView, ViewGroup parent) {
			mCursor = getCursor();
			ViewHolder holder;
			mCursor.moveToPosition(position);
			if (convertView == null) {
				convertView = mInflater
						.inflate(R.layout.hwa_settings_row, null);
				holder = new ViewHolder();
				holder.label = (TextView) convertView
						.findViewById(R.id.hwa_settings_name);
				holder.packageName = (TextView) convertView
						.findViewById(R.id.hwa_settings_packagename);
				holder.enabled = (CheckBox) convertView
						.findViewById(R.id.hwa_settings_enabled);
				holder.icon = (ImageView) convertView
						.findViewById(R.id.hwa_settings_app_icon);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			String packageName = mCursor.getString(mCursor
					.getColumnIndex(PackageListProvider.PACKAGE_NAME));
			holder.label.setText(mCursor.getString(mCursor
					.getColumnIndex(PackageListProvider.APPLICATION_LABEL)));
			holder.packageName.setText(packageName);
			if (!mBusy) {
				try {
					holder.icon.setImageDrawable(mPackageManager
							.getApplicationIcon(packageName));
				} catch (NameNotFoundException e) {
					holder.icon.setImageResource(R.drawable.ic_default);
					Log.w(TAG, "Icon " + packageName + " for not found!");
				}
				holder.icon.setTag(null);
			} else {
				holder.icon.setImageDrawable(defaultIcon);
				holder.icon.setTag(this);
			}
			holder.enabled.setChecked(Boolean.parseBoolean(mCursor
					.getString(mCursor
							.getColumnIndex(PackageListProvider.HWA_ENABLED))));
			return convertView;
		}
	}

	static class ViewHolder {
		ImageView icon;
		TextView label;
		TextView packageName;
		CheckBox enabled;
	}

	public class PackageObserver extends ContentObserver {

		public PackageObserver(Handler handler) {
			super(handler);
		}

		@Override
		public boolean deliverSelfNotifications() {
			return false;
		}

		@Override
		public void onChange(boolean selfChange) {
			super.onChange(selfChange);
			Log.d(TAG, "database changed");
			restartLoading();
		}
	}
}