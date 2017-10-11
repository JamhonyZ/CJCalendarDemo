//
//  CJCalendarPicker.h
//  CJCalendarDemo
//
//  Created by zzh on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJCalendarItem.h"

#define kOperationH 44.f

#define kCJCalendarPickerHeight (kCJCalendarItemH*6+kOperationH)

typedef void(^RefreshDateBlock)(NSInteger year,NSInteger month,NSInteger day);

@interface CJCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(RefreshDateBlock)refreshBlock;

@property (nonatomic, copy) RefreshDateBlock refreshBlock;

#pragma mark -- 必填配置

//切换月份，会变动
@property (nonatomic, strong) NSDate *newestDate;
//当日
@property (nonatomic, strong) NSDate *currentDate;


#pragma mark -- 可选配置
//是否支持查阅未来月份
@property (nonatomic, assign) BOOL ifSupportFutureMonth;

//可查阅的最小年月 （默认无限查阅）赋值 2017-08
@property (nonatomic, copy) NSString *minYearMonth;

//可查阅的最大年月  (默认无限查阅) 赋值 2020-09
@property (nonatomic, copy) NSString *maxYearMonth;


#pragma mark -- 公开方法

- (void)show;

- (void)dismiss;

@end
