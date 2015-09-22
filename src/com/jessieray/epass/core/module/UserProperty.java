package com.jessieray.epass.core.module;

/**
 * 用户个人信息类
 *
 * 整合了个人信息的属性，及属性存储涉及的key，控制标记
 * Created by stone on 2015/4/15.
 */
public class UserProperty {

	/**
	 * 登录后用户信息
	 */
//	private UserInfo userInfo;
    /**
     * 用户单例对象
     */
    private static UserProperty USER_PROPERTY_INSTANCE = null;
    /**
     * 是否登录
     */
    private boolean isLogin;
	
    /**
     * 获取当前用户单例对象，如果
     * @return
     */
    public static UserProperty getInstance(){
        if (USER_PROPERTY_INSTANCE == null){
            USER_PROPERTY_INSTANCE = new UserProperty();
        }
        return USER_PROPERTY_INSTANCE;
    }

    /**
     * 释放用户对象
     * 在退出登录和切换用户时调用
     */
    public static void release(){
        USER_PROPERTY_INSTANCE = null;
    }

    /**
     * 私有构造器
     * 此构造器并未指定uid，需要单独指定uid
     */
    private UserProperty(){
    }

    public String getUid() {
    	return "";
    }
    /**
     * 判断用户是否登录
     * @return true：标示已登录；false：标示未登录
     */
	public boolean isLogined() {
//		if (userInfo == null || TextUtils.isEmpty(userInfo.getUid())) {
//			return false;
//		}

		return true;
	}

}
