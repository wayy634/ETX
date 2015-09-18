//
//  EPLeftVC.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "LCCustomBaseVC.h"


#define EPLEFTTABLEVIEWCELL_HEIGHT   50

typedef NS_ENUM(NSInteger, EPLeftMenuType) {
    EPLeftMenuType_Today          = 0,
    EPLeftMenuType_Recharge       = 1,
    EPLeftMenuType_BindingDevice  = 2,
    EPLeftMenuType_Order          = 3,
    EPLeftMenuType_MyDevice       = 4,
    EPLeftMenuType_Account        = 5
};



@interface EPLeftVC : LCCustomBaseVC

@property(nonatomic,strong)NSMutableDictionary      *mRootVCDic;//根视图的字典

@end