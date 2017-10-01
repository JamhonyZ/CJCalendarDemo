//
//  CJCalendarPicker.m
//  CJCalendarDemo
//
//  Created by zzh on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#import "CJCalendarPicker.h"
#import "CJCalendarItem.h"

static   NSString *kCellIden = @"calendarItemiden";

@interface CJCalendarPicker ()
//一周日期
@property (nonatomic , strong) NSArray *weekDayArray;
//日期表
@property (nonatomic, strong) UICollectionView *ctView;
//显示的文本
@property (nonatomic, strong) UILabel *resultLabel;
//上个月
@property (nonatomic, strong) UIButton *previousButton;
//下月
@property (nonatomic, strong) UIButton *nextButton;
//选中的日期
@property (nonatomic, copy) NSString *selectStr;

@end

@implementation CJCalendarPicker

- (instancetype)initWithFrame:(CGRect)frame clickBlock:(RefreshDateBlock)refreshBlock {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.refreshBlock = refreshBlock;

        [self addSwipe];
        
        [self creatView];
        
    }
    return self;
}
#pragma mark -- view
- (void)creatView {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kOperationH)];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    
    [topView addSubview:self.previousButton];
    [topView addSubview:self.resultLabel];
    [topView addSubview:self.nextButton];
    
    [self addSubview:self.ctView];
}

- (void)setNewestDate:(NSDate *)newestDate {
    
    _newestDate = newestDate;

    self.resultLabel.text = [NSString stringWithFormat:@"%ld-%ld",[CJCalendar(newestDate) year], [CJCalendar(newestDate) month]];
    
    if (!_selectStr) {
        self.selectStr = [NSString stringWithFormat:@"%ld%ld%ld",[CJCalendar(newestDate) year], [CJCalendar(newestDate) month],[CJCalendar(newestDate) day]];
    }
    
    [self.ctView reloadData];
}

#pragma mark - date
//当月首日是星期几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}

