//
//  DropBeaconManager.h
//  iOS-SDK
//
//  Created by 杨 世伟 on 14-7-9.
//  Copyright (c) 2014年 杨 世伟. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBeaconRegion.h"

/**
 *  DropBeaconManagerDelegate协议定义了一系列方法，这些方法用于从`DropBeaconManager`接
 *  收扫描到的DropBeacon设备或区域。
 *
 *  根据发现的DropBeacon设备或区域，你可以通过它们所映射的业务信息来和APP用户进行交互。一个
 *  DropBeacon设备可以用来代表一个地理位置，也可以代表一个展览物品，这样的业务信息映射是自由
 *  而灵活的。
 *
 *  `DropBeaconManagerDelegate`中的所有方法都是通过主线程回调的。
 */
@protocol DropBeaconManagerDelegate <NSObject>

@required

////////////////////////////////////////////////////////////////////////////////
/// @name DropBeacon区域相关
////////////////////////////////////////////////////////////////////////////////

/**
 *  用户正处于SDK监控的DropBeacon设备发射区域时的回调
 */
- (void)isInCoveredArea;

/**
 *  用户正在进⼊SDK监控的DropBeacon设备发射区域时的回调
 */
- (void)isEnteringCoveredArea;

/**
 *  用户正在离开SDK监控的DropBeacon设备发射区域时的回调
 */
- (void)isLeavingCoveredArea;


////////////////////////////////////////////////////////////////////////////////
/// @name DropBeacon设备发现
////////////////////////////////////////////////////////////////////////////////

/**
 *  APP在前台运行时SDK扫描到的离用户设备最近的一个被监控的DropBeacon设备时的回调
 *
 *  @param dbBeaconRegion 代表该所扫到设备的DBBeaconRegion对象
 *
 *  @discussion SDK根据在开发者在开放平台上设置的“有效距离”、“停留时间”和“通知间隔”这三个参
 * 数，从所扫描到的被监控设备中选择出离用户设备最近的一个来通知给该回调。当“通知间隔”不为0时，
 * 那么可能将最近的一个`DropBeaconRegion`通知给该回调后，会接下来将第二近的——如果通知间隔够
 * 长——甚至会通知第三近的`DropBeaconRegion`通知给该回调，以此类推。
 *
 *  @see didDiscoverDBBeaconRegionInBackground:
 */
- (void)didDiscoverDBBeaconRegionInForeground : (DBBeaconRegion *) dbBeaconRegion;

/**
 *  APP在后台运行时SDK扫描到了监控的DropBeacon设备时的回调
 *
 *  @param dbBeaconRegion 代表该所扫到设备的DBBeaconRegion对象
 *
 *  @discussion SDK根据在开发者在开放平台上设置的“有效距离”、“停留时间”和“通知间隔”这三个参
 * 数，从所扫描到的被监控设备中选择出离用户设备最近的一个来通知给该回调。当“通知间隔”不为0时，
 * 那么可能将最近的一个`DropBeaconRegion`通知给该回调后，会接下来将第二近的——如果通知间隔够
 * 长——甚至会通知第三近的`DropBeaconRegion`通知给该回调，以此类推。
 *
 *  @see didDiscoverDBBeaconRegionInForeground:
 */
- (void)didDiscoverDBBeaconRegionInBackground : (DBBeaconRegion *) dbBeaconRegion;

/**
 *  APP处于运⾏状态时，SDK会进行周期为1秒的扫描，如果扫到则触发该回调
 *
 *  @param dbBeaconRegions 周期内扫描到的DBBeaconRegion对象列表
 *
 *  @discussion 此回调和开放平台上设置的“有效距离”、“停留时间”和“通知间隔”这三个参数没有关系。
 * 该回调所通知的列表为当前所能扫到的所有被监控的DropBeacon设备。
 *
 */
- (void)didRangedDBBeaconRegions : (NSArray *) dbBeaconRegions;


////////////////////////////////////////////////////////////////////////////////
/// @name 异常
////////////////////////////////////////////////////////////////////////////////

