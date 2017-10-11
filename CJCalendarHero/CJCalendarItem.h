//
//  CJCalendarItem.h
//  CJCalendarDemo
//
//  Created by 张战宏 on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_define.h"

#define kCJCalendarItemW  (CJScreenWidth/7)
#define kCJCalendarItemH  30
@interface CJCalendarItem : UICollectionViewCell

@property (nonatomic , strong) UILabel *dateLabel;

@end
