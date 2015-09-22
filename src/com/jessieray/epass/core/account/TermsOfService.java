package com.jessieray.epass.core.account;

import com.jessieray.epass.R;
import com.jessieray.epass.core.BaseFragment;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.core.anntotion.ViewInject;
import com.jessieray.epass.util.Tools;

import android.os.Bundle;
import android.webkit.JsPromptResult;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

@LayoutInject(layout = R.layout.terms_of_service)
public class TermsOfService extends BaseFragment {

	/**
	 * 用户协议浏览器
	 */
	@ViewInject(id = R.id.terms_of_service_webview)
	private WebView webView;
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		initView();
	}
	
	private void initView() {
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setDefaultTextEncodingName("UTF-8");
		webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		webView.getSettings().setDatabaseEnabled(true);
		webView.getSettings().setDomStorageEnabled(true);
		webView.requestFocus();
		webView.requestFocusFromTouch();
		webView.setWebViewClient(new MyWebViewClient());
		webView.setWebChromeClient(new WebChromeClient() {

			@Override
			public boolean onJsAlert(WebView view, String url, String message, JsResult result) {
				Tools.showAlertDialog(message);
				result.confirm();
				return true;
			}

			@Override
			public boolean onJsPrompt(WebView view, String url, String message, String defaultValue,
					JsPromptResult result) {
				Tools.showAlertDialog(message);
				result.confirm();
				return false;
			}
			
		});
	}
	
	/**
	 * 自定义客户端
	 */
	class MyWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			view.loadUrl(url);
			return true;
		}
	}
	
}
