package com.jessieray.epass.config;

import com.jessieray.epass.MainActivity;
import com.jessieray.epass.core.BaseFragment;

import android.content.Context;
import android.support.v4.app.FragmentManager;
import android.view.LayoutInflater;

public class AppConfig {

	/**
	 * 调试开关
	 */
	public static final boolean DEBUG = true;
	/**
	 * 屏幕宽高
	 */
	public static int SCREEN_WIDTH;
	public static int SCREEN_HEIGHT;
	/**
	 * 应用环境
	 */
	public static Context context = null;
	/**
	 * 应用主类实例
	 */
	public static MainActivity mainActivity;
	/**
	 * fragment页面管理类实例
	 */
	public static FragmentManager fragmentManager;
	/**
	 * 当前的根屏幕
	 */
	public static String CurrentRootScreenName = "";
	/**
	 * 当前屏幕
	 */
	public static BaseFragment currentScreen;
	/**
	 * 用户相关服务器传回的签名key
	 */
	public static String SCRET_KEY = "";
	/**
	 * 签名key
	 */
	public static String SIGN = "sign";
	/**
	 * 用户UID
	 */
	public static String UID_VALUE = "";
	/**
	 * 当前版本号
	 */
	public static String CLIENT_VERSION_VALUE = "1.0.0";
	/**
	 * 渠道号
	 */
	public static String SOURCE_ID = "0000";
	/**
	 * 时间戳
	 */
	public static String TIMESTAMP_STRING="timestamp";
	/**
	 * 服务器和本地时间差
	 */
	public static long updateTimestamp;
	/**
	 * 平台号
	 */
	public static String PLATFORM_VALUE = "13022";
	/**
	 * 设备相关信息
	 */
	public static String DEVICE_TOKEN = "0";//设备唯一标识
    public static String DEVICE_DS = ""; //手机型号
    public static String DEVICE_OS = ""; //手机操作系统
	public static String DEV_APPKEY_VALUE = "";//渠道号
	public static final String DEVICE_TYPE = "android";//平台类型
	public static String strPushClientId = "";//push用设备唯一标识
	/**
	 * http请求方式
	 */
	public static final int HTTP_GET = 0;
	public static final int HTTP_POST = 1;
	public static final int HTTP_PUT = 2;
	/**
	 * 请求url
	 */
	public static String url;
	public static final String[] HTTP_URL = new String[]{
		"http://182.92.79.73:8080/mome/api",
		"http://release"
	};
	/**
	 * 列表一页请求的数据条数
	 */
	public static final int PAGE_SIZE = 20;
	/**
	 * 用来通过xml创建view实例
	 */
	public static LayoutInflater INFLATER = null;
	/**
	 * 首次安装启动应用程序
	 */
	public static boolean isFirstInstall;
	/**
	 * 首次启动应用程序
	 */
	public static boolean isFirstBoot;
	
	/*************************************************************************
	 * 存储用key值
	 *************************************************************************/
	/**
	 * 存储版本号的key
	 */
	public static final String SAVE_KEY_VERSION = "version";
}
