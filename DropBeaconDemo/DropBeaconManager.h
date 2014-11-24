//
//  DropBeaconManager.h
//  iOS-SDK
//
//  Created by 杨 世伟 on 14-7-9.
//  Copyright (c) 2014年 杨 世伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBScanner.h"
#import "DBBeaconRegion.h"

@class DropBeaconManager;


@protocol DropBeaconManagerDelegate <NSObject>

@required
- (void)isInCoveredArea;
- (void)isEnteringCoveredArea;
- (void)isLeavingCoveredArea;
- (void)didDiscoverDBBeaconRegionInForeground : (DBBeaconRegion *) dbBeaconRegion;
- (void)didDiscoverDBBeaconRegionInBackground : (DBBeaconRegion *) dbBeaconRegion;
- (void)didRangedDBBeaconRegions : (NSArray *) dbBeaconRegions;
- (void)didFailScanBeaconsDuedToLocationServiceUnavailable;
- (void)didFailScanBeaconsDuedToBLEUnsupport;
- (void)didFailLoadingListForMonitoring;
- (void)didFailAuthenticationByInvalidTokenOrSecret;
- (void)didFailAuthenticationByNetworkUnavailable;
@end

@interface DropBeaconManager : NSObject <DBScannerDelegate>
@property (nonatomic , strong) id<DropBeaconManagerDelegate> delegate;

+ (instancetype)sharedManager;
- (void) setAuthenticationInfo : (NSString *)authToken andSecret : (NSString *)authSecret;
- (void) startScan;
@end
