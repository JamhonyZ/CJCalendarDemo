//
//  Common_define.h
//  CJCalendarDemo
//
//  Created by 张战宏 on 2017/10/1.
//  Copyright © 2017年 JamHonyZ. All rights reserved.
//

#ifndef Common_define_h
#define Common_define_h

#define CJScreenWidth [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight [UIScreen mainScreen].bounds.size.height

#define CJCalendar(value)  [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:value]

// 设置颜色 示例：UIColorHex(0x26A7E8)
#define UIColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kColorChoose UIColorHex(0x00B38A)

#define kColorWeekDay UIColorHex(0x333333)
#define kColorPassDay UIColorHex(0x666666)

#define kColorFutureDay UIColorHex(0x999999)

#endif /* Common_define_h */
