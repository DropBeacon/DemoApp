//
//  BeaconTableViewCell.h
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconTableViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *batteryImageV;
@property (nonatomic,retain) UIImageView *inImageV;
@property (nonatomic,retain) UILabel *inLabel;
@property (nonatomic,retain) UILabel *uuidLabel;
@property (nonatomic,retain) UILabel *majorLabel;
@property (nonatomic,retain) UILabel *minorLabel;
@property (nonatomic,retain) UILabel *distanceLabel;
@property (nonatomic,retain) UIButton *configButton;

@end
