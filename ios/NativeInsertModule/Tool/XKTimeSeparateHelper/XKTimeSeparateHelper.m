//
//  XKTimeSeparateHelper.m
//  TimeSeparate
//
//  Created by hupan on 2018/8/2.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import "XKTimeSeparateHelper.h"
#import "XKTimeManager.h"

@implementation XKTimeSeparateHelper


+ (NSString *)backStringWithFormatString:(NSString *)formatString date:(NSDate *)date {
    
    NSDateFormatter *outputFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [outputFormatter setDateFormat:formatString];
    NSString *string = [outputFormatter stringFromDate:date];
    return string;
}

+ (NSString *)backStringWithFormatString:(NSString *)formatString timestampString:(NSString *)timestampString {
    
    NSDateFormatter *outputFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [outputFormatter setDateFormat:formatString];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
    NSString *string = [outputFormatter stringFromDate:date];
    return string;
}

+ (NSDate *)backDateWithFormatString:(NSString *)formatString timeString:(NSString *)timeString {
    
    if (!timeString) {
        return nil;
    }
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [dateFormatter setDateFormat:formatString];
    if (timeString.length >= formatString.length) {
        timeString = [timeString substringWithRange:NSMakeRange(0, formatString.length)];
    }
    NSDate *myDate = [dateFormatter dateFromString:timeString];
    return myDate;
}




//根据NSDate 返回年月 字符串
+ (NSString *)backYMStringByChineseSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy年MM月" date:date];
}
//根据时间字符串 返回年月 Date
+ (NSDate *)backYMDateByChineseSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy年MM月" timeString:timeString];
}
//根据时间戳string 返回年月 字符串
+ (NSString *)backYMStringByChineseSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy年MM月" timestampString:timestampString];
}


//根据NSDate 返回年月日 字符串
+ (NSString *)backYMDStringByChineseSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy年MM月dd日" date:date];
}

//根据时间字符串 返回年月日 Date
+ (NSDate *)backYMDDateByChineseSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy年MM月dd日" timeString:timeString];
}
//根据时间戳string 返回年月日 字符串
+ (NSString *)backYMDStringByChineseSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy年MM月dd日" timestampString:timestampString];
}


//根据NSDate 返回年月日时分字符串
+ (NSString *)backYMDHMStringByChineseSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy年MM月dd日 HH:mm" date:date];
}
/**
 根据NSDate 返回年月日 周 时分字符串 通过汉字分割
 
 @param date date
 @return 返回年月日周时分，通过汉字分割
 */
+ (NSString *)backYMDWeekHMStringByChineseSegmentWithDate:(NSDate *)date {
    NSString *time = [self backYMDHMStringByChineseSegmentWithDate:date];
    return [time stringByReplacingOccurrencesOfString:@" " withString:[NSString stringWithFormat:@" %@ ",[self backWeekStringWithDate2:date]]];
}

//根据时间字符串 返回年月日时分 Date
+ (NSDate *)backYMDHMDateByChineseSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy年MM月dd日 HH:mm" timeString:timeString];
}
//根据时间戳string 返回年月日时分字符串
+ (NSString *)backYMDHMStringByChineseSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy年MM月dd日 HH:mm" timestampString:timestampString];
}


//根据NSDate 返回年月日时分秒字符串
+ (NSString *)backYMDHMSStringByChineseSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy年MM月dd日 HH:mm:ss" date:date];
}
//根据时间字符串 返回年月日时分秒 Date
+ (NSDate *)backYMDHMSDateByChineseSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy年MM月dd日 HH:mm:ss" timeString:timeString];
}
//根据时间戳string 返回年月日时分秒字符串
+ (NSString *)backYMDHMSStringByChineseSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy年MM月dd日 HH:mm:ss" timestampString:timestampString];
}






//根据NSDate 返回年月 字符串
+ (NSString *)backYMStringByVirguleSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy/MM" date:date];
}
//根据时间字符串 返回年月 Date
+ (NSDate *)backYMDateByVirguleSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy/MM" timeString:timeString];
}
//根据时间戳string 返回年月 字符串
+ (NSString *)backYMStringByVirguleSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy/MM" timestampString:timestampString];
}


//根据NSDate 返回年月日 字符串
+ (NSString *)backYMDStringByVirguleSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy/MM/dd" date:date];
}

