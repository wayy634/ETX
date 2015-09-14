package com.jessieray.epass.core.module;




import com.jessieray.epass.R;
import com.jessieray.epass.core.BaseFragment;
import com.jessieray.epass.core.anntotion.LayoutInject;
import com.jessieray.epass.core.anntotion.OnClick;
import com.jessieray.epass.core.anntotion.ViewInject;

import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

/**
 * 头布局
 *
 */
@LayoutInject(layout = R.layout.include_head_layout)
public class HeadView extends BaseFragment{

	/**
	 * 按钮点击监听
	 */
	private HeadViewBtnOnClickListener headViewBtnOnClickListener;
	/**
	 * 头布局参数
	 */
	private HeadRef headRef;
	/**
	 * 左按钮
	 */
	@ViewInject(id = R.id.titlebar_left)
	private TextView btnLeft;
	/**
	 * 标题
	 */
	@ViewInject(id = R.id.titlebar_title)
	private TextView title;
	/**
	 * 右按钮
	 */
	@ViewInject(id = R.id.titlebar_right)
	private TextView btnRight;
	/**
	 * 输入框布局
	 */
	@ViewInject(id = R.id.titlebar_input)
	private LinearLayout inputLayout;
	/**
	 * 输入框
	 */
	@ViewInject(id = R.id.titlebar_input_edittext)
	private EditText inputText;
	
	public HeadView(HeadRef headRef,HeadViewBtnOnClickListener listener) {
		this.headRef = headRef;
		this.headViewBtnOnClickListener = listener;
	}
	
	@Override
	public void onActivityCreated(Bundle savedInstanceState) {
		super.onActivityCreated(savedInstanceState);
		initHead();
	}
	
	/**
	 * 初始化头布局
	 */
	private void initHead() {
		if(this.headRef != null) {
			if(this.headRef.iLeftBtnType == 0) {
				btnLeft.setText(this.headRef.strLeftBtnText);
			} else if(this.headRef.iLeftBtnType == 1) {
				btnLeft.setBackgroundDrawable(this.headRef.leftBtnImg);
			}
			if(this.headRef.iLeftBtnShow == 0) {
				btnLeft.setVisibility(View.GONE);
			} else if(this.headRef.iLeftBtnShow == 1) {
				btnLeft.setVisibility(View.VISIBLE);
			}
			if(this.headRef.iRightBtnType == 0) {
				btnRight.setText(this.headRef.strRightBtnText);
			} else if(this.headRef.iRightBtnType == 1) {
				btnRight.setBackgroundDrawable(this.headRef.rightBtnImg);
			}
			if(this.headRef.iRightBtnShow == 0) {
				btnRight.setVisibility(View.GONE);
			} else if(this.headRef.iRightBtnShow == 1) {
				btnRight.setVisibility(View.VISIBLE);
			}
			if(this.headRef.iTitleShow == 0) {
				title.setText(this.headRef.strTitleText);
				title.setVisibility(View.VISIBLE);
			} else if(this.headRef.iTitleShow == 1) {
				title.setVisibility(View.GONE);
			}
			if(this.headRef.iInputShow == 0) {
				inputLayout.setVisibility(View.VISIBLE);
				inputText.addTextChangedListener(textWatcher);
			} else if(this.headRef.iInputShow == 1) {
				inputLayout.setVisibility(View.GONE);
			}
		}
	}
	
	/**
	 * 输入框监听
	 */
	public TextWatcher textWatcher = new TextWatcher() {
		
		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
			
		}
		
		@Override
		public void beforeTextChanged(CharSequence s, int start, int count,
				int after) {
			
		}
		
		@Override
		public void afterTextChanged(Editable s) {
			if(headViewBtnOnClickListener != null) {
				headViewBtnOnClickListener.editTextChange();
			}
		}
	};
	
	/**
	 * 左按钮点击监听
	 */
	@OnClick(id = R.id.titlebar_left)
	public void leftClick(View view) {
		if(headViewBtnOnClickListener != null) {
			headViewBtnOnClickListener.leftOnClick();
		}
	}
	
	/**
	 * 右按钮点击监听
	 */
	@OnClick(id = R.id.titlebar_right)
	public void rightClick(View view) {
		if(headViewBtnOnClickListener != null) {
			headViewBtnOnClickListener.rightOnClick();
		}
	}
	
	/**
	 * 按钮点击监听
	 */
	public interface HeadViewBtnOnClickListener {
		public void leftOnClick();
		public void rightOnClick();
		public void editTextChange();
	}
}
