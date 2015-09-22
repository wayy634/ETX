package com.jessieray.epass.core.module;

import com.jessieray.epass.R;

import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.drawable.Drawable;
import android.util.AttributeSet;
import android.widget.FrameLayout;

/**
 * 头布局参数
 */
public class HeadRef extends FrameLayout {
	
	/**
	 * 左按钮类型(0文字按钮1图片按钮)
	 */
	public int iLeftBtnType = 0;
	/**
	 * 右按钮类型
	 */
	public int iRightBtnType = 0;
	/**
	 * 是否显示标题
	 */
	public int iTitleShow = 0;
	/**
	 * 是否显示输入框
	 */
	public int iInputShow = 0;
	/**
	 * 左按钮文字
	 */
	public String strLeftBtnText = "";
	/**
	 * 右按钮文字
	 */
	public String strRightBtnText = "";
	/**
	 * 标题文字
	 */
	public String strTitleText = "";
	/**
	 * 左按钮图片资源
	 */
	public Drawable leftBtnImg;
	/**
	 * 右按钮图片资源
	 */
	public Drawable rightBtnImg;
	/**
	 * 是否显示左按钮
	 */
	public int iLeftBtnShow = 0;
	/**
	 * 是否显示右按钮
	 */
	public int iRightBtnShow = 0;
	
	public HeadRef(Context context, AttributeSet attrs) {
		super(context, attrs);
		TypedArray att = context.obtainStyledAttributes(attrs,R.styleable.head);
		iLeftBtnType = att.getInt(R.styleable.head_leftButton, 0);
		iRightBtnType = att.getInt(R.styleable.head_rightButton,0);
		iLeftBtnShow = att.getInt(R.styleable.head_leftBtnShow, 0);
		iRightBtnShow = att.getInt(R.styleable.head_rightBtnShow, 0);
		iTitleShow = att.getInt(R.styleable.head_titleShow, 1);
		iInputShow = att.getInt(R.styleable.head_inputShow, 1);
		strLeftBtnText = att.getString(R.styleable.head_leftText);
		strRightBtnText = att.getString(R.styleable.head_rightText);
		strTitleText = att.getString(R.styleable.head_titleText);
		leftBtnImg = att.getDrawable(R.styleable.head_leftImg);
		rightBtnImg = att.getDrawable(R.styleable.head_rightImg);
	}

}
