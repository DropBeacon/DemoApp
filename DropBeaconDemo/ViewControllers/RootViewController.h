//
//  RootViewController.h
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropBeaconManager.h"

@interface RootViewController : UIViewController<DropBeaconManagerDelegate>

@property (nonatomic,retain) NSMutableDictionary *poppedDic;
@property (nonatomic,retain) NSMutableDictionary *bgPoppedDic;

@end
