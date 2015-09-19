//
//  EPSDayModel.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSDayModel : NSObject

@property (nonatomic, assign)int        EPSID;
@property (nonatomic, assign)int        EPSParkingSum;
@property (nonatomic, assign)int        EPSTimeSim;
@property (nonatomic, strong)NSString   *EPSDayTitle;
@property (nonatomic, strong)NSString   *EPSDayFee;
@property (nonatomic, strong)NSString   *EPSDayType;


@end
