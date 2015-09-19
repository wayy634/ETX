//
//  EPCarGarageModel.h
//  EPASS-APP-iOS
//
//  Created by Ray on 15/9/14.
//  Copyright (c) 2015年 JessieRay Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPCarGarageModel : NSObject

@property (nonatomic, assign)int        EPCarID;
@property (nonatomic, assign)int        EPGarageID;
//Car Model
@property (nonatomic, strong)NSString   *EPCarDriveNO;
@property (nonatomic, strong)NSString   *EPCarEngineNO;
@property (nonatomic, strong)NSString   *EPCarOwner;
@property (nonatomic, strong)NSString   *EPCarBrand;
@property (nonatomic, strong)NSString   *EPCarLPN;
@property (nonatomic, strong)NSString   *EPCarBoughtTime;

//Garage Model
@property (nonatomic, strong)NSString   *EPGarageEstate;
@property (nonatomic, strong)NSString   *EPGarageLoc;
@property (nonatomic, strong)NSString   *EPGarageType;
@property (nonatomic, strong)NSString   *EPGarageIsPrivate;
@property (nonatomic, strong)NSString   *EPGarageIsRent;
@property (nonatomic, strong)NSString   *EPGarageRentFee;

@end
