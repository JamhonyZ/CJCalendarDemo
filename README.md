# CJCalendarDemo
简单的日历选择器。

使用说明：下载，导出CJCalendarHero，创建CJCalendarPicker，调用show方法即可。详情可见代码。。。。



__weak typeof(self) weakSelf = self;

_picker = [[CJCalendarPicker alloc] initWithFrame:CGRectMake(0, CJScreenHeight-kCJCalendarPickerHeight, CJScreenWidth, kCJCalendarPickerHeight) clickBlock:^(NSInteger year, NSInteger month, NSInteger day) {
            __strong typeof (weakSelf) strongSelf = weakSelf;
            strongSelf.showLabel.text = [NSString stringWithFormat:@"%@-%@-%@",@(year),@(month),@(day)];
}];

//必填

_picker.newestDate = [NSDate date];

_picker.currentDate = _picker.newestDate;


//可选

//        _picker.maxYearMonth = @"2017-11";

//        _picker.minYearMonth = @"2017-08";

//设置最大查看月份为当月

//      _picker.maxYearMonth = [NSString stringWithFormat:@"%ld-%ld",[CJCalendar(_picker.newestDate) year], [CJCalendar(_picker.newestDate) month]];


--------效果图-------
![image](https://github.com/JamhonyZ/CJCalendarDemo/blob/master/CJCalendarDemo/CJCalendarShot.png)

