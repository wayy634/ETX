//
//  Device.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

//addtime: 1441849902,
//bindtime: 1441849902,
//dataid: 1,
//deviceid: "0435854",
//isbind: 0,
//status: 0,
//uid: 1

@interface Device : NSObject

/*
 *创建时间
 */
@property(nonatomic,assign)long                addtime;
/*
 *绑定时间
 */
@property(nonatomic,assign)long                bindtime;
/*
 *id
 */
@property(nonatomic,assign)long                dataid;

/*
 *设备Id
 */
@property(nonatomic,strong)NSMutableString     *deviceid;
/*
 *id
 */
@property(nonatomic,assign)int                isbind;
/*
 *id
 */
@property(nonatomic,assign)int                status;
/*
 *id
 */
@property(nonatomic,assign)long               uid;

@end
