//
//  UserGarage.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

//addtime: 1442284696,
//area: 1,
//dataid: 1,
//estate: "0435854",
//isrent: 1,
//location: "海淀",
//rentfee: "98RMB",
//type: 1,
//uid: 1

@interface UserGarage : NSObject

/*
 *创建时间
 */
@property(nonatomic,assign)long                addtime;

/*
 *
 */
@property(nonatomic,assign)long                area;

/*
 *
 */
@property(nonatomic,strong)NSMutableString     *estate;

/*
 *carId
 */
@property(nonatomic,assign)long                dataid;

/*
 *车牌
 */
@property(nonatomic,assign)int                 isrent;

/*
 *
 */
@property(nonatomic,strong)NSMutableString     *location;

/*
 *
 */
@property(nonatomic,strong)NSMutableString     *rentfee;

/*
 *
 */
@property(nonatomic,assign)int                 type;

/*
 *
 */
@property(nonatomic,assign)long                uid;



@end
