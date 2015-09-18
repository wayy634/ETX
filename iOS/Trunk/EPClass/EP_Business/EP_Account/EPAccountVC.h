//
//  EPAccountVC.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/14.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "LCCustomBaseVC.h"
#import "EPLoginTextField.h"
typedef NS_ENUM(NSInteger, EPAccountType){
    EPAccountTypeLogin = 0,
    EPAccountTypeRegist = 1,
    EPAccountTypeAccount = 2
};

@interface EPAccountVC : LCCustomBaseVC<UITextFieldDelegate,EPLoginTextFieldDelegate>{

    EPAccountType mType;
}

@end
