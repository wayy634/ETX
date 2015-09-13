//
//  LTools.h
//  LeHeCai
//
//  Created by HXG on 11-9-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"
#import <QuartzCore/QuartzCore.h>
#import "URequest.h"
#import "KCommon.h"
#import "LCAPIResult.h"
#import "XMBottomMenuV.h"
#import "MBProgressHUD.h"


@class SportsMatchSchedule, UserInfo, BdLotteryEntranceConfig;
@interface LTools : NSObject {

}

#pragma mark -
#pragma mark system Memory
//系统可用内存
+ (double)availableMemory;

//已使用的内存
+ (double)usedMemory;                                       

#pragma mark -
#pragma mark Save system default file
//安全缓存(不受应用删除限制)
+ (void)setSecretObjectFromSystem:(id)object key:(NSString *)key;

+ (id)getSecretObjectFromSystemKey:(NSString *)key;

//缓存本地
+ (void)setObjectFromSystem:(id)object key:(NSString *)key;

//读取本地
+ (id)getObjectFromSystemKey:(NSString *)key;

//try save class
+ (void)setClassSystem:(id)_class key:(NSString*)key;
+ (id)getClassFromSystem:(NSString*)key;

//全局dictionary
+ (id)getWholeDicForKey:(NSString*)key;
+ (void)setWholeDicValue:(id)object key:(NSString*)key;

+ (BOOL)isAPIJsonError:(LCAPIResult*)_object;
+ (NSString *)checkAPIJsonIsError:(LCAPIResult *)root;
#pragma mark -
#pragma mark Save file
//写文件本地
+ (void)writeFileWithContent:(NSString *)text
					fileName:(NSString *)fileName
					 isCover:(BOOL)isCover;

//读取文件本地
+ (NSString *)readFileFromFileName:(NSString *)fileName;

+ (NSMutableArray *)getAppData;

#pragma mark -
#pragma mark Methods
//encodeing字符串
+ (NSString *)encodingString:(NSString *)text;

//base64
+ (NSData *)base64Decode:(NSString *)string;
+ (NSString *)base64Encode:(NSData *)data;

//删除特殊字符串
+ (NSMutableString *)deleteString:(NSString *)text;

//从小到大排序
+ (void)arrange:(NSMutableArray *)indexArray objectArray:(NSMutableArray *)objectArray;

//冒泡排序 从大到小
+ (void)MPArrange:(NSMutableArray *)data count:(int)arrayCount;

//冒泡排序 从小到大
+ (void)MPArrangeFromBigToSmall:(NSMutableArray *)data count:(NSInteger)arrayCount;

//升级应用程序
+ (void)updateApp:(NSString *)url;

//删除本地图片文件夹
+ (void)checkLocationImgAndRemove;

//判断输入的text格式是否正确,是否符合正则表达式regExp的标准
+ (BOOL)isCorrectInputText:(NSString *)text regExp:(NSString *)regExp;

//去掉空格
+ (NSString *)trim:(NSString *)string;
+ (NSString *)trimManual:(NSString *)string;

//添加字符串
+ (NSString *)oldStrings:(NSString *)string addString:(NSString *)addString;

//查找本地图片是否存在
+ (BOOL)getImageFromLocal:(NSString*)name;

//颜色转译
+ (UIColor *)colorWithHexString:(NSString *)hexString;

#pragma mark -
#pragma mark UI
//第三方loadingV show方法
+ (void)showLoadingVOnTargetView:(UIView *)targetView_ isLock:(BOOL)isLock_ animation:(BOOL)animation_;

//第三方loadingV hide方法
+ (void)hideLoadingVOnTargetView:(UIView *)targetView_ animation:(BOOL)animation_;

// 淡进淡出方法
+ (void)animationEaseInEaseOut:(CALayer *)layer;

// 将UIview改为通用的圆角框
+ (void)roundedRectangleView:(UIView *)view corner:(float)_corner width:(float)_width color:(UIColor *)_color;
+ (void)roundedRectangleView:(UIView *)view corner:(float)_corner color:(UIColor *)_color;
+ (void)roundedRectangleView:(UIView *)view;
+ (void)roundedRectangleViewWithShadow:(UIView *)view;
+ (void)roundedRectangleView:(UIView *)_view  color:(UIColor *)_color;
+ (void)roundedRectangleView:(UIView *)_view  color:(UIColor *)_color radius:(float)_radius;

//设置button状态图片
+ (void)setButton:(UIButton *)button
	  normalColor:(UIColor *)normalColor
 highlightedColor:(UIColor *)highlightColor;

+ (void)setButton:(UIButton *)button
	  normalImage:(NSString *)normalImageName
 HighlightedImage:(NSString *)HighlightedImage
	 pressedImage:(NSString *)pressedImageName;

+ (void)setButton:(UIButton *)button
	  normalImage:(NSString *)normalImageName
	 pressedImage:(NSString *)pressedImageName;

+ (void)setButton:(UIButton *)button
   normalImageMem:(UIImage *)normalImageName
  pressedImageMem:(UIImage *)pressedImageName;


//简易alert提示
+ (void)alertWithTitle:(NSString *)title
				   msg:(NSString *)msg;

+ (void)alertWithTitle:(NSString *)title msg:(NSString *)msg baseController:(UIViewController *)baseController;

+ (void)showAlertWithMessage:(NSString *)message completionBlock:(void(^)(NSInteger btnIndex))block;

+ (void)XMShowAlertWithTitle:(NSString *)title_ msg:(NSString *)msg_ specialDataArray:(NSArray *)dataArray_ cancelButtonTitle:(NSString *)cancelButtonTitle_ confirmButtonTitle:(NSString *)confirmButtonTitle_ cancelButtonBlock:(void (^)(void))cancelBlock_ confirmButtonTitle:(void (^)(void))confirmBlock_;

