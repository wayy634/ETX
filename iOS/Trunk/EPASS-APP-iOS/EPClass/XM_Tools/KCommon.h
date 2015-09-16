//
//  KCommon.h
//  LeHeCai
//
//  Created by HXG on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//是否是生产
#define K_IS_PUBLISH  0

#if K_IS_PUBLISH == 1 //生产
    #define K_URL_HOST @"http://123.56.91.111:8080"
#elif K_IS_PUBLISH == 0 //开发
    #define K_URL_HOST @"http://123.56.91.111:8080"
#endif

//#define TEST_DEBUG
//10.172.3.223:8090
#define K_URL_TAIL_ADDRESS [NSString stringWithFormat:@"%@",[[LTools getAppData] objectAtIndex:1]]
#define K_NAME_CHNANEL     [NSString stringWithFormat:@"%@",[[LTools getAppData] objectAtIndex:0]]
#define K_PLATFORMID       [NSString stringWithFormat:@"%@",[[LTools getAppData] objectAtIndex:7]]

//友盟
#define K_UMENG_IOS_KEY         @"555471b4e0f55aec4c001616"
//腾讯QQ
#define K_QQ_APP_ID             @"1101490109"
#define K_QQ_APP_KEY            @"1x8F82kJt74rQV7D"
#define K_QQ_CHANGELOCATION_KEY @"YIHBZ-G7WWW-WKXRO-RL2EH-IOPWF-B3BKG"
//微信
#define K_WECHAT_APP_ID         @"wx0df35771bdea78fa"
#define K_WECHAT_APP_SECRET     @"e6d886b244a74a50e384a3d9f0b71505"

//新浪微博
#define K_SINA_REDIRECT_URL     @"https://api.weibo.com/oauth2/default.html"

//一些固定的Url地址
#define K_WEBURL_INVATATIONFRIENDS_RULE  @"http://wap.tmall.imEPASS-APP-iOS.com/page/bonus/activityExplain.html"//邀请好友的活动规则
//邀请好友的单日上限
#define K_INVITATIONFRIENDS_EVERYDAY_MAX 30 
//suk列表页面 分页的单页数量
#define  K_KEY_SKULIST_PAGESIZE     [NSString stringWithFormat:@"%i",10]



//*********************************以下都没用了********************************************************************








// LOG 日志信息 如果定义不起作用, 请先确认是否“先”导入了"ULogging.h"
//#ifdef TEST_DEBUG
//#define INFO                    1
//#else
//#define SILENT                  1
//#endif

// Profile---------------
#define K_APP_STORE_URL             @"http://itunes.apple.com/cn/app/id918232107"
//#define K_CLIENT_VERSION            @"3.0.0"
#define K_CLIENT_VERSION            [NSString stringWithFormat:@"%@",[[LTools getAppData] objectAtIndex:2]]
#define K_ALIPAY_ITUNES_URL         @"http://itunes.apple.com/cn/app/id333206289?mt=8"
#define K_BANKONLINE_ITUNES_URL     @"http://itunes.apple.com/cn/app/id565074434?mt=8"
#define K_URL_TAIL_PREFIX           @"?version=v1&deviceid=1"
#define K_URL_TAIL                  [NSString stringWithFormat:@"%@&clientversion=%@", K_URL_TAIL_PREFIX, K_CLIENT_VERSION]
#define K_BACK_URL                  [NSString stringWithFormat:@"%@://",[[LTools getAppData] objectAtIndex:5]]//@"EPASS-APP-iOSiosapp://"
#define K_BACK_URL_SHARE            @"EPASS-APP-iOSiosapp://"
#define K_ALIPAY_BACK_URL           [NSString stringWithFormat:@"%@",[[LTools getAppData] objectAtIndex:5]]
#define K_ALILogin_BACK_URL         [NSString stringWithFormat:@"%@alilogin",[[LTools getAppData] objectAtIndex:5]]

//----------------------------------------------------------------------

// Client: Key --- Save

