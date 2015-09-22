package com.jessieray.epass.core;

import com.jessieray.epass.R;
import com.jessieray.epass.core.account.Login;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.util.Tools;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;


/**
 * 启动屏幕
 * 
 */
@LayoutInject(layout = R.layout.launchscreen)
public class LaunchScreen extends BaseFragment{
	
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		handler.post(launchThread);
	}
	
	@Override
	public void onDestroy() {
		super.onDestroy();
		if(handler != null) {
			handler.removeCallbacks(launchThread);
			handler = null;
		}
	}

	/**
	 * 回调handler实例
	 */
	private Handler handler = new Handler(){
		 
		public void handleMessage(Message msg) {
//			if(AppConfig.isFirstInstall) {
//				Tools.replaceCurScreen(NewuserGuide.class, null);
//			} else {
				Tools.replaceCurScreen(Login.class, null);
//			}
		}
	};

	/**
	 * 启动线程
	 */
	private Runnable launchThread = new Runnable() {
		/**
		 * 载入时间
		 */
		private int iTime;
		
		@Override
		public void run() {
			if(iTime < 2) {
				iTime++;
				handler.postDelayed(this,1000);
			} else {
				handler.sendEmptyMessage(0);
			}
		}
	};
}