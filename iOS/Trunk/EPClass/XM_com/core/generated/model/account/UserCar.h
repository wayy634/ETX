//
//  UserCar.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/15.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

//addtime: 1441849831,
//boughttime: "2015年9月12日",
//brand: "一汽大众迈腾",
//engineid: "246467K",
//id: 1,
//licenceid: "340104198704141510",
//licencename: "杨海",
//lpn: "京P-S3551",
//uid: 1


@interface UserCar : NSObject

/*
 *创建时间
 */
@property(nonatomic,assign)long                addtime;

/*
 *购买时间
 */
@property(nonatomic,strong)NSMutableString     *boughttime;

/*
 *车型
 */
@property(nonatomic,strong)NSMutableString     *brand;

/*
 *carId
 */
@property(nonatomic,assign)long                dataid;

/*
 *车牌
 */
@property(nonatomic,strong)NSMutableString     *engineid;

/*
 *购买时间
 */
@property(nonatomic,strong)NSMutableString     *licenceid;

/*
 *
 */
@property(nonatomic,strong)NSMutableString     *licencename;

/*
 *购买时间
 */
@property(nonatomic,strong)NSMutableString     *lpn;

/*
 *购买时间
 */
@property(nonatomic,assign)long                uid;

@end
