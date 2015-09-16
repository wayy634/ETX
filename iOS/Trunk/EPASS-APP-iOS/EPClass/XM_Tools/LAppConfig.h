//
//  LAppConfig.h
//  LeHeCai
//
//  Created by HXG on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

//#import "LTools.h"
//网络传输和服务器缓存时间差
#define K_TIME_DELAY 5
//navigation参数 backgroundImageView
#define K_NAV_BAR_BACKGROUND                @"top_bg.png"
#define K_NAVIGATION_X                      0
#define K_NAVIGATION_Y                      46
#define K_NAVIGATION_WIDTH                  [UIScreen mainScreen].bounds.size.width
#define K_NAVIGATION_HEIGHT                 ([UIScreen mainScreen].bounds.size.height-20-51-46)
#define K_NAVIGATION_WITHOUT_BOTTOM_HEIGHT  ([UIScreen mainScreen].bounds.size.height-20-44)
#define K_LCROOTVC_NAVIGATIONBAR_HEIGHT 46
#define K_SYSTEM_BAR                        ([[[UIDevice currentDevice] systemVersion] intValue] >= 7 ? 20.0 : 0.0)
#define K_ANIMATION_SYSTEM_BAR              ([[[UIDevice currentDevice] systemVersion] intValue] >= 7 ? 0.0 : 20.0)
#define K_NAVIGATION_BAR_HEIGHT             (44)


#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242,2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define AUTOSIZE(i)                 ceil(((([UIScreen mainScreen].bounds).size.width*2) / 640) * i) //根据屏幕宽度调整尺寸(以iPhone5尺寸为基准 640)

//默认底部bottom条的height
#define K_BOTTOMMENUVC_HEIGHT  51

// 屏幕宽高、标准组件高度 --------------------
#define K_SCREEN_X                      [UIScreen mainScreen].bounds.origin.x
#define K_SCREEN_Y                      [UIScreen mainScreen].bounds.origin.y
#define K_SCREEN_WIDTH                  ([[[UIDevice currentDevice] systemVersion] intValue] >= 7 ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].applicationFrame.size.width)
#define K_SCREEN_HEIGHT                 ([[[UIDevice currentDevice] systemVersion] intValue] >= 7 ? [UIScreen mainScreen].bounds.size.height : [UIScreen mainScreen].applicationFrame.size.height)
#define K_ANIMATION_TIME                0.2

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
// 使用Localizable.strings文件中字符串方法--------------------
#define STRING(x)                       NSLocalizedString(x, nil)

//　16进制颜色值转化
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define COLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

//font
#define K_FONT_SIZE(size)          [UIFont systemFontOfSize:iPhone6Plus ? (size+1):size]
#define K_BOLD_FONT_SIZE(size)     [UIFont boldSystemFontOfSize:iPhone6Plus ? (size+1):size]

// float
#define K_EPSINON                       (1e-127)
#define IS_ZERO_FLOAT(X)                (X < K_EPSINON && X > -K_EPSINON)


//正则表达式 Regular Expressions
//#define K_REGULAR_PHONE               @"SELF MATCHES '(2[0-9]\\\\d{9})|(13[0-9]|14[0-9]|15[0-9]|18[0-9])\\\\d{8}'"
#define K_REGULAR_PHONE                 @"SELF MATCHES '(1[0-9]|2[0-9])\\\\d{9}'"
#define K_REGULAR_PASSWORD              @"SELF MATCHES '^[0-9a-zA-Z]{6,15}$'"
#define K_REGULAR_PASSWORD_SCREEN       @"SELF MATCHES '^[0-9a-zA-Z][\u4e00-\u9fa5]{6,20}$'"
#define K_REGULAR_VERIFY_CODE           @"SELF MATCHES '^[0-9a-zA-Z]{1,20}$'"
#define K_REGULAR_EMAIL                 @"SELF MATCHES '[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}'"
#define K_REGULAR_INPUT_UBOX_NUMBER     @"SELF MATCHES '[0-9]{1,6}'"
#define K_REGULAR_TELEPHONE_NUM         @"SELF MATCHES '((13[0-9]{1})|(17[0-9]{1})|(15[0-9]{1})|(18[0-9]{1}))+[0-9]{8}'" //筛选手机号码
#define K_NUMBER                        @"SELF MATCHES '^[0-9]*[1-9][0-9]*$'"
#define K_REGULAR_VERIFICATION_CODE     @"SELF MATCHES '[0-9]{4}'"//4位验证码

