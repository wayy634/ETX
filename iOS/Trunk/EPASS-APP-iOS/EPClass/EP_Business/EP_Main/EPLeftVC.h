//
//  EPLeftVC.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/13.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "LCCustomBaseVC.h"


#define EPLEFTTABLEVIEWCELL_HEIGHT   40

typedef NS_ENUM(NSInteger, EPLeftMenuType) {
    EPLeftMenuType_Account        = 0,
    EPLeftMenuType_Today          = 1,
    EPLeftMenuType_Recharge       = 2,
    EPLeftMenuType_BindingDevice  = 3,
    EPLeftMenuType_Order          = 4,
    EPLeftMenuType_MyDevice       = 5,
    EPLeftMenuType_Set            = 6
};



@interface EPLeftVC : LCCustomBaseVC

@property(nonatomic,strong)NSMutableDictionary      *mRootVCDic;//根视图的字典

@end
