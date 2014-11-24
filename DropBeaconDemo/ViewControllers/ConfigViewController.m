//
//  ConfigViewController.m
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "ConfigViewController.h"
#import "ConfigTableViewCell.h"
#import "ConfigurationTemplateHandler.h"
#import "MBProgressHUD.h"

@interface ConfigViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UILabel *_exampleLabel;
    NSNumber *_selectedNumber;
}
@end

@implementation ConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = CGRectMake(0, 0, 50, 20.5);
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
        backBarButton.style = UIBarButtonItemStylePlain;
        self.navigationItem.leftBarButtonItem = backBarButton;
        
        UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clearButton.frame = CGRectMake(0, 0, 31.5, 15.5);
        [clearButton addTarget:self action:@selector(clearAction:) forControlEvents:UIControlEventTouchUpInside];
        [clearButton setBackgroundImage:[UIImage imageNamed:@"clear.png"] forState:UIControlStateNormal];
        UIBarButtonItem *clearBarButton = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
        clearBarButton.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem = clearBarButton;
        
        _dataArray = [NSMutableArray arrayWithArray:@[@"001picture.png",@"002web.png",@"003note.png",@"004bank.png",@"005restaurant.png"]];
    }
    return self;
}

- (void)backAction:(UIButton *)button
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud setLabelText:@"正在保存"];
    [hud hide:YES afterDelay:2];
    [self performSelector:@selector(delaySaveText:) withObject:hud afterDelay:1];
    [self performSelector:@selector(delayPopBack) withObject:nil afterDelay:2];
}

- (void)delaySaveText:(MBProgressHUD *)hud
{
    [hud setLabelText:@"保存成功"];
}

- (void)delayPopBack
{
    [self.rootVC.poppedDic removeObjectForKey:self.region.udid];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearAction:(UIButton *)button
{
    _selectedNumber = [NSNumber numberWithInteger:100];
    [[ConfigurationTemplateHandler sharedHandler] clearDBBeaconRegion:self.region];
    for (ConfigTableViewCell *cell in [_tableView visibleCells]) {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"choose_off.png"] forState:UIControlStateNormal];
    }
    _exampleLabel.text = @"当前设备内容配置为:空";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配置选择";
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(17.5, 30, 285, self.view.frame.size.height-64-30) style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.rowHeight = 80.0f;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.bounds.size.width, 0.01f)];
    [self.view addSubview:_tableView];
    
    _exampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    _exampleLabel.textAlignment = NSTextAlignmentCenter;
    _exampleLabel.text = @"当前设备内容配置为:空";
    [self.view addSubview:_exampleLabel];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _selectedNumber = [[ConfigurationTemplateHandler sharedHandler] fetchTemplateTypeWithDBBeaconRegion:self.region];
    if (_selectedNumber) {
        NSArray *textArray = @[@"图片",@"链接",@"记事本",@"收银台",@"餐厅"];
        _exampleLabel.text = [NSString stringWithFormat:@"当前设备内容配置为:%@",[textArray objectAtIndex:_selectedNumber.intValue]];
    }else{
        _selectedNumber = [NSNumber numberWithInteger:100];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 4;
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
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%d",indexPath.section];
    ConfigTableViewCell *cell = (ConfigTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[ConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    cell.backImageView.image = [UIImage imageNamed:[_dataArray objectAtIndex:indexPath.section]];

    if (indexPath.section == _selectedNumber.integerValue) {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"choose_on.png"] forState:UIControlStateNormal];
    }else{
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"choose_off.png"] forState:UIControlStateNormal];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (ConfigTableViewCell *cell in [tableView visibleCells]) {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"choose_off.png"] forState:UIControlStateNormal];
    }
    
    ConfigTableViewCell *cell = (ConfigTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"choose_on.png"] forState:UIControlStateNormal];
    
    _selectedNumber = [NSNumber numberWithInteger:indexPath.section];
    [[ConfigurationTemplateHandler sharedHandler] saveWithDBBeaconRegion:self.region andTemplateType:_selectedNumber];
    
    NSArray *textArray = @[@"图片",@"链接",@"记事本",@"收银台",@"餐厅"];
    _exampleLabel.text = [NSString stringWithFormat:@"当前设备内容配置为:%@",[textArray objectAtIndex:_selectedNumber.integerValue]];
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
