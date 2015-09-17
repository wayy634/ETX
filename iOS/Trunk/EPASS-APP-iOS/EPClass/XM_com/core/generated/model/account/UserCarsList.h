//
//  UserCarsList.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/17.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserCar.h"

@interface UserCarsList : NSObject

@property (nonatomic,strong)NSArray *userCarList;
@property (nonatomic,strong)UserCar *userCarListArray;

@end
