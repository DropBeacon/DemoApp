//
//  RootViewController.m
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "RootViewController.h"
#import "BeaconTableViewCell.h"
#import "ConfigViewController.h"
#import "ConfigurationTemplateHandler.h"
#import "NotebookViewController.h"
#import "BankViewController.h"
#import "RestaurantViewController.h"
#import <AudioToolbox/AudioToolbox.h>


@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
{
    DropBeaconManager * _dbManager;
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_backPopedArray;
}
@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBar.png"] forBarMetrics:UIBarMetricsDefault];
    self.title = @"体验";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    _poppedDic = [NSMutableDictionary dictionaryWithCapacity:0];
    _bgPoppedDic = [NSMutableDictionary dictionaryWithCapacity:0];
    
    //---------------------SDK接入--------------------
    _dbManager = [DropBeaconManager sharedManager];
    [_dbManager setAuthenticationInfo:@"40f09858a9322cf481ae078237b54b0d" andSecret:@"2dc2d1ad8d9e6c3288b6d253649f29bb"];
    _dbManager.delegate = self;
    [_dbManager startScan];
    //---------------------end-----------------------
    
    
    [self prepareTableView];
}

- (void)applicationDidEnterBackground:(NSNotification *)noti
{
    [_bgPoppedDic removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _backPopedArray = [NSMutableArray arrayWithCapacity:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)prepareTableView
{
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(8, 0, 304, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 99.5f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 20.0f)];
    [self.view addSubview:_tableView];
}


#pragma - mark UITableViewDataSource

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BeaconTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell.configButton addTarget:self action:@selector(tapConfigButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.configButton.tag = 1000+indexPath.section;
    DBBeaconRegion *region = [_dataArray objectAtIndex:indexPath.section];
    cell.uuidLabel.text = [NSString stringWithFormat:@"UUID:%@",[region.uuid UUIDString]];
    cell.majorLabel.text = [NSString stringWithFormat:@"Major:%d",region.major];
    cell.minorLabel.text = [NSString stringWithFormat:@"Minor:%d",region.minor];
    cell.distanceLabel.text = [NSString stringWithFormat:@"距离:%.2fm",[region getAccuracy]];
    if (!region.isInValidRange) {
        cell.inImageV.hidden = YES;
        cell.inLabel.hidden = YES;
    }else{
        cell.inImageV.hidden = NO;
        cell.inLabel.hidden = NO;
    }
    
    return cell;
}

-(void)tapConfigButton:(UIButton *)btn
{
    ConfigViewController *configVC = [[ConfigViewController alloc] init];
    int index = btn.tag-1000;
    DBBeaconRegion *region = [_dataArray objectAtIndex:index];
    configVC.region = region;
    configVC.rootVC = self;
    
    [self.navigationController pushViewController:configVC animated:YES];
}


#pragma - mark DropBeaconManagerDelegate

- (void)didFailLoadingListForMonitoring
{
    
}

- (void)didFailScanBeaconsDuedToBLEUnsupport
{
    
}

- (void)didFailScanBeaconsDuedToLocationServiceUnavailable
{
    
}

- (void)didFailAuthenticationByInvalidTokenOrSecret
{
    
}

- (void)didFailAuthenticationByNetworkUnavailable
{
    
}

- (void)didRangedDBBeaconRegions:(NSArray *)dbBeaconRegions
{
    if (dbBeaconRegions.count) {
        [_dataArray removeAllObjects];
        [_dataArray addObjectsFromArray:dbBeaconRegions];
        [_tableView reloadData];
    }
}

- (void)didDiscoverDBBeaconRegionInForeground:(DBBeaconRegion *)dbBeaconRegion
{
    if ([self canPopRegion:dbBeaconRegion isForeground:YES]) {
        NSNumber *number = [[ConfigurationTemplateHandler sharedHandler] fetchTemplateTypeWithDBBeaconRegion:dbBeaconRegion];
        if (number) {
            [self setRegion:dbBeaconRegion poppedInForeground:YES];
            [self modalViewControllerWithType:number.intValue];
        }
    }
}

- (void)didDiscoverDBBeaconRegionInBackground:(DBBeaconRegion *)dbBeaconRegion
{
    if ([self canPopRegion:dbBeaconRegion isForeground:NO]) {
        [self pushLocalNotification];
        [self setRegion:dbBeaconRegion poppedInForeground:NO];
    }
}

- (void)isEnteringCoveredArea
{
    
}

- (void)isLeavingCoveredArea
{
    
}

- (void)isInCoveredArea
{
    
}


#pragma - mark ForPrivateUseSelectors

- (BOOL)canPopRegion:(DBBeaconRegion *)region isForeground:(BOOL)isForeground
{
    BOOL canPop = YES;
    if (isForeground) {
        canPop = [_poppedDic objectForKey:region.udid]?NO:YES;
    }else{
        canPop = [_bgPoppedDic objectForKey:region.udid]?NO:YES;
    }
    return canPop;
}

- (void)setRegion:(DBBeaconRegion *)region poppedInForeground:(BOOL)foreground
{
    if (foreground) {
        [_poppedDic setObject:@YES forKey:region.udid];
    }else{
        [_bgPoppedDic setObject:@YES forKey:region.udid];
    }
}

- (void)modalViewControllerWithType:(int)type
{
    switch (type) {
        case 0:
            [self showSamplePicture:@"101picture.png"];
            break;
        case 1:
            [self pushIntoTheWebView];
            break;
        case 2:{
            NotebookViewController *notebookVC = [[NotebookViewController alloc] init];
            notebookVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:notebookVC animated:YES completion:^{
            }];
        }
            break;
        case 3:{
            BankViewController *bankVC = [[BankViewController alloc] init];
            bankVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:bankVC animated:YES completion:^{
            }];
        }
            break;
        case 4:{
            RestaurantViewController *restVC = [[RestaurantViewController alloc] init];
            restVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self presentViewController:restVC animated:YES completion:^{
            }];
        }
            break;
        default:
            break;
    }
}

- (void)showSamplePicture:(NSString *)picName
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:picName]];
    imageV.frame = CGRectMake(0, -568, 320, 568);
    imageV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThePicture:)];
    [imageV addGestureRecognizer:tap];
    [self.navigationController.view addSubview:imageV];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        imageV.frame = CGRectMake(0, 0, 320, 568);
    } completion:^(BOOL finished) {
    }];
}

- (void)tapThePicture:(UITapGestureRecognizer *)tap
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tap.view.frame = CGRectMake(0, -568, 320, 568);
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
        [self viewWillAppear:YES];
    }];
}

- (void)pushIntoTheWebView
{
    UIViewController * webVC = [[UIViewController alloc] init];
    webVC.view.backgroundColor = [UIColor grayColor];
    UIWebView *webview = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.36kr.com/p/214199?from=timeline&isappinstalled=0"]];
    webview.delegate = self;
    [webview loadRequest:request];
    [webVC.view addSubview:webview];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 32, 50, 20.5);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [webVC.view addSubview:backButton];
    webVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:webVC animated:YES completion:^{
    }];
    
}

- (void)pushLocalNotification
{
    UILocalNotification *localNotification = [[UILocalNotification alloc]init];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    localNotification.alertBody = [NSString stringWithFormat:@"欢迎体验DropBeacon，在您附近发现了新的Beacon哦。"];
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
