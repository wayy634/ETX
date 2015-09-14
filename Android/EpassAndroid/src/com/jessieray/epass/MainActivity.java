package com.jessieray.epass;


import com.jessieray.epass.config.AppConfig;
import com.jessieray.epass.core.LaunchScreen;
import com.jessieray.epass.db.DataSaveManager;
import com.jessieray.epass.net.HttpRequest;
import com.jessieray.epass.util.Tools;
import com.mome.api.request.base.RequestProxy;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;
import android.text.TextUtils;
import android.view.KeyEvent;

public class MainActivity extends FragmentActivity {
	
	/**
	 * 退出应用时间
	 */
	private long lExitTime = 0l;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_main);
		init();
		if(savedInstanceState == null) {
			Tools.pushScreen(LaunchScreen.class, null);
		}
	}

	/**
	 * 初始化资源
	 */
	private void init() {
		AppConfig.context = this.getApplicationContext();
        AppConfig.SCREEN_WIDTH = this.getWindowManager().getDefaultDisplay().getWidth();
        AppConfig.SCREEN_HEIGHT = this.getWindowManager().getDefaultDisplay().getHeight();
        AppConfig.INFLATER = this.getLayoutInflater();
		AppConfig.mainActivity = this;
		DataSaveManager.getInstance().setContext(this.getApplicationContext());
		String version = DataSaveManager.getInstance().read(AppConfig.SAVE_KEY_VERSION);
		if(TextUtils.isEmpty(version) || !AppConfig.CLIENT_VERSION_VALUE.equals(version)) {
			AppConfig.isFirstInstall = true;
			DataSaveManager.getInstance().save(AppConfig.SAVE_KEY_VERSION, AppConfig.CLIENT_VERSION_VALUE);
		} else {
			AppConfig.isFirstInstall = false;
		}
		AppConfig.isFirstBoot = true;
		AppConfig.fragmentManager = this.getSupportFragmentManager();
		RequestProxy.setRequest(HttpRequest.getInstance());
	}
	
	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			if(AppConfig.fragmentManager.getBackStackEntryCount() > 1) {
				AppConfig.fragmentManager.popBackStack();
			} else {
				if((System.currentTimeMillis() - lExitTime) > 2000) {
					Tools.toastShow(getResources().getString(R.string.ExitHint));
					lExitTime = System.currentTimeMillis();
				} else {
					//TODO 清理
					finish();
				}
			}
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}
}
