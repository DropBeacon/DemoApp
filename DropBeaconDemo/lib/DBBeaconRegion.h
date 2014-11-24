//
//  DBBeaconRegion.h
//  iOS-SDK
//
//  Created by 杨 世伟 on 14-7-9.
//  Copyright (c) 2014年 杨 世伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLBeaconRegion.h>

/**
 *  一个DBBeaconRegion代表了一个DropBeacon设备。从iBeacon协议的角度来说，它包含了以下基本
 *  属性：
 *  
 *  - `uuid` - 用以确定周边一定范围的DropBeacon设备
 *  - `major` - 在uuid的基础上，进一步明确DropBeacon设备的范围
 *  - `minor` - 在uuid和major的基础上，最终确定一个DropBeacon设备
 *  - `udid` - 一个DropBeaconRegion的唯一设备ID，除此udid之外，uuid、major、minor三者的
 *  组合也可以唯一的确定一个DropBeaconRegion设备。
 *  - `deviceName` - DropBeacon设备在开发平台上设置的名字
 *  - `getAccuracy` - 与用户终端之间的距离
 *
 *  以及四个与平台配置相关的业务属性：
 *
 *  - `valid_distance` - 有效距离
 *  - `valid_suspend_time` - 停留时间
 *  - `renotify_interval` - 通知间隔
 *  - `isInValidRange` - 是否在有效距离内
 *
 *  该对象一般由设置DropBeaconManager的delegate并实现DropBeaconManagerDelegate回调获得。
 *
 */
@interface DBBeaconRegion : NSObject

////////////////////////////////////////////////////////////////////////////////
/// @name 基本属性
////////////////////////////////////////////////////////////////////////////////

/**
 *  返回uuid（只读）
 */
@property (nonatomic , readonly) NSUUID * uuid;

/**
 *  返回major（只读）
 */
@property (nonatomic , readonly) int major;

/**
 *  返回minor（只读）
 */
@property (nonatomic , readonly) int minor;

/**
 *  返回唯一设备ID（只读）
 */
@property (nonatomic , readonly) NSString * udid;

/**
 *  设备名称（只读）
 *
 *  @discussion 该设备名称与DropBeacon开发平台上配置的一致
 */
@property (nonatomic, readonly) NSString * deviceName;

/**
 *  获取当前DBBeaconRegion与用户设备之间的距离
 *
 *  @return 距离（单位为米）
 */
- (double)getAccuracy;


////////////////////////////////////////////////////////////////////////////////
/// @name 平台相关
////////////////////////////////////////////////////////////////////////////////

/**
 *  有效距离（只读）
 *
 *  @discussion 与开放平台上对应DropBeacon设备的配置一致
 */
@property (nonatomic , readonly) int valid_distance;

/**
 *  有效停留时间（只读）
 *
 *  @discussion 与开放平台上对应DropBeacon设备的配置一致
 */
@property (nonatomic , readonly) int valid_suspend_time;

/**
 *  重复通知间隔（只读）
 *
 *  @discussion 与开放平台上对应DropBeacon设备的配置一致
 */
@property (nonatomic , readonly) int renotify_interval;

/**
 *  是否在有效距离内
 */
@property (nonatomic) BOOL isInValidRange;



@end