/**
 *  用户没有为APP开启地理位置服务时的回调
 */
- (void)didFailScanBeaconsDuedToLocationServiceUnavailable;

/**
 *  用户未打开蓝牙时的回调
 */
- (void)didFailScanBeaconsDuedToBLEUnsupport;

/**
 *  无法获得APP需要监控的DropBeacon设备列表时的回调
 *
 *  @discussion 触发此回调一般是因为⺴络原因无法获取到需要监控的DropBeacon设备列表
 *
 */
- (void)didFailLoadingListForMonitoring;

/**
 *  APP与开放平台认证失败时的回调
 *
 *  @discussion 请检查传入给DropBeaconManager的authToken和authSecret是否有误
 */
- (void)didFailAuthenticationByInvalidTokenOrSecret;

/**
 *  APP与开放平台认证时因为网络问题没法确认证信息时的回调
 *
 *  @discussion 通常一个APP只要认证成功一次就不会再触发此回调
 *
 */
- (void)didFailAuthenticationByNetworkUnavailable;

@end




/**
 *  DropBeaconManager是DropBeaconSDK中最重要的一个单例类。通过它开发者可以简便的扫描周边的
 * 被监控的DropBeacon设备。
 *
 *  ### 开发者注册
 *
 *  在正式使用DropBeaconSDK之前，开发者需要通过[DropBeacon开放平台](http://cloud.idropbeacon.com)申请、激活自己的开发者账号
 *  ，然后建立自己的应用。注册应用了之后，可以获得相应的认证令牌(authSecret)和认证密钥(authToken)。
 *
 *  ### 配置DropBeacon
 *
 *  [DropBeacon开放平台](http://cloud.idropbeacon.com)提供了配置DropBeacon的途径。在联系我们并购买了DropBeacon设备之
 *  后，可以在DropBeacon开放平台上对每一个设备进行配置，可以配置的选项包括“有效距离”、“停留时间”
 *  和“通知间隔”。通过这三个参数的配置可以适应各种场景的需要。
 *
 *  ### 使用DropBeaconManager进行扫描
 *
 *  代码示例:
 *
 *  ```
 *  DropBeaconManager * dropBeaconManager = [DropBeaconManager sharedManager];
 *  dropBeaconManager.delegate = self;
 *  [dropBeaconManager setAuthenticationInfo:@"5b43db6e60812fbd7cbc0da26a25a72d" andSecret:@"c5ecaade3252a976858dae8e04e165ba"];
 *  ```
 *
 *  @warning 在`startScan`之前必须实现`DropBeaconManagerDelegate`中的方法
 *
 */
@interface DropBeaconManager : NSObject


////////////////////////////////////////////////////////////////////////////////
/// @name 代理
////////////////////////////////////////////////////////////////////////////////

/**
 *  DropBeaconManager的代理
 *
 *  @see DropBeaconManagerDelegate
 */
@property (nonatomic , weak) id<DropBeaconManagerDelegate> delegate;


////////////////////////////////////////////////////////////////////////////////
/// @name 单例、初始化
////////////////////////////////////////////////////////////////////////////////

/**
 *  获取DropBeaconManager的单例
 *
 *  @return 一个DropBeaconManager实例
 */
+ (instancetype)sharedManager;

////////////////////////////////////////////////////////////////////////////////
/// @name 认证信息
////////////////////////////////////////////////////////////////////////////////

/**
 *  设置从开放平台上获取到的authToken和authSecret以进行认证
 *
 *  @param authToken  认证令牌
 *  @param authSecret 认证密钥
 */
- (void) setAuthenticationInfo : (NSString *)authToken andSecret : (NSString *)authSecret;

////////////////////////////////////////////////////////////////////////////////
/// @name 扫描
////////////////////////////////////////////////////////////////////////////////

/**
 *  开始扫描
 */
- (void)startScan;

/**
 *  停止扫描
 */
- (void)stopScan;

@end
