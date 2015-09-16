package com.jessieray.epass.core.account;

import com.jessieray.epass.R;
import com.jessieray.epass.core.BaseFragment;
import com.jessieray.epass.core.MenuScreen;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.core.anntotion.OnClick;
import com.jessieray.epass.core.anntotion.ViewInject;
import com.jessieray.epass.util.Tools;

import android.os.Bundle;
import android.view.View;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

@LayoutInject(layout = R.layout.login)
public class Login extends BaseFragment {

	/**
	 * 电话输入框
	 */
	@ViewInject(id = R.id.login_edit_phone)
	private EditText phone;
	/**
	 * 验证码输入框
	 */
	@ViewInject(id = R.id.login_edit_code)
	private EditText authCode;
	/**
	 * 密码输入框
	 */
	@ViewInject(id = R.id.login_edit_password)
	private EditText passward;
	/**
	 * 验证码布局
	 */
	@ViewInject(id = R.id.login_code_layout)
	private RelativeLayout authCodeLayout;
	/**
	 * 服务协议按钮
	 */
	@ViewInject(id = R.id.login_btn_tos)
	private CheckBox tosBtn;
	/**
	 * 服务协议布局
	 */
	@ViewInject(id = R.id.login_tos_layout)
	private LinearLayout tosLayout;
	/**
	 * 登录注册切换按钮
	 */
	@ViewInject(id = R.id.login_btn_login)
	private TextView alredyBtn;
	/**
	 * 是否是登录页面
	 */
	private boolean isLogin = true;
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onActivityCreated(savedInstanceState);
	}
	
	/**
	 * 注册登录按钮点击
	 * @param view
	 */
	@OnClick(id = R.id.login_btn_ok)
	public void btnOkOnClick(View view) {
		Tools.replaceCurScreen(MenuScreen.class, null);
	}
	
	/**
	 * 发送验证码按钮点击
	 * @param view
	 */
	@OnClick(id = R.id.login_btn_send_code)
	public void btnAuthCodeClick(View view) {
		
	}
	
	/**
	 * 用户协议按钮点击
	 * @param view
	 */
	@OnClick(id = R.id.login_btn_tos_info)
	public void btnTosClick(View view) {
		Tools.pushScreen(TermsOfService.class, null);
	}
	
	/**
	 * 已有账户登录按钮点击
	 * @param view
	 */
	@OnClick(id = R.id.login_btn_login)
	public void btnLoginClick(View view) {
		isLogin = !isLogin;
		if(isLogin) {
			alredyBtn.setText(Tools.getResourceString(R.string.enter_regist));
			tosLayout.setVisibility(View.INVISIBLE);
			authCodeLayout.setVisibility(View.GONE);
		} else {
			alredyBtn.setText(Tools.getResourceString(R.string.already_have_account));
			tosLayout.setVisibility(View.VISIBLE);
			authCodeLayout.setVisibility(View.VISIBLE);
		}
	}
}
