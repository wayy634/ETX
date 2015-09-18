//
//  USHSQAModel.h
//  USHSAPP-GEDU
//
//  Created by Ray on 8/1/15.
//  Copyright (c) 2014-2015 JessieRay Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPSDayModel : NSObject
// Memo Model
//Top Question
@property (nonatomic, assign)int        EPID;
@property (nonatomic, assign)int        EPPID;
@property (nonatomic, strong)NSString   *EPParkingTitle;
@property (nonatomic, strong)NSString   *EPParkingFee;
@property (nonatomic, strong)NSString   *EPParkingBeginTime;
@property (nonatomic, strong)NSString   *EPParkingCurrentTime;



@end