// paypasswd start
#define K_KEY_SID                   @"sid"
#define K_KEY_ISACTIVETED           @"isactiveted"
#define K_KEY_BALANCE               @"balance"
#define K_KEY_CASH_BALANCE          @"cash_balance"
#define K_KEY_HANDSEL_BALANCE       @"handsel_balance"
#define K_KEY_NOTPAY_NUM            @"notpay_num"
#define K_KEY_DRAW_LIST_CACHE       @"DRAWLISTCACHE"
#define K_KEY_PAYPWD_STATUS         @"payPwdStatus"
// paypaswd end

// recharge start
#define K_KEY_DEFAULT_RECHARGETYPE  @"default_recharge_type"
// recharge end

#define K_KEY_IVR_BAND              @"ivr_band"
#define K_KEY_USER_BANK             @"user_bank"
#define K_KEY_BANK_DEFAULT          @"bank_default"
#define K_KEY_USERNAME              @"userName"
#define K_KEY_THIRD_USERNAME        @"third_userName"
#define K_KEY_REMBER_USERNAME       @"remberUserName"
#define K_KEY_UID                   @"uid"
#define K_KEY_LOGIN_PASSWD          @"user_password"
#define K_KEY_LOGIN_PHONE           @"phone"
#define K_KEY_LOGIN_EMAIL           @"email"
#define K_KEY_IDENTITY              @"identity"
#define K_KEY_TRUE_NAME             @"true_name"
#define K_KEY_REGFROM               @"regFrom"
#define K_KEY_ALLOWUPDATE           @"allowUpdate"
#define K_KEY_ISCHECK               @"ischeck"//是否完善用户信息
#define K_KEY_ALLOWEDITNICKNAME     @"allowdEitNickName"//允许修改昵称
#define K_KEY_REMBER_PASS           @"auto_login"
#define K_KEY_THIRDLOGIN            @"is_third_login"
#define K_KEY_EMAIL_CHECKED         @"is_email_checked"
#define K_KEY_PHONE_CHECKED         @"is_phone_checked"
#define K_KEY_POPULER_ARRAY         @"populerArrayNew"
#define K_KEY_RESGIN_BY_PHONE       @"resginByPhone"
#define K_LOCAL_TIME                @"local_time"
#define K_KEY_SIGN_ID               @"signid"
#define K_KEY_ISLOGINTIMEOUT        @"is_login_timeout"
#define K_AD_INFO                   @"___AD__INFO"
#define K_KEY_LOGIN_AUTO            @""
#define K_NEW_KEY_USERNAME          (id)kSecAttrAccount
#define K_NEW_KEY_LOGIN_PASSWD      (id)kSecValueData
#define K_LOGIN_REQUIRE_SID         58720257
#define K_LOGIN_HANDSEL_ERROR_NUMBER 117968897
#define K_KTY_ISFIRSTOPENAPP        (id)kSecAttrService//是否是第一次激活应用（不论删除重装）

#define K_KEY_ISHAVENEWUSERGIFT     @"ishave_newusergift"   //是否有新用户赠彩资格
#define K_KEY_NEWUSERISTAKE         @"newuser_istake"       //是否是完成新用户赠彩
//百度彩票 新的用户保存数据  开始
#define K_KEY_NEEDREFLUSH_ACCOUNT   @"needReflush_account"//需要回来刷新accountData的地方
#define K_KEY_USER_NICKNAME         @"user_nick_name"//登录的之后要显示的昵称
#define K_KEY_IS_REGISTER           @"K_KEY_IS_REGISTER"//是否注册过
#define K_KEY_CACHE_USERINFO        @"userinfo"
#define K_KEY_IS_SHOWQQLOGIN        @"K_KEY_IS_SHOWQQLOGIN"//服务器端判断是否要显示qq第三方登陆
//百度彩票 新的用户保存数据  结束
#define K_KEY_NEWUSERGIFT_FLAG      @"K_KEY_NEWUSERGIFT_FLAG"//判断用户参与新用户赠彩流程的时候，是通过百度用户登录，还是新注册用户参与的(1,登录 2，注册  3，其他)
#define K_KEY_IS_FIRSTOPEN_CALENDAR @"K_KEY_IS_FIRSTOPEN_CALENDAR"//是否第一次打开日历模块

