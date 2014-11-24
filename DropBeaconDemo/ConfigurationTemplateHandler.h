//
//  ConfigurationTemplateHandler.h
//  DropBeaconDemo
//
//  Created by niexin on 7/31/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DBBeaconRegion;

@interface ConfigurationTemplateHandler : NSObject

+ (instancetype) sharedHandler;
- (NSNumber *)fetchTemplateTypeWithDBBeaconRegion:(DBBeaconRegion *)region;
- (void)saveWithDBBeaconRegion:(DBBeaconRegion *)region andTemplateType:(NSNumber *)type;
- (void)clearDBBeaconRegion:(DBBeaconRegion *)region;

@end