//根据时间字符串 返回年月日 Date
+ (NSDate *)backYMDDateByVirguleSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy/MM/dd" timeString:timeString];
}
//根据时间戳string 返回年月日 字符串
+ (NSString *)backYMDStringByVirguleSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy/MM/dd" timestampString:timestampString];
}


//根据NSDate 返回年月日时分字符串
+ (NSString *)backYMDHMStringByVirguleSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy/MM/dd HH:mm" date:date];
}
/**
 根据NSDate 返回年月日 周 时分字符串 通过汉字分割
 
 @param date date
 @return 返回年月日周时分，通过汉字分割
 */
+ (NSString *)backYMDWeakHMStringByVirguleSegmentWithDate:(NSDate *)date {
    NSString *time = [self backYMDHMStringByChineseSegmentWithDate:date];
    return [time stringByReplacingOccurrencesOfString:@" " withString:[NSString stringWithFormat:@" %@ ",[self backWeekStringWithDate2:date]]];
}

//根据时间字符串 返回年月日时分 Date
+ (NSDate *)backYMDHMDateByVirguleSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy/MM/dd HH:mm" timeString:timeString];
}
//根据时间戳string 返回年月日时分字符串
+ (NSString *)backYMDHMStringByVirguleSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy/MM/dd HH:mm" timestampString:timestampString];
}

//根据时间戳string 返回年月日时分秒字符串
+ (NSString *)backYMDHMSSStringByVirguleSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy/MM/dd HH:mm:ss" timestampString:timestampString];
}

+ (NSString *)backYMDHMStringByPointWithTimestampString:(NSString *)timestampString {
     return [self backStringWithFormatString:@"yyyy.MM.dd" timestampString:timestampString];
}
//根据NSDate 返回年月日时分秒字符串
+ (NSString *)backYMDHMSStringByVirguleSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy/MM/dd HH:mm:ss" date:date];
}
//根据时间字符串 返回年月日时分秒 Date
+ (NSDate *)backYMDHMSDateByVirguleSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy/MM/dd HH:mm:ss" timeString:timeString];
}
//根据时间戳string 返回年月日时分秒字符串
+ (NSString *)backYMDHMSStringByVirguleSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy/MM/dd HH:mm:ss" timestampString:timestampString];
}




//根据NSDate 返回年月 字符串
+ (NSString *)backYMStringByStrigulaSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy-MM" date:date];
}
//根据时间字符串 返回年月 Date
+ (NSDate *)backYMDateByStrigulaSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy-MM" timeString:timeString];
}
//根据时间戳string 返回年月 字符串
+ (NSString *)backYMStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy-MM" timestampString:timestampString];
}


//根据NSDate 返回年月日 字符串
+ (NSString *)backYMDStringByStrigulaSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy-MM-dd" date:date];
}

//根据时间字符串 返回年月日 Date
+ (NSDate *)backYMDDateByStrigulaSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy-MM-dd" timeString:timeString];
}
//根据时间戳string 返回年月日 字符串
+ (NSString *)backYMDStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy-MM-dd" timestampString:timestampString];
}


//根据NSDate 返回年月日时分 字符串
+ (NSString *)backYMDHMStringByStrigulaSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy-MM-dd HH:mm" date:date];
}
//根据时间字符串 返回年月日时分 Date
+ (NSDate *)backYMDHMDateByStrigulaSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy-MM-dd HH:mm" timeString:timeString];
}
//根据时间戳string 返回年月日时分 字符串
+ (NSString *)backYMDHMStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy-MM-dd HH:mm" timestampString:timestampString];
}


//根据NSDate 返回年月日时分秒 字符串
+ (NSString *)backYMDHMSStringByStrigulaSegmentWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy-MM-dd HH:mm:ss" date:date];
}
//根据时间字符串 返回年月日时分秒 Date
+ (NSDate *)backYMDHMSDateByStrigulaSegmentWithTimeString:(NSString *)timeString {
    return [self backDateWithFormatString:@"yyyy-MM-dd HH:mm:ss" timeString:timeString];
}
//根据时间戳string 返回年月日时分秒 字符串
+ (NSString *)backYMDHMSStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString {
    return [self backStringWithFormatString:@"yyyy-MM-dd HH:mm:ss" timestampString:timestampString];
}









//根据NSDate 返回年 字符串
+ (NSString *)backYearStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"yyyy" date:date];
}

//根据NSDate 返回月 字符串
+ (NSString *)backMonthStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"MM" date:date];
}