#define K_KEY_LASTDATESHOWWONORDER @"K_KEY_LASTDATESHOWWONORDER"//最后一次记录中间订单的时间


#define K_KEY_CHECKNEWUSER_UID      @"checkNewUserUid"

//sinalogin
#define K_SINA_AUTH_DATA           @"SinaWeiboAuthData"
#define K_SINA_ACCESSTOKEN         @"SinaAccessToken"
#define K_SINA_EXPIRATIONDATE      @"SinaExpirationDate"
#define K_SINA_USERID              @"SinaUserID"
#define K_SINA_REFRESHTOKEN        @"SinaRefreshToken"

//qqlogin
#define K_QQ_AUTH_DATA             @"QQAuthData"
#define K_QQ_ACCESSTOKEN           @"QQAccessToken"
#define K_QQ_EXPIRATIONDATE        @"QQExpirationDate"
#define K_QQ_OPENID                @"QQOpenID"

#define K_BAIDU_AUTH_DATA          @"BaiduAuthData"
#define K_BAIDU_ACCESSTOKEN        @"BaiduAccessToken"
#define K_BAIDU_EXPIRATIONDATE     @"BaiduExpirationDate"
#define K_BAIDU_OPENID             @"BaiduOpenID"
#define K_BAIDU_REQUEST_URL        @"https://openapi.baidu.com/rest/2.0/passport/users/getLoggedInUser"

#define K_QQUSER_PREFIX            @"腾讯用户"
#define K_SINAUSER_PREFIX          @"新浪用户"
#define K_BAIDU_PREFIX             @"百度用户"

//比分直播
#define K_GAMELIVELIST_OVER_JC        @"gamelivelist_over_jc"
#define K_GAMELIVELIST_OVER_BD        @"gamelivelist_over_bd"
#define K_GAMELIVELIST_OVER_ZC        @"gamelivelist_over_zc"

#define K_GAMELIVELIST_FUTURE_JC      @"gamelivelist_future_jc"
#define K_GAMELIVELIST_FUTURE_BD      @"gamelivelist_future_bd"
#define K_GAMELIVELIST_FUTURE_ZC      @"gamelivelist_future_zc"

#define K_GAMELIVELIST_FAVORITE_JC    @"gamelivelisttype_favorite_jc"
#define K_GAMELIVELIST_FAVORITE_BD    @"gamelivelisttype_favorite_bd"
#define K_GAMELIVELIST_FAVORITE_ZC    @"gamelivelisttype_favorite_zc"
#define K_GAMELIVELIST_FAVORITE_BASKETBALLPOINT @"gamelivelisttype_favorite_basketballpoint"

#define K_GAMELIVELIST_DATA           @"gamelivelist_data"

#define K_GAMELIVELIST_SECTION        @"gamelivelist_section"
//竞彩足球最后一次投注是否单关
#define K_JCZQ_LASTPAY_ISSINGLE      @"jczq_lastpay_issingle"

//世界杯
#define K_GAMELIVELIST_WORLDCUP @"gamelivelist_worldcup_cache"
#define K_WORLDCUP_FAVORITE           @"worldcup_favorite"
#define K_GAMELIVELIST_FAVORITE_WORLDCUP @"gamelivelisttype_favorite_worldcup"

//#define K_GAMELIVELIST_TYPE_JC     @"gamelivelisttype_jc"
//#define K_GAMELIVELIST_TYPE_BD     @"gamelivelisttype_bd"
//#define K_GAMELIVELIST_TYPE_ZC     @"gamelivelisttype_zc"
//奖金优化投注createType
#define  K_PAYBONUS_CREATETYPE        @"JC_OPTIMIZE"


#define  K_REQUEST_PAGESIZE         10
#define  K_PLANCONTENT_CELL_HEIGHT  100
#define  K_DEFAULT_SECOND_LABEL_X   90

#define  K_CONDITION

#define   K_JSZQBETCONTENTRESIZE_WX 20.0

#define  K_NOTIFINE_UPDATA_COOL        @"CHOOSENUMCOOL"
#define  K_NOTIFINE_UPDATA_LOST        @"CHOOSENUMLOST"
#define  K_NOTIFINE_TREND              @"CHOOSENUMTREND"

