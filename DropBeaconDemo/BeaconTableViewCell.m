//
//  BeaconTableViewCell.m
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "BeaconTableViewCell.h"

@implementation BeaconTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"listbackground.png"]];
        imageV.frame = CGRectMake(0, 0, 304, 99.5);
        [self addSubview:imageV];
        
        _batteryImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"energy100.png"]];
        _batteryImageV.frame = CGRectMake(28, 12.5, 47, 16.5);
        [self addSubview:_batteryImageV];
        
        _inImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"in.png"]];
        _inImageV.frame = CGRectMake(_batteryImageV.frame.origin.x+_batteryImageV.frame.size.width+21, 10, 22, 22);
        [self addSubview:_inImageV];
        
        _inLabel = [[UILabel alloc] initWithFrame:CGRectMake(_inImageV.frame.origin.x+30, 12.5, 50, 16.5)];
        _inLabel.text = @"区域内";
        _inLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:_inLabel];
        
        _uuidLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, _batteryImageV.frame.origin.y+_batteryImageV.frame.size.height+18, 277, 15)];
        _uuidLabel.text = @"UUID:88888888-8888-8888-8888-8888888888888";
        _uuidLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_uuidLabel];
        
        _majorLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, _uuidLabel.frame.origin.y+_uuidLabel.frame.size.height, 100, 15)];
        _majorLabel.text = @"Major:200";
        _majorLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_majorLabel];
        
        _minorLabel = [[UILabel alloc] initWithFrame:CGRectMake(_majorLabel.frame.origin.x+_majorLabel.frame.size.width+10, _majorLabel.frame.origin.y, 100, 15)];
        _minorLabel.text = @"Minor:300";
        _minorLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_minorLabel];
        
        _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_majorLabel.frame.origin.x, _majorLabel.frame.origin.y+_majorLabel.frame.size.height, 100, 15)];
        _distanceLabel.text = @"距离:1.53m";
        _distanceLabel.font = [UIFont systemFontOfSize:11];
        [self addSubview:_distanceLabel];
        
        _configButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _configButton.frame = CGRectMake(269.5, 5, 29.5, 29.5);
        [_configButton setBackgroundImage:[UIImage imageNamed:@"setting.png"] forState:UIControlStateNormal];
        [self addSubview:_configButton];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