//根据NSDate 返回日 字符串
+ (NSString *)backDayStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"dd" date:date];
}

//根据NSDate 返回月日 字符串
+ (NSString *)backMonthAndDayStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"MM-dd" date:date];
}

//根据NSDate 返回时分秒 字符串
+ (NSString *)backHMSStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"HH:mm:ss" date:date];
}

//根据NSDate 返回时 字符串
+ (NSString *)backHStringWithDate:(NSDate *)date {
    return [self backStringWithFormatString:@"HH" date:date];
}


+ (NSString *)backWeekStringWithDate:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger weekday = [components weekday];
    NSString *result = @"";
    switch (weekday) {
        case 1:
            result = @"星期日";
            break;
        case 2:
            result = @"星期一";
            break;
        case 3:
            result = @"星期二";
            break;
        case 4:
            result = @"星期三";
            break;
        case 5:
            result = @"星期四";
            break;
        case 6:
            result = @"星期五";
            break;
        case 7:
            result = @"星期六";
            break;
        default:
            break;
    }
    
    return result;
}

+ (NSString *)backWeekStringWithDate2:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger weekday = [components weekday];
    NSString *result = @"";
    switch (weekday) {
        case 1:
            result = @"周日";
            break;
        case 2:
            result = @"周一";
            break;
        case 3:
            result = @"周二";
            break;
        case 4:
            result = @"周三";
            break;
        case 5:
            result = @"周四";
            break;
        case 6:
            result = @"周五";
            break;
        case 7:
            result = @"周六";
            break;
        default:
            break;
    }
    
    return result;
}



//计算指定日期 指定天数 后的新日期
+ (NSString *)backNewDateWithDays:(NSInteger)days fromTimeString:(NSString *)timeString {
    
    NSDate *myDate = [self backDateWithFormatString:@"yyyy-MM-dd" timeString:timeString];
    NSDate *newDate = [myDate dateByAddingTimeInterval:60 * 60 * 24 * days];
    return [[XKTimeManager timeShareManager].dateFormatter stringFromDate:newDate];
}


// 返回两日期相差天数
+ (NSInteger)backDaysWithStartDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr {
    
    if (!startDateStr || !endDateStr) {
        return 0;
    }
    //创建两个日期
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *startDate = [dateFormatter dateFromString:startDateStr];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitDay;//只比较天数差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.day;
}


// 返回指定时间戳与当前系统时间的时间差（秒）
+ (NSInteger)backSecondWithTimestampString:(NSString *)stampString {
    
    if (!stampString) {
        return 0;
    }
    //创建两个日期
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [dateFormatter dateFromString:[self backYMDHMSStringByStrigulaSegmentWithTimestampString:stampString]];
    //利用NSCalendar比较日期的差异
    NSCalendar *calendar = [NSCalendar currentCalendar];
    /**
     * 要比较的时间单位,常用如下,可以同时传：
     *    NSCalendarUnitDay : 天
     *    NSCalendarUnitYear : 年
     *    NSCalendarUnitMonth : 月
     *    NSCalendarUnitHour : 时
     *    NSCalendarUnitMinute : 分
     *    NSCalendarUnitSecond : 秒
     */
    NSCalendarUnit unit = NSCalendarUnitSecond;//只比较秒差异
    //比较的结果是NSDateComponents类对象
    NSDateComponents *delta = [calendar components:unit fromDate:startDate toDate:endDate options:0];
    return delta.second;
}

//根据日期返回时间戳（精确到毫秒）
+ (NSString *)backTimestampStringWithDate:(NSDate *)date {

    NSTimeInterval a = [date timeIntervalSince1970] * 1000; //精确到毫秒
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", a];
    return timestampString;
}

//根据日期返回时间戳（精确到秒）
+ (NSString *)backTimestampSecondStringWithDate:(NSDate *)date {
    
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", a];
    return timestampString;
}

//根据日期返回时间戳（精确到秒）
+ (NSString *)backTimestampStringWithTimeString:(NSString *)timeString {
    
    NSDate *date = [self backDateWithFormatString:@"yyyy-MM-dd HH:mm:ss" timeString:timeString];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", a];
    return timestampString;
}


//根据年月日string返回时间戳
+ (NSString *)backTimestampStringWithYMDTimeString:(NSString *)timeString {
    
    NSDate *date = [self backDateWithFormatString:@"yyyy-MM-dd" timeString:timeString];
    NSTimeInterval a = [date timeIntervalSince1970];
    NSString *timestampString = [NSString stringWithFormat:@"%.0f", a];
    return timestampString;
}

