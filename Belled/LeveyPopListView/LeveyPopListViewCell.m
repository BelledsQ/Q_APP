//
//  LeveyPopListViewCell.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListViewCell.h"

@implementation LeveyPopListViewCell
{
    QCheckBox *checkall;
    NSString *ischeck;
    int m;
    GlobalSet *gt;
}
//@synthesize  textLabel,detailTextLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    //gt = [GlobalSet bellSetting];
    //NSArray  *che = [gt.alarmWeek componentsSeparatedByString:@","];
    
    if (self) {
        m = 0;
        //NSArray  *arrayLabel = [self.textLabel.text componentsSeparatedByString:@":"];
        NSLog(@"%@",self.detailTextLabel.text);
        //self.textLabel.text = [arrayLabel objectAtIndex:0];
        //ischeck = [[NSString alloc]initWithFormat:@"%@",[arrayLabel objectAtIndex:1]];
        checkall = [[QCheckBox alloc] initWithDelegate:self];
        [checkall setImage:[UIImage imageNamed:@"seloff.png"] forState:UIControlStateNormal];
        [checkall setImage:[UIImage imageNamed:@"selon.png"] forState:UIControlStateSelected];
        checkall.frame = CGRectMake(6, -4, 50, 50);
        [self addSubview:checkall];
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //self.ibutton.frame = CGRectOffset(self.ibutton.frame, 6, 0);
    
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 12, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected){
        NSLog(@"%d",m);
        if(m%2 == 0){
            checkall.checked = YES;
        }else{
            checkall.checked = NO;
        }
        m++;
    }
    
}

@end