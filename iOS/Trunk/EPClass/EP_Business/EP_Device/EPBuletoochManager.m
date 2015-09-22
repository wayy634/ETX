//
//  EPBuletoochManager.m
//  EPASS-APP-iOS
//
//  Created by chenzb on 15/9/21.
//  Copyright (c) 2015年 Jeanne. All rights reserved.
//

#import "EPBuletoochManager.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface EPBuletoochManager ()<CBCentralManagerDelegate,CBPeripheralDelegate>

@property(nonatomic,strong)CBCentralManager   *mBuletoochManager;
@property(nonatomic,strong)NSMutableArray     *mPeripheralArray;
@property(nonatomic,strong)CBPeripheral       *mLinkPeripheral;

@end

@implementation EPBuletoochManager

+ (EPBuletoochManager *)sharedBluetoochManager {
    static EPBuletoochManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[EPBuletoochManager alloc] init];
    });
    return _sharedManager;
}

- (void)openScan {
    if (!self.mBuletoochManager) {
        self.mBuletoochManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.mPeripheralArray = [NSMutableArray array];
    }
    [self.mPeripheralArray removeAllObjects];
    [self.mBuletoochManager scanForPeripheralsWithServices:nil options:nil];
}

- (void)closeScan {
    if (self.mBuletoochManager) {
        [self.mBuletoochManager stopScan];
    }
}

- (void)closeSearch {
    if (self.mBuletoochManager) {
        [self.mBuletoochManager cancelPeripheralConnection:self.mLinkPeripheral];
    }
}

#pragma mark-----------CBCentralManagerDelegate--------------

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"state : %li",central.state);
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    if(![self.mPeripheralArray containsObject:peripheral])
        [self.mPeripheralArray addObject:peripheral];
    
    NSLog(@"dicoveredPeripherals:%@", self.mPeripheralArray);
}

-(BOOL)connect:(CBPeripheral *)peripheral {
    NSLog(@"connect start");
    return YES;
}

@end
