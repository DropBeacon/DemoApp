//
//  RestaurantViewController.m
//  DropBeaconDemo
//
//  Created by niexin on 7/31/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "RestaurantViewController.h"
#import "KGModal.h"

@interface RestaurantViewController ()
{
    KGModal *_modal;
    UIScrollView *_scrollView;
    UIImageView *_selectImageV;
}
@end

@implementation RestaurantViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"501restaurant.png"]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 32, 50, 20.5);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    [self createButtons];
    _modal = [KGModal sharedInstance];
    _modal.backgroundDisplayStyle = KGModalBackgroundDisplayStyleSolid;
    _modal.tapOutsideToDismiss = NO;
    [_modal showWithContentView:[UILabel new] andAnimated:NO];
    [self performSelector:@selector(showKGModalView) withObject:nil afterDelay:1.5];
    
}

- (void)createButtons
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 125, 320, self.view.frame.size.height-125)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.contentSize = CGSizeMake(320, 756);
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i<4; i++) {
        for (int j = 0; j<2; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(9.6*(j+1)+j*145.5, 9.6*(i+1)+i*177, 145.5, 177);
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"501restaurant_food%d.png",i*2+j+1]] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(tapedFoodButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];
        }
    }
    
    _selectImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"501restaurant_choose.png"]];
    _selectImageV.frame = CGRectMake(-500, -500, 150.5, 182);
    [_scrollView addSubview:_selectImageV];
    
}

- (void)tapedFoodButton:(UIButton *)btn
{
    if (_selectImageV.center.x == btn.center.x && _selectImageV.center.y == btn.center.y) {
        _selectImageV.center = CGPointMake(-500, -500);
    }else{
        _selectImageV.center = btn.center;
    }
}

- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)showKGModalView
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"502restaurant.png"]];
    imageV.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = CGRectMake(5, 138, 180, 48);
    [button addTarget:self action:@selector(hideKGModal:) forControlEvents:UIControlEventTouchUpInside];
    [imageV addSubview:button];
    _modal = [KGModal sharedInstance];
    _modal.backgroundDisplayStyle = KGModalBackgroundDisplayStyleGradient;
    _modal.tapOutsideToDismiss = YES;
    _modal.showCloseButton = NO;
    [_modal showWithContentView:imageV andAnimated:YES];
}
- (void)hideKGModal:(UIButton *)btn
{
    [_modal hideAnimated:YES];
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
