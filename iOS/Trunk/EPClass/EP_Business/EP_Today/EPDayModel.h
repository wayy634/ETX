//
//  EPDayModel.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPDayModel : NSObject
// Memo Model
//Top Question
@property (nonatomic, assign)int        EPID;
@property (nonatomic, assign)int        EPPID;
@property (nonatomic, strong)NSString   *EPParkingTitle;
@property (nonatomic, strong)NSString   *EPParkingFee;
@property (nonatomic, strong)NSString   *EPParkingBeginTime;
@property (nonatomic, strong)NSString   *EPParkingCurrentTime;



@end