// view animation
+ (void)animationView:(UIView *)aView
			fromFrame:(CGRect)fromFrame
			  toFrame:(CGRect)toFrame
				delay:(float)delayTime
			 duration:(float)durationTime;

+ (void)animationView:(UIView *)aView
				fromY:(float)fromY
				  toY:(float)toY
			 duration:(float)durationTime;

+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
				delay:(float)delayTime
			 duration:(float)durationTime;

+ (void)animationView:(UIView *)aView
				fromX:(float)fromX
				fromY:(float)fromY
				  toX:(float)toX
				  toY:(float)toY
              toScale:(float)toScale  
              toAlpha:(float)toAlpha
				delay:(float)delayTime
			 duration:(float)durationTime;

//覆盖view
+ (UIView *)getCoverView;

#pragma mark -
#pragma mark HTTP
//restKit请求方法
+ (void)startAsynchronousUrl:(NSString *)_url
                   parameter:(NSMutableDictionary *)_parameter
                      method:(NSString *)_method
                    delegate:(id)_delegate
                 allowCancel:(BOOL)_allowCancel
                 mappingName:(NSString *)_mappingName
                urlCacheMode:(BOOL)_urlCacheMode
              finishSelector:(SEL)_finishSEL
                failSelector:(SEL)_failSEL
             timeOutSelector:(SEL)_timeOutSEL;

// http 网络链接部分 ------------------------------------
// 返回一个网络链接的队列
+ (ASINetworkQueue *)getNetWorkQueue;

// 设置接收图片方法，依据图片名称
+ (UIImage *)getImage:(NSString *)imageName defaultImageName:(NSString *)defultName;
+ (UIImage *)setRespondView:(UIView *)theView defaultImageName:(NSString *)defultName imageName:(NSString *)name;

// 返回上级页面中未完成的request
+ (NSMutableArray *)getUnfinishedUrequest;
+ (NSMutableArray *)getUnfinishedUrequestForBecame;

// 网络异步链接方法
+ (void)startAsynchronous:(URequest *)request;
+ (void)startAsynchronous:(URequest *)request withController:(UIViewController *)controller;
+ (void)startAsynchronous:(URequest *)request withController:(id)controller withView:(UIView *)view;
//+ (void)startSynchronous:(URequest *)request withController:(UIViewController *)controller;

// 挂起返回联网
+ (void)beCameStartAsynchronous:(URequest *)request withController:(id)controller;

// 中断删除request
+ (void)cancelRequest:(URequest *)request;

// 删除跳转页面后上级页面中未完成的request
+ (void)cancelUnfinishedRequest;
+ (void)cancelUnfinishedRequestForBecame;

// 网络队列链接方法 array-网络队列, maxOperationCount-同时的最大网络链接数, 所属的viewController
+ (void)startQueue:(NSMutableArray *)array 
       setMaxCount:(int)count 
    withController:(id)controller
setCancelAllOnFail:(BOOL)isUse;

// 返回一个网络队列数组
+ (NSMutableArray *)getQueueArray;

// 返回联网是否出现错误
+ (BOOL)isJsonError:(NSDictionary *)root;

// 返回联网数据错误消息
+ (NSString *)checkJsonIsError:(NSDictionary *)root;
#pragma mark -
#pragma mark MD5 | Sign | time stamp | mac address
// 加密、签名、时间戳、mac地址
+ (NSString *)md5:(NSString *)source;
+ (NSString *)timeStamp;
+ (NSString *)signString:(NSString *)source;
+ (NSString *)upperMD5ForImg:(NSString *)source;
+ (NSString *)upperMD5ForImgNoSuffix:(NSString *)source;
+ (NSString *)macAddress;

//服务器与本地时间差
+ (void)mathTimeDelay:(double)_serverTime;

#pragma mark -
#pragma mark Application data
+ (void)popController;
//pop
+ (void)popControllerAnimated:(BOOL)animated;

//poptoRoot
+ (void)popToRootViewControllerAnimated:(BOOL)animated;

//获取当前使用的navigation
+ (void)pushController:(UIViewController *)controller animated:(BOOL)animated;
+ (void)pushControllerFromURLScheme:(UIViewController *)controller animated:(BOOL)animated;

//底部bottomMenuV
+ (XMBottomMenuV *)getBottomMenuV;

//底部bottom rootViewController selecte
+ (void)bottomMenuVSelected:(XMBottomMenuVRootType)_type animation:(BOOL)animation_;

//计算label 的size
+ (CGSize)sizeForText:(UILabel *)label_ isLabelWidth:(BOOL)_isLabelWidth;

//系统版本
+ (BOOL)isGreatherThanIOS7;

//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image_ scaledToSize:(CGSize)newSize_;

//时间转换
+ (NSString *)changeTimeType:(NSString *)type_ time:(long)time_;


//更换学校清除缓存数据
+ (void)clearCacheDataFromChangeCollege;

//网络连接失败show
+ (void)showNetWorkFail:(UIView *)view_ image:(NSString *)image_ msg:(NSString *)msg_;

//网络连接失败disappear
+ (void)disappearNetWorkFail:(UIView *)view_;

//toast 不连续显示
+ (void)setKisShow:(BOOL)_isShow;

//toast
+ (BOOL)getKIsShow;

+ (void)setUpdataShow:(BOOL)updataShow_;

+ (BOOL)getKUpdataShow;

+ (NSString *)getURL:(NSString *)_url;
@end
