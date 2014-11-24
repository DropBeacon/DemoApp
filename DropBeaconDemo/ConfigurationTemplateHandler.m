//
//  ConfigurationTemplateHandler.m
//  DropBeaconDemo
//
//  Created by niexin on 7/31/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "ConfigurationTemplateHandler.h"
#import "DBBeaconRegion.h"

#define REGION_TEMPLATE_PATH [NSString stringWithFormat:@"%@/Documents/configTemp.plist",NSHomeDirectory()]
static ConfigurationTemplateHandler * sharedHandler = nil;

@implementation ConfigurationTemplateHandler

+ (instancetype) sharedHandler
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHandler = [[ConfigurationTemplateHandler alloc] initHandler];
    });
    return sharedHandler;
}
- (ConfigurationTemplateHandler *)initHandler
{
    if (self = [super init]) {
        
    }
    return self;
}

- (instancetype) init
{
    return nil;
}

- (NSNumber *)fetchTemplateTypeWithDBBeaconRegion:(DBBeaconRegion *)region
{
    NSString *udid = region.udid;
    if ([[NSFileManager defaultManager] fileExistsAtPath:REGION_TEMPLATE_PATH]) {
        NSDictionary *savedDic = [NSDictionary dictionaryWithContentsOfFile:REGION_TEMPLATE_PATH];
        if ([savedDic.allKeys containsObject:udid]) {
            return [savedDic objectForKey:udid];
        }
    }else{
        return nil;
    }
    return nil;
}

- (void)saveWithDBBeaconRegion:(DBBeaconRegion *)region andTemplateType:(NSNumber *)type
{
    NSMutableDictionary *savedDic = [NSMutableDictionary dictionaryWithContentsOfFile:REGION_TEMPLATE_PATH];
    if (savedDic && savedDic.allKeys.count) {
        [savedDic setObject:type forKey:region.udid];
    }else{
        savedDic = [NSMutableDictionary dictionaryWithDictionary:@{region.udid: type}];
    }
    [savedDic writeToFile:REGION_TEMPLATE_PATH atomically:YES];
}

- (void)clearDBBeaconRegion:(DBBeaconRegion *)region
{
    NSMutableDictionary *savedDic = [NSMutableDictionary dictionaryWithContentsOfFile:REGION_TEMPLATE_PATH];
    if (savedDic && savedDic.allKeys.count) {
        if ([[savedDic allKeys] containsObject:region.udid]) {
            [savedDic removeObjectForKey:region.udid];
            [savedDic writeToFile:REGION_TEMPLATE_PATH atomically:YES];
        }else{
            return;
        }
    }else{
        return;
    }
}


@end
