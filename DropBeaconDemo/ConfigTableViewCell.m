//
//  ConfigTableViewCell.m
//  DropBeaconDemo
//
//  Created by niexin on 7/30/14.
//  Copyright (c) 2014 niexin. All rights reserved.
//

#import "ConfigTableViewCell.h"

@implementation ConfigTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:0.85];
        self.layer.cornerRadius = 10;
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nil.png"]];
        _backImageView.frame = CGRectMake(0, 0, 285, 80);
        [self addSubview:_backImageView];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setBackgroundImage:[UIImage imageNamed:@"choose_off.png"] forState:UIControlStateNormal];
        _selectButton.frame = CGRectMake(14, 59, 15.5, 14.5);
        [self addSubview:_selectButton];
        
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
