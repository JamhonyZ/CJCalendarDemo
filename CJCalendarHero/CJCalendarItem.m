//
//  CJCalendarItem.m
//  CJCalendarDemo
//
//  Created by 张战宏 on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#import "CJCalendarItem.h"

@implementation CJCalendarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.dateLabel];
    }
    return self;
}

- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        CGFloat labelWH = kCJCalendarItemW < 20 ? kCJCalendarItemW : 20;
        _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake((labelWH-20)/2, (labelWH-20)/2 , 20, 20)];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        _dateLabel.font = [UIFont systemFontOfSize:15];
        _dateLabel.layer.cornerRadius = 3;
        _dateLabel.layer.masksToBounds = YES;
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}
@end
