//
//  NotebookViewController.m
//  DropBeaconDemo
//
//  Created by niexin on 7/31/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "NotebookViewController.h"
#import "KGModal.h"

@interface NotebookViewController ()
{
    KGModal *_modal;
}
@end

@implementation NotebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)backAction:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"301note_background.png"]];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15, 32, 50, 20.5);
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [backButton setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [self.view addSubview:backButton];
    
    _modal = [KGModal sharedInstance];
    _modal.backgroundDisplayStyle = KGModalBackgroundDisplayStyleSolid;
    _modal.tapOutsideToDismiss = NO;
    [_modal showWithContentView:[UILabel new] andAnimated:NO];
    [self performSelector:@selector(showKGModalView) withObject:nil afterDelay:1.5];
}

- (void)showKGModalView
{
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"301note.png"]];
    imageV.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    button.frame = CGRectMake(12, 142, 200, 40);
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
