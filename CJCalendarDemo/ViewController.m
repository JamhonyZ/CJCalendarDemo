//
//  ViewController.m
//  CJCalendarDemo
//
//  Created by 张战宏 on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#import "ViewController.h"
#import "CJCalendarPicker.h"
#import "Common_define.h"
@interface ViewController ()

@property (nonatomic, strong)CJCalendarPicker *picker;

@property (nonatomic, strong)UILabel *showLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *show = [UIButton buttonWithType:UIButtonTypeCustom];
    show.frame = CGRectMake((CJScreenWidth-100)/2, 100, 100, 40);
    [show setTitle:@"显示日历" forState:UIControlStateNormal];
    show.titleLabel.textAlignment = NSTextAlignmentCenter;
    [show setTitleColor:kColorChoose forState:UIControlStateNormal];
    show.titleLabel.font = [UIFont systemFontOfSize:15];
    [show addTarget:self action:@selector(showCalaendarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:show];
    
    UIButton *hidden = [UIButton buttonWithType:UIButtonTypeCustom];
    hidden.frame = CGRectMake((CJScreenWidth-100)/2, 180, 100, 40);
    [hidden setTitle:@"收起日历" forState:UIControlStateNormal];
    hidden.titleLabel.textAlignment = NSTextAlignmentCenter;
    [hidden setTitleColor:kColorChoose forState:UIControlStateNormal];
    hidden.titleLabel.font = [UIFont systemFontOfSize:15];
    [hidden addTarget:self action:@selector(hiddenCalaendarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hidden];
    
    _showLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(hidden.frame), CGRectGetMaxY(hidden.frame)+20, 100, 40)];
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.textColor = kColorChoose;
    _showLabel.layer.borderColor = kColorPassDay.CGColor;
    _showLabel.layer.borderWidth = 1;
    _showLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hidden];
    
    
}

- (void)showCalaendarAction {
    [self.view addSubview:self.picker];
    [self.picker show];
}
- (void)hiddenCalaendarAction {
    [self.picker dismiss];
}
- (CJCalendarPicker *)picker {
    if (!_picker) {
         __weak typeof(self) weakSelf = self;
        _picker = [[CJCalendarPicker alloc] initWithFrame:CGRectMake(0, CJScreenHeight-(kCJCalendarItemH*6+kOperationH), CJScreenWidth, kCJCalendarItemH*6+kOperationH) clickBlock:^(NSInteger year, NSInteger month, NSInteger day) {
           __strong typeof (weakSelf) strongSelf = weakSelf;
            strongSelf.showLabel.text = [NSString stringWithFormat:@"%@-%@-%@",@(year),@(month),@(day)];
        }];
        _picker.newestDate = [NSDate date];
        _picker.currentDate = _picker.newestDate;
//        _picker.maxYearMonth = @"2017-11";
//        _picker.minYearMonth = @"2017-08";
        
        //设置最大查看月份为当月
        _picker.maxYearMonth = [NSString stringWithFormat:@"%ld-%ld",[CJCalendar(_picker.newestDate) year], [CJCalendar(_picker.newestDate) month]];
    }
    return _picker;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