//条件编译 appstore=2 与 非appstore=1
#define IOS_APPSTOREE                    @"2"//[NSString stringWithFormat:@"%i",[[[LTools getAppData] objectAtIndex:3] intValue]]


#define K_KEY_PROMPT_SECRET             @"prompt_secret"


#define K_KEY_IDFA_UUID                 @"IDFAUUID"
#define K_KEY_DEVICE_ID                 @"device_id"
#define K_KEY_DEFAULT_DEVICE_TOKEN      @"   "
#define K_DEFALUT_GIS_VALUE             @"0"
#define K_KEY_ALIPAY_HELP               @"alipay_help"
#define K_KEY_BANK_ONLINE_HELP          @"bankonline_help"
#define K_KEY_IVR_HELP                  @"ivr_help"
#define K_KEY_CARD_HELP                 @"card_help"
#define K_KEY_HUITONG_HELP              @"huitong_hel"
#define K_KEY_BANK_TRANSFER             @"transfer"
#define K_KEY_HANDSEL_CARD              @"HANDSEL"
#define K_KEY_DELAY_TIME                @"delayTime"
#define K_KEY_SHOW_TEACHER_IMAGE        @"teacherImage"
#define K_KEY_REGISTER_ALREADY          @"regiter_already"

#define K_KEY_NUMBERCHOOSE_ADV          @"numberChooseAdv"
#define K_KEY_FREQUENCYCOMBINATION_EXPLANATION @"mission_help"

#define K_KEY_COMEFROM_OUT_TO_LOCATION  @"target"
#define K_KEY_COMEFROM_OUT_TO_COUNT  @"count"
#define K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE  @"lotteryType"
#define K_KEY_COMEFROM_OUT_TO_PLAYTYPE  @"playType"
#define K_KEY_COMEFROM_OUT_TO_ORDERID  @"orderId"
#define K_KEY_COMEFROM_OUT_TO_ORDERTYPE  @"orderType"
#define K_KEY_COMEFROM_OUT_TO_CATEGORYID  @"categoryId"
#define K_KEY_COMEFROM_OUT_TO_PLAN_ID  @"planId"

#define K_KEY_COMEFROM_PARAM_BACK @"back"

#define K_KEY_SCHOOL                   @"currentSchool"

//debug
#define K_DEBUG_ALERT                   1

//data
#define K_LOCATION_IMG_COUNT            200

//APP delegate
#define APP_DELEGATE     ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#ifndef DEBUG
    #define NSLog(...) {}
#endif

//Request Field
#define XM_KEY_PRODUCT_ID           @"EPASS-APP-iOSMall"

#define UserAgentKey @"User-Agent"
#define UserAgent @"Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110624 Gentoo Firefox/4.0"
#define AcceptKey @"Accept"
#define API_Version @"1.1.0"
#define Accept [@"*/*;version=" stringByAppendingString:API_Version]
#define TimeOut (10)
#define ContentTypeKey @"Content-Type"
#define ContentType @"application/x-www-form-urlencoded"
#define AcceptLanguageKey @"Accept-Language"
#define AcceptLanguage @"zh-cn"
#define SignKey @"sign"
#define UserIdKey @"userId"
#define AppTimeKey @"appTime"
#define UidKey                              @"uid"
#define MobilePhoneKey                      @"mobilePhone"
#define PasswordKey                         @"password"




// XM_ENUM----------------------------------------------------
//配送方式
typedef NS_ENUM(NSInteger, XMORDER_DELIVERYTYPE) {
    XMORDER_DELIVERYTYPE_INVITE     =   0,//自提
    XMORDER_DELIVERYTYPE_DELIVERY   =   1,//送货
    XMORDER_DELIVERYTYPE_ALL        =   2//可选
};
//订单类型
typedef NS_ENUM(NSInteger, XMORDER_DISTRIBUTETYPE) {
    XMORDER_DISTRIBUTETYPE_RDC     =   0,//次日达
    XMORDER_DISTRIBUTETYPE_LDC     =   1 //当日达
};