//根据时间戳返回指定格式的时间
+ (NSString *)backStringWithFormatString:(NSString *)formatString timestampStringSecond:(NSString *)timestampString {
    
    NSDateFormatter *outputFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [outputFormatter setDateFormat:formatString];
    // 毫秒值转化为秒
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestampString doubleValue]];
    NSString *string = [outputFormatter stringFromDate:date];
    return string;
}


//根据日期返回自定义时间格式
+ (NSString *)customTimeStyleWithTimestampString:(NSString *)timestampString {
    
    //定义一个时间格式
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"CN"];
    NSDate *creatDate = [NSDate dateWithTimeIntervalSince1970:[timestampString intValue]];;
    return [self customTimeStyleWithDate:creatDate];
}

//根据日期返回自定义时间格式
+ (NSString *)customTimeStyleWithTimeString:(NSString *)timeString {
    
    //定义一个时间格式
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"CN"];
    
    //获取创建的时间
    NSDate *creatDate = [dateFormatter dateFromString:timeString];
    return [self customTimeStyleWithDate:creatDate];
}

//根据日期返回自定义时间格式
+ (NSString *)customTimeStyleWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [XKTimeManager timeShareManager].dateFormatter;
    //获取创建的时间
    NSDate *creatDate =date;
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    //获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //获取当前时间和传入时间的时间差
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //获取时间组件
    NSDateComponents *components = [calendar components:unit fromDate:creatDate toDate:currentDate options:NSCalendarWrapComponents];
    
    //将当前时间撤分成组件
    NSDateComponents *nowComponents = [calendar components:unit fromDate:currentDate];
    
    //将创建时间撤分成组件
    NSDateComponents *creatComponents = [calendar components:unit fromDate:creatDate];
    
    
    
    NSString *timeStr = nil;
    //判断是今年
    if (nowComponents.year == creatComponents.year) {
        //判断是这个月
        if (nowComponents.month == creatComponents.month) {
            //判断是今天
            if ([calendar isDateInToday:creatDate]) {
                //判断是一个小时之内
                if (components.hour < 1) {
                    //判断是一分钟之内
                    if (components.minute < 1) {
                        //判断是否是10秒之内
                        if (components.second < 10) {
                            timeStr = @"刚刚";
                        } else {
                            timeStr = [NSString stringWithFormat:@"%ld秒前", components.second];
                        }
                    } else {
                        timeStr = [NSString stringWithFormat:@"%ld分钟前", components.minute];
                    }
                } else {
                    timeStr = [NSString stringWithFormat:@"%ld小时前", components.hour];
                }
            } else {
                //是否是5天内
                if (nowComponents.day - creatComponents.day <= 5) {
                    //是否是昨天
                    if ([calendar isDateInYesterday:creatDate]) {
                        timeStr = @"昨天";
                    } else {
                        timeStr = [NSString stringWithFormat:@"%ld天前", nowComponents.day - creatComponents.day];
                    }
                } else {
                    [dateFormatter setDateFormat:@"MM月dd日"];
                    timeStr = [dateFormatter stringFromDate:creatDate];
                }
            }
        } else {
            [dateFormatter setDateFormat:@"MM月dd日"];
            timeStr = [dateFormatter stringFromDate:creatDate];
        }
    } else {
        //yyyy年MM月dd日 HH时mm分
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        timeStr = [dateFormatter stringFromDate:creatDate];
    }
    
    return timeStr;
}

+ (NSString *)backAgeWithBrithdayTimeStampString:(NSString *)timeString {
    
    NSString *dateStr = [self backYMDStringByStrigulaSegmentWithTimestampString:timeString];
    
    NSString *year = [dateStr substringWithRange:NSMakeRange(0, 4)];
    NSString *month = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [dateStr substringWithRange:NSMakeRange(dateStr.length-2, 2)];
    
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDateComponents *compomemts = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:nowDate];
    NSInteger nowYear = compomemts.year;
    NSInteger nowMonth = compomemts.month;
    NSInteger nowDay = compomemts.day;
    // 计算年龄
    NSInteger userAge = nowYear - year.intValue - 1;
    if ((nowMonth > month.intValue) || (nowMonth == month.intValue && nowDay >= day.intValue)) {
        userAge++;
    }
    return [NSString stringWithFormat:@"%ld",userAge];
}

@end