#define  K_KEY_LASTPLAN_FAST3          @"LASTPLANCONTENT"
#define  K_KEY_LASTPLAN_NEWFAST3       @"NEWLASTPLANCONTENT"

//cache used
#define K_KEY_DISCOVERY                 @"discovery"
#define K_KEY_DISCOVERY_ADVID           @"discovery_advID"
#define K_KEY_MHLOTTERY_ADVID           @"myLottery_advID"
#define K_KEY_CACHE_ALLORDER            @"allOrder"
#define K_KEY_CACHE_START_SHARE         @"startShare"
#define K_KEY_CACHE_SHARE               @"share"
#define K_KEY_CACHE_FOLLOW              @"follow"
#define K_KEY_CACHE_WAITING             @"waitingf"

#define K_KEY_CACHE_LOTTERY_DATA        @"lotteryData"
#define K_KEY_CACHE_HOME_LOTTERY        @"homeLottery"
#define K_KEY_CACHE_HOME_COMPULSORY_LOTTERY        @"homeCompulsoryLottery"
#define K_KEY_CACHE_HOME_TOP_LOTTERY    @"homeTopLottery"
#define K_KEY_CACHE_HOME_DATA           @"homeData"
#define K_KEY_CACHE_WON                 @"wonList"
#define K_KEY_CACHE_NOTPAID             @"notPaidList"
#define K_KEY_CACHE_NINE_FOURTEEN_MATCH_DATA  @"ninefourteenData"
#define K_KEY_CACHE_ADVERTISEMENT      @"advertisement"

#define K_KEY_BDNEWUSERMISSION         @"cache_bdnewusermission"



#define K_KEY_CACHE_MESSAGE_READ_FLAG  @"message_read_flag"
#define K_KEY_CACHE_MESSAGECENTER      @"MessageCenterCacheData"

#define K_CLOSEAPP_PUSH_DATA           @"closeApp_PushData"

//lottery user guide
#define K_KEY_USERGUIDE_FASTTREND      @"userguide_fast_trend"

#define K_KEY_USERGUIDE_IMAGENAME      @"userguide_imagename"

#define K_KEY_USERGUIDE_NUMGROUNDA      @"userguide_number_ground_a"
#define K_KEY_USERGUIDE_NUMGROUNDb      @"userguide_number_ground_b"

#define K_KEY_USERGUIDE_FASTGROUNDA      @"userguide_fast_ground_a"
#define K_KEY_USERGUIDE_FASTGROUNDb      @"userguide_fast_ground_b"

#define K_KEY_USERGUIDE_ATHLETICS       @"userguide_athletics"
#define K_KEY_USERGUIDE_BASKETMIXSINGLE @"userguide_basket_mix_single"
#define K_KEY_USERGUIDE_GAMELIVE        @"userguide_gamelive"

#define K_KEY_USERGUIDE_HOME            @"userguide_home"
#define K_KEY_USERGUIDE_MISSION         @"userguide_mission"

#define K_KEY_REWARD_TOTALPRIZE         @"reward_totalprize"

#define  K_KEY_BIG_PAGESIZE            [NSString stringWithFormat:@"%i",20]
#define  K_KEY_SMALL_PAGESIZE          [NSString stringWithFormat:@"%i",10]

#define K_KEY_TOST_DELAY_SECONDE        2.0

#define K_KEY_PASSWD_KEY                @"159"

#define K_KEY_LANTERN_STOP_TIME         @"2014-03-01 00:00:00"

#define K_URL_SHAREICON                 @"http://static.event.lecai.com/proxyapi/share/bdcp_logo.png"

#define  K_KEY_PARAMETER               [NSString stringWithFormat:@"version=%@&device=%@",K_CLIENT_VERSION,[LTools getObjectFromSystemKey:K_KEY_DEVICE_ID]]

//------------------------------资讯保存宏
#define KEY_TITLE_SEQUEUE @"message__title__sequeue___"

//------------------------------ 一些方便的宏
#define  UNDEFIND __attribute__((unavailable("这个属性没有定义")));


