//
//  EPBuletoochManager.h
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/21.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EPBuletoochManager <NSObject>

- (void)scanMappingDevice:(id)device_;

@end

@interface EPBuletoochManager : NSObject

+ (EPBuletoochManager *)sharedBluetoochManager;

- (void)openScan;

- (void)closeScan;

- (void)createLink;

- (void)closeLink;

@end
