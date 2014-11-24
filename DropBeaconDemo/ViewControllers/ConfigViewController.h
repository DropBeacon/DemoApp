//
//  ConfigViewController.h
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@class DBBeaconRegion;
@interface ConfigViewController : UIViewController

@property (nonatomic,weak) RootViewController *rootVC;
@property (nonatomic,retain) DBBeaconRegion *region;

@end