//一个月天数
- (NSInteger)totalDaysInMonth:(NSDate *)date{
    NSRange daysInLastMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInLastMonth.length;
}
//上个月
- (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
//下个月
- (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

#pragma -- mark collectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return _weekDayArray.count;
    } else {
        // 6*7
        return 42;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CJCalendarItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIden forIndexPath:indexPath];
    cell.dateLabel.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0) {
        cell.dateLabel.text = _weekDayArray[indexPath.row];
        cell.dateLabel.textColor = kColorWeekDay;
    } else {
        
        NSInteger daysInThisMonth = [self totalDaysInMonth:_newestDate];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_newestDate];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i < firstWeekday) {
            //当月首日 在一星期表格中 之前的日子
            [cell.dateLabel setText:@""];
        } else if (i > firstWeekday + daysInThisMonth - 1){
            //当月末日 在一星期表格中 之后的日子
            [cell.dateLabel setText:@""];
        } else {
            
            day = i - firstWeekday + 1;
            [cell.dateLabel setText:[NSString stringWithFormat:@"%li",(long)day]];
            [cell.dateLabel setTextColor:kColorPassDay];
            
            NSString *ymd = [NSString stringWithFormat:@"%ld%ld%ld", (long)[CJCalendar(_newestDate) year],(long)[CJCalendar(_newestDate) month],(long)day];
            
            if ([ymd isEqualToString:self.selectStr]) {
                //当前选中
                cell.dateLabel.backgroundColor = kColorChoose;
                cell.dateLabel.textColor = [UIColor whiteColor];
            } else {
                cell.dateLabel.textColor = kColorPassDay;
            }
            //当前月份
            if ([_currentDate isEqualToDate:_newestDate]) {
                if (day == [CJCalendar(_newestDate) day]) {
                    //当天日期
                    

                } else if (day > [CJCalendar(_newestDate) day]) {
                    //还未到的日期
                    [cell.dateLabel setTextColor:kColorFutureDay];
                }
            } else if ([_newestDate compare:_newestDate] == NSOrderedAscending) {
                //已经到的日期
                [cell.dateLabel setTextColor:kColorPassDay];
            }
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        NSInteger daysInThisMonth = [self totalDaysInMonth:_newestDate];
        NSInteger firstWeekday = [self firstWeekdayInThisMonth:_newestDate];
        
        NSInteger day = 0;
        NSInteger i = indexPath.row;
        
        if (i >= firstWeekday && i <= firstWeekday + daysInThisMonth - 1) {
            day = i - firstWeekday + 1;
            
            //this month
            if ([_currentDate isEqualToDate:_newestDate]) {
                if (day <= [CJCalendar(_newestDate) day]) {
                    return YES;
                }
            } else if ([_currentDate compare:_newestDate] == NSOrderedDescending) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击选中的效果
//    CJCalendarItem *cell = (CJCalendarItem *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self.newestDate];
    NSInteger firstWeekday = [self firstWeekdayInThisMonth:_newestDate];
    
    NSInteger day = 0;
    NSInteger i = indexPath.row;
    day = i - firstWeekday + 1;
    
    [_ctView reloadData];
    
    if (self.refreshBlock) {
        self.selectStr = [NSString stringWithFormat:@"%ld%ld%ld",[comp year], [comp month],day];
        self.refreshBlock( [comp year],[comp month],day);
    }
}

#pragma mark -- Action
- (void)previouseAction {
    
    if (_minYearMonth) {
        NSInteger year = [CJCalendar(_newestDate) year];
        NSInteger month = [CJCalendar(_newestDate) month];
        if ([_minYearMonth containsString:@"-"]) {
            NSArray *array = [_minYearMonth componentsSeparatedByString:@"-"];
            if (year == [array.firstObject integerValue]
                && month <= [array.lastObject integerValue]) {
                return;
            }
        }
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlDown animations:^(void) {
        self.newestDate = [self lastMonth:self.newestDate];
    } completion:nil];
}

- (void)nextAction {
    
    if (_maxYearMonth) {
        NSInteger year = [CJCalendar(_newestDate) year];
        NSInteger month = [CJCalendar(_newestDate) month];
        if ([_maxYearMonth containsString:@"-"]) {
            NSArray *array = [_maxYearMonth componentsSeparatedByString:@"-"];
            if (year == [array.firstObject integerValue]
                && month >= [array.lastObject integerValue]) {
                return;
            }
        }
    }
    
    [UIView transitionWithView:self duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^(void) {
        self.newestDate = [self nextMonth:self.newestDate];
        
    } completion:nil];
}


- (void)show {
    self.hidden = NO;
    [self.ctView reloadData];
    self.transform = CGAffineTransformTranslate(self.transform, 0, CGRectGetHeight(self.frame));
    [UIView animateWithDuration:0.3 animations:^(void) {
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL isFinished) {
        
    }];
}

- (void)dismiss {
    if (self.superview) {
        [UIView animateWithDuration:0.2 animations:^(void) {
            self.transform = CGAffineTransformTranslate(self.transform, 0, CGRectGetHeight(self.frame));
        } completion:^(BOOL isFinished) {
            [self removeFromSuperview];
        }];
    }
}


- (void)addSwipe {
    UISwipeGestureRecognizer *swipLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextAction)];
    swipLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipLeft];
    
    UISwipeGestureRecognizer *swipRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(previouseAction)];
    swipRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:swipRight];
}

#pragma mark -- LazyLoad
- (UIButton *)previousButton {
    if (!_previousButton) {
        _previousButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _previousButton.frame = CGRectMake(0, 0, kOperationH, kOperationH);
        [_previousButton setImage:[UIImage imageNamed:@"bt_previous"] forState:UIControlStateNormal];
        [_previousButton addTarget:self action:@selector(previouseAction) forControlEvents:UIControlEventTouchUpInside];
        _previousButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _previousButton;
}
- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] initWithFrame:CGRectMake(kOperationH, 0, self.frame.size.width-kOperationH*2, kOperationH)];
        _resultLabel.textColor = kColorPassDay;
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.font = [UIFont systemFontOfSize:16];
    }
    return _resultLabel;
}
- (UIButton *)nextButton {
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.frame = CGRectMake(self.frame.size.width-kOperationH, 0, kOperationH, kOperationH);
        [_nextButton setImage:[UIImage imageNamed:@"bt_next"] forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.imageView.contentMode = UIViewContentModeCenter;
    }
    return _nextButton;
}
- (UICollectionView *)ctView {
    if (!_ctView) {
        CGFloat itemWidth = kCJCalendarItemW;
        CGFloat itemHeight = kCJCalendarItemH;
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.itemSize = CGSizeMake(itemWidth, itemHeight);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        
        _ctView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kOperationH, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-kOperationH) collectionViewLayout:layout];
        _ctView.showsVerticalScrollIndicator = NO;
        _ctView.showsHorizontalScrollIndicator = NO;
        _ctView.backgroundColor = [UIColor whiteColor];
        _ctView.dataSource = self;
        _ctView.delegate = self;
        [_ctView registerClass:[CJCalendarItem class] forCellWithReuseIdentifier:kCellIden];
        _weekDayArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    }
    return _ctView;
}


@end
