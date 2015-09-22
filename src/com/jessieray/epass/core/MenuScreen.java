package com.jessieray.epass.core;

import com.jessieray.epass.R;
import com.jessieray.epass.config.AppConfig;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.widget.slidingmenu.SlidingMenu;

import android.os.Bundle;

@LayoutInject(layout = R.layout.menu_screen)
public class MenuScreen extends BaseFragment {

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
	     SlidingMenu menu = new SlidingMenu(AppConfig.mainActivity);
	        menu.setMode(SlidingMenu.LEFT);
	        menu.setTouchModeAbove(SlidingMenu.TOUCHMODE_FULLSCREEN);
	        menu.setShadowWidthRes(R.dimen.shadow_width);
	        menu.setShadowDrawable(R.drawable.shadow);
	        menu.setBehindOffsetRes(R.dimen.slidingmenu_offset);
	        menu.setFadeDegree(0.35f);
	        menu.attachToActivity(AppConfig.mainActivity, SlidingMenu.SLIDING_CONTENT);
	        menu.setMenu(R.layout.menu);
	}
}
