//
//  XMThreadCountDownManager.h
//  XiaoMai
//
//  Created by Jeanne on 15/5/4.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>
//#define K_XMTHREADCOUNTDOWNMANAGER_CLASS    @"XMThreadCountDown_Class_Name"
//#define K_XMTHREADCOUNTDOWNMANAGER_CLASS_FUCTION @"XMThreadCountDown_Class_Fuction"

@interface XMThreadCountDownManager : NSObject
@property (nonatomic, assign)__block dispatch_queue_t        mQueue;
@property (nonatomic, assign)__block dispatch_source_t       mTimer;

//线程单利
+ (XMThreadCountDownManager *)sharedXMThreadCountDownManager;

//添加到线程
- (void)addToThread:(id)class_ fuction:(SEL)sel_;

//添加到线程检测去重
- (void)addCheckToThread:(id)class_ fuction:(SEL)sel_;

//从线程中删除
- (void)removeFromThread:(id)class_ fuction:(SEL)sel_;

//删除所有线程中的元素
- (void)removeAll;

//启动线程
- (void)runThread;

//根据条件启动线程
- (void)resumeThread;

//暂停线程
- (void)suspendThread;
@end
