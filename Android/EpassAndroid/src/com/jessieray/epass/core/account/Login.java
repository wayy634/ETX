package com.jessieray.epass.core.account;

import com.jessieray.epass.R;
import com.jessieray.epass.core.BaseFragment;
import com.jessieray.epass.core.MenuScreen;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.core.anntotion.OnClick;
import com.jessieray.epass.util.Tools;

import android.os.Bundle;
import android.view.View;

@LayoutInject(layout = R.layout.login)
public class Login extends BaseFragment {

	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
	}
	
	@OnClick(id = R.id.button1)
	public void btnOnClick(View view) {
		Tools.pushScreen(MenuScreen.class, null);
	}
}
