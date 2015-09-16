package com.jessieray.epass.util;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;

import com.jessieray.epass.R;
import com.jessieray.epass.config.AppConfig;
import com.jessieray.epass.core.BaseFragment;

import android.app.AlertDialog;
import android.app.Dialog;
import android.app.AlertDialog.Builder;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.res.Resources;
import android.os.Bundle;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentManager.OnBackStackChangedListener;
import android.support.v4.app.FragmentTransaction;
import android.util.Log;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.view.animation.Interpolator;
import android.view.animation.ScaleAnimation;
import android.view.animation.TranslateAnimation;
import android.widget.Toast;

public class Tools {
	
	/**
	 * 创建Alert框
	 */
	private static AlertDialog.Builder builder;
	/**
	 * 提示框
	 */
	public static Dialog dialog;
	
	/**
	 * toast提示信息
	 * @param message
	 */
	public static final void toastShow(String message) {
		Toast.makeText(AppConfig.context, message, 1000).show();
	}
	
	/**
	 * 日志信息打印
	 * @param message
	 */
	public static final void Log(String message) {
		Log.i("MOME",message);
	}
	
	/**
	 * 跳转到一个屏幕
	 * @param baseFragment
	 * @param args
	 */
	public static final void pushScreen(Class<? extends BaseFragment> baseFragment,Bundle args) {
		try {
			BaseFragment curScreen = baseFragment.newInstance();
			curScreen.setArguments(args);
			AppConfig.currentScreen = curScreen;
			FragmentTransaction transaction = AppConfig.fragmentManager.beginTransaction();
			transaction.add(R.id.viewContainer, curScreen);
			transaction.addToBackStack(baseFragment.getName());
			transaction.commit();
			if(AppConfig.fragmentManager.getBackStackEntryCount() == 0) {
				AppConfig.CurrentRootScreenName = baseFragment.getName();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}

	/**
	 * 切换根屏幕
	 * @param baseFragment
	 * @param args
	 */
	public static final void replaceRootPushScreen(Class<? extends BaseFragment> baseFragment,Bundle args) {
		try {
			BaseFragment curScreen = baseFragment.newInstance();
			curScreen.setArguments(args);
			AppConfig.currentScreen = curScreen;
			AppConfig.fragmentManager.popBackStack(AppConfig.CurrentRootScreenName, FragmentManager.POP_BACK_STACK_INCLUSIVE);//弹出指定屏幕之上的包括自己的所有屏幕
			FragmentTransaction transaction = AppConfig.fragmentManager.beginTransaction();
			transaction.replace(R.id.viewContainer, curScreen);
			transaction.addToBackStack(baseFragment.getName());
			transaction.commit();
			AppConfig.CurrentRootScreenName = baseFragment.getName();
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	/**
	 * 在指定屏幕之上显示当前屏幕
	 * @param baseFragment 要跳转的屏幕
	 * @param args 参数
	 * @param assign 指定的屏幕
	 */
	public static final void pushOntoAssignScreen(Class<? extends BaseFragment> baseFragment,Bundle args,Class<? extends BaseFragment> assign) {
		try {
			BaseFragment curScreen = baseFragment.newInstance();
			curScreen.setArguments(args);
			AppConfig.currentScreen = curScreen;
			AppConfig.fragmentManager.popBackStack(assign.getName(), 0);//0表示弹出的屏幕不包括当前屏幕
			FragmentTransaction transaction = AppConfig.fragmentManager.beginTransaction();
			transaction.add(R.id.viewContainer, curScreen);
			transaction.addToBackStack(baseFragment.getName());
			transaction.commit();
			final String name = baseFragment.getName();
			AppConfig.fragmentManager.addOnBackStackChangedListener(new OnBackStackChangedListener() {
				
				@Override
				public void onBackStackChanged() {
					if(AppConfig.fragmentManager.getBackStackEntryCount() <= 1) {
						AppConfig.CurrentRootScreenName = name;
					}
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	/**
	 * 替换当前屏幕
	 * @param baseFragment
	 * @param args
	 */
	public static final void replaceCurScreen(Class<? extends BaseFragment> baseFragment,Bundle args) {
		try {
			BaseFragment curScreen = baseFragment.newInstance();
			curScreen.setArguments(args);
			FragmentTransaction transaction = AppConfig.fragmentManager.beginTransaction();
			AppConfig.fragmentManager.popBackStack();
			transaction.add(R.id.viewContainer, curScreen);
			transaction.addToBackStack(baseFragment.getName());
			transaction.commit();
			final String name = baseFragment.getName();
			AppConfig.fragmentManager.addOnBackStackChangedListener(new OnBackStackChangedListener() {
				
				@Override
				public void onBackStackChanged() {
					if(AppConfig.fragmentManager.getBackStackEntryCount() <= 1) {
						AppConfig.CurrentRootScreenName = name;
					}
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
		} 
	}
	
	/**
	 * 用于tab切换时候的屏幕跳转
	 * @param screen
	 * @param args
	 */
	public static final void replaceScreen(BaseFragment screen,Bundle args) {
		try {
			FragmentTransaction transaction = AppConfig.fragmentManager.beginTransaction();
			transaction.replace(R.id.viewContainer, screen);
			AppConfig.CurrentRootScreenName = screen.getClass().getName();
			transaction.commit();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 弹出一个屏幕
	 */
	public static final void pullScreen() {
		AppConfig.fragmentManager.popBackStack();
	}
	
	/**
	 * 获取时间戳变体
	 * @param nowTimestamp
	 * @return
	 * @throws ParseException
	 */
	public static String getMogoTimestamp(long nowTimestamp)throws ParseException{
//		Date mogoDate = new Date();
//		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
//		formatter.setTimeZone(TimeZone.getTimeZone("GMT+8"));
//		mogoDate = formatter.parse("2013-09-22 18:20:06");
		long time = 1379845206000l;
		return String.valueOf(nowTimestamp - time);	
	}
	
	private static Comparator<String> signComparator = new Comparator<String>() {
		@Override
		public int compare(String o1, String o2) {
			return o1.toLowerCase().compareTo(o2.toLowerCase());
		}
	};
	
	/**
	 * 
	 * @param paramMap 网络接口参数容器(1、该容器里必须包含timestamp参数，否则本次签名失败; 2、该容器不可以 包含sign和secret参数)
	 * @param secret md5(用户密码)；或者是 md5（时间戳变体）
	 * @return signValue
	 */
	public static String getSign( Map<String, String> tempMap ,String secret ) throws UnsupportedEncodingException{
		if( secret == null || tempMap == null){
			return "";
		}
		if(tempMap.size() <=0){
			return "";
		}
		Map<String, String> paramMap = new HashMap<String,String>();
		paramMap.putAll(tempMap);
		String timeStampValue=paramMap.get("timestamp");
		if( timeStampValue == null || timeStampValue != null && timeStampValue.length() <=1){
			return "";
		}
		StringBuilder paramStringBuffer = new StringBuilder();
		List<String> keyList = new ArrayList<String>(); 
//		keyList.add(SECRET_STRING);
		paramMap.put("secret", getSecret(secret));
		Set keysSet = paramMap.keySet();
		Iterator iterator = keysSet.iterator();
		while(iterator.hasNext()) {
			keyList.add(((String)iterator.next()));
		}	
		
		//升序操作
		Collections.sort(keyList,signComparator);
		int timeMogoValue = getTimestampMogoIndex(timeStampValue);
		for(int i = 0; i < keyList.size(); i++){
			paramStringBuffer.append(keyList.get(i));
			if(timeMogoValue == i || (timeMogoValue >= keyList.size()-1 && i == keyList.size()-1)){
				paramStringBuffer.append("?");
			}
			paramStringBuffer.append("*");
			paramStringBuffer.append(paramMap.get(keyList.get(i)));
			if( i != keyList.size()-1 ){
				paramStringBuffer.append("?");
			}
		}
		byte [] temp = {0};
		temp = paramStringBuffer.toString().getBytes("UTF-8");
		return toMd5(temp).toUpperCase();
	}
	
	/**
	 * md5加密param，生成secret
	 * @param param md5后的用户密码或者变体时间戳
	 * @return
	 */
	public static String getSecret(String param ) throws UnsupportedEncodingException{
	    String secret = "";
		if (param != null && !param.equalsIgnoreCase("")) {
			byte [] secretBytes = param.getBytes("UTF-8");
			if(secretBytes != null && secretBytes.length >0 ){
				secret = toMd5(secretBytes);
			}
		}
	return secret;
	}
	
	public static int getTimestampMogoIndex(String timestamp ){
		if(timestamp != null && timestamp.length() > 0){
			char index = timestamp.charAt(timestamp.length()-1);
			return Integer.parseInt(String.valueOf(index));
		}else{
			return -1;
		}
	}
	
	public static final char HEX_DIGITS[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
        'a', 'b', 'c', 'd', 'e', 'f' };

	public static String toHexString(byte[] bytes) {
		StringBuilder sb = new StringBuilder(bytes.length * 2);  
        for (int i = 0; i < bytes.length; i++) {  
            sb.append(HEX_DIGITS[(bytes[i] & 0xf0) >>> 4]);  
            sb.append(HEX_DIGITS[bytes[i] & 0x0f]);  
		}
        return sb.toString();
	}
	
	/**
	 * MD5 加密
	 * @param bytes
	 * @return
	 */
	public static String toMd5(byte[] bytes) {
		String result_md5 = "";
		try {
			MessageDigest algorithm = MessageDigest.getInstance("MD5");
			algorithm.reset();
			algorithm.update(bytes);
			result_md5 = toHexString(algorithm.digest());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result_md5;
	}
	
	/**
	 * 获取一组动画序列
	 * @param ani
	 * @return
	 */
	public static Animation getGroupAni(Animation...ani) {
		if(ani == null || ani.length == 0) {
			return null;
		}
		AnimationSet aniSet = new AnimationSet(false);
		if(ani != null && ani.length > 0) {
			for(Animation animation : ani) {
				aniSet.addAnimation(animation);
			}
		}
		return aniSet;
	}
	
	/**
	 * 获取平移动画
	 * @param durationMillis
	 * @param startOffset
	 * @param fromXDelta
	 * @param toXDelta
	 * @param fromYDelta
	 * @param toYDelta
	 * @param inter
	 * @return
	 */
	public static Animation getTranslateAni(long durationMillis,long startOffset,float fromXDelta, float toXDelta, float fromYDelta, float toYDelta,Interpolator inter) {
		TranslateAnimation ani = new TranslateAnimation(fromXDelta, toXDelta, fromYDelta, toYDelta);
		ani.setDuration(durationMillis);
		ani.setFillAfter(true);
		ani.setInterpolator(inter);
		ani.setStartOffset(startOffset);
		return ani;
	}
	
	/**
	 * 带物理效果的缩放
	 * @param duration
	 * @param interpolator
	 * @param from
	 * @param to
	 * @return
	 */
	public static Animation getScaleAnimation(long duration,long startOffset,Interpolator interpolator,float from,float to) {
		Animation scaleAni = new ScaleAnimation (from, to, from, to, Animation.RELATIVE_TO_SELF, 0.5f, Animation.RELATIVE_TO_SELF, 0.5f);
		scaleAni.setDuration(duration);
		scaleAni.setInterpolator(interpolator);
		scaleAni.setStartOffset(startOffset);
		scaleAni.setFillAfter(true);
		return scaleAni;
	}
	
	/**
	 * 获取透明度动画
	 * @param durationMillis
	 * @param startOffset
	 * @param fromAlpha
	 * @param toAlpha
	 * @return
	 */
	public static Animation getAlphaAni(long durationMillis,long startOffset,float fromAlpha, float toAlpha) {
		AlphaAnimation alphaAni = new AlphaAnimation(fromAlpha, toAlpha);
		alphaAni.setDuration(durationMillis);
		alphaAni.setFillAfter(true);
		alphaAni.setStartOffset(startOffset);
		return alphaAni;
	}
	
	/**
	 * 截取字符串
	 * @param str 原串
	 * @param open 开始位置
	 * @param close 结束位置
	 * @return
	 */
	public static String substringBetween(String str, String open, String close) {
		return StringUtils.defaultIfEmpty(
				StringUtils.substringBetween(str, open, close),
				StringUtils.substringAfter(str, open)
				);
	}
	
    public static float dp2px(Resources resources, float dp) {
        final float scale = resources.getDisplayMetrics().density;
        return  dp * scale + 0.5f;
    }

    public static float sp2px(Resources resources, float sp){
        final float scale = resources.getDisplayMetrics().scaledDensity;
        return sp * scale;
    }
    
    /**
     * 获取资源字符串
     * @param id
     * @return
     */
    public static String getResourceString(int id) {
    	if(AppConfig.mainActivity != null) {
    		return AppConfig.mainActivity.getResources().getString(id);
    	}
    	return null;
    }
    
    /**
     * 获取资源颜色
     * @param id
     * @return
     */
    public static int getResourceColor(int id) {
    	if(AppConfig.mainActivity != null) {
    		return AppConfig.mainActivity.getResources().getColor(id);
    	}
    	return -1;
    }
    
    /**
     * 获取资源尺寸
     * @param id
     * @return
     */
    public static float getResourceDime(int id) {
    	if(AppConfig.mainActivity != null) {
    		return AppConfig.mainActivity.getResources().getDimension(id);
    	}
    	return 0f;
    }
    
	/**
	 * 显示带2个button的对话框
	 * @param title 标题
	 * @param msg 内容
	 * @param leftName 左按钮名称
	 * @param rightName 右按钮名称
	 * @param leftListener 左按钮事件
	 * @param rightListener 右按钮事件
	 */
	public static void showAlertDialog(String title,String msg,
			String leftName,String rightName,DialogInterface.OnClickListener leftListener,
			DialogInterface.OnClickListener rightListener){
		builder = null;
		builder = new Builder(AppConfig.context);
		builder.setMessage(msg);
		builder.setTitle(title);
		builder.setPositiveButton(leftName, leftListener);
		builder.setNegativeButton(rightName, rightListener);
		final DialogInterface.OnClickListener cancelListener = leftListener;
		if(cancelListener != null) {
			builder.setOnCancelListener(new OnCancelListener() {
					
				@SuppressWarnings("static-access")
				public void onCancel(DialogInterface dialog) {
					cancelListener.onClick(dialog, dialog.BUTTON_NEGATIVE);
				}
			});
		}
		if (dialog != null){
			try{
				dialog.dismiss();
			}catch(Exception e){}
		}

		dialog = builder.create();
		dialog.show();
		dialog.setCanceledOnTouchOutside(false);
	}
	
	/**
	 * 显示带2个button的对话框
	 * @param title 标题
	 * @param msg 内容
	 * @param leftName 左按钮名称
	 * @param rightName 右按钮名称
	 * @param leftListener 左按钮事件
	 * @param rightListener 右按钮事件
	 */
	public static void showAlertDialogRightCancel(String title,String msg,
			String leftName,String rightName,DialogInterface.OnClickListener leftListener,
			DialogInterface.OnClickListener rightListener){
		builder = null;
		builder = new Builder(AppConfig.context);
		builder.setMessage(msg);
		builder.setTitle(title);
		builder.setPositiveButton(leftName, leftListener);
		builder.setNegativeButton(rightName, rightListener);
		final DialogInterface.OnClickListener cancelListener = rightListener;
		if(cancelListener != null) {
			builder.setOnCancelListener(new OnCancelListener() {
					
				@SuppressWarnings("static-access")
				public void onCancel(DialogInterface dialog) {
					cancelListener.onClick(dialog, dialog.BUTTON_NEGATIVE);
				}
			});
		}
		if (dialog != null){
			try{
				dialog.dismiss();
			}catch(Exception e){}
		}

		dialog = builder.create();
		dialog.show();
		dialog.setCanceledOnTouchOutside(false);
	}
	
	/**
	 * 只设定提示内容的对话框
	 * @param msg
	 */
	public static void showAlertDialog(String msg){
		showAlertDialog("提示",msg,"确定",null,null);
	}
	
	/**
	 * 可以设定标题和内容的对话框
	 * @param title
	 * @param msg
	 */
	public static void showAlertDialog(String title,String msg){
		showAlertDialog(title,msg,"确定",null,null);
	}
	
	/**
	 * 可以设定一个按钮事件的对话框
	 * @param msg 显示的内容
	 * @param btnName 按钮名称
	 * @param callback
	 */
	public static void showAlertDialog(String msg,String btnName,DialogInterface.OnClickListener btnOnclickListener){
		showAlertDialog("提示",msg,null,btnName,null,btnOnclickListener);
	}
	
	/**
	 * 显示带一个按钮并且可以设定cancel事件的对话框
	 * @param title 标题
	 * @param msg 内容
	 * @param leftName 按钮名称
	 * @param leftListener 按钮事件
	 * @param cancelListener 取消事件
	 */
	public static void showAlertDialog(String title,String msg,
			String leftName,DialogInterface.OnClickListener leftListener,
			DialogInterface.OnCancelListener cancelListener){
		builder = null;
		builder = new Builder(AppConfig.context);
		builder.setMessage(msg);
		builder.setTitle(title);
		builder.setPositiveButton(leftName, leftListener);
		builder.setNegativeButton(null, null);
		builder.setOnCancelListener(cancelListener);
		
		if (dialog != null)
			dialog.dismiss();
		dialog = builder.show();
		dialog.setCanceledOnTouchOutside(false);
	}
}
