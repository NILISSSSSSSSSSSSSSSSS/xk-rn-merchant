//
//  XKTimeSeparateHelper.h
//  TimeSeparate
//
//  Created by hupan on 2018/8/2.
//  Copyright © 2018年 Tears. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XKTimeSeparateHelper : NSObject


/**
 根据NSDate 返回年月 字符串 通过汉字分割
 
 @param date date
 @return 返回年月，通过汉字分割
 */
+ (NSString *)backYMStringByChineseSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月 Date 通过汉字分割
 
 @param timeString timeString
 @return 返回年月，通过汉字分割
 */
+ (NSDate *)backYMDateByChineseSegmentWithTimeString:(NSString *)timeString;



/**
 根据时间戳string 返回年月 字符串 通过汉字分割
 
 @param timestampString timestampString
 @return 返回年月，通过汉字分割
 */
+ (NSString *)backYMStringByChineseSegmentWithTimestampString:(NSString *)timestampString;



/**
 根据NSDate 返回年月日 字符串 通过汉字分割
 
 @param date date
 @return 返回年月日，通过汉字分割
 */
+ (NSString *)backYMDStringByChineseSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日 Date 通过汉字分割
 
 @param timeString timeString
 @return 返回年月日，通过汉字分割
 */
+ (NSDate *)backYMDDateByChineseSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日 字符串 通过汉字分割
 
 @param timestampString timestampString
 @return 返回年月日，通过汉字分割
 */
+ (NSString *)backYMDStringByChineseSegmentWithTimestampString:(NSString *)timestampString;


/**
 根据NSDate 返回年月日时分字符串 通过汉字分割
 
 @param date date
 @return 返回年月日时分，通过汉字分割
 */
+ (NSString *)backYMDHMStringByChineseSegmentWithDate:(NSDate *)date;

/**
 根据NSDate 返回年月日 周 时分字符串 通过汉字分割
 
 @param date date
 @return 返回年月日周时分，通过汉字分割
 */
+ (NSString *)backYMDWeekHMStringByChineseSegmentWithDate:(NSDate *)date;
/**
 根据NSDate 返回年月日 周 时分字符串 通过汉字分割
 
 @param date date
 @return 返回年月日周时分，通过汉字分割
 */
+ (NSString *)backYMDWeakHMStringByVirguleSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日时分 Date 通过汉字分割
 
 @param timeString timeString
 @return 返回年月日时分，通过汉字分割
 */
+ (NSDate *)backYMDHMDateByChineseSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日时分字符串 通过汉字分割
 
 @param timestampString timestampString
 @return 返回年月日时分，通过汉字分割
 */
+ (NSString *)backYMDHMStringByChineseSegmentWithTimestampString:(NSString *)timestampString;


/**
 根据NSDate 返回年月日时分秒字符串 通过汉字分割
 
 @param date date
 @return 返回年月日时分秒，通过汉字分割
 */
+ (NSString *)backYMDHMSStringByChineseSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日时分秒 Date 通过汉字分割
 
 @param timeString timeString
 @return 返回年月日时分秒，通过汉字分割
 */
+ (NSDate *)backYMDHMSDateByChineseSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日时分秒字符串 通过汉字分割
 
 @param timestampString timestampString
 @return 返回年月日时分秒，通过汉字分割
 */
+ (NSString *)backYMDHMSStringByChineseSegmentWithTimestampString:(NSString *)timestampString;






/**
 根据NSDate 返回年月 字符串 通过斜线分割
 
 @param date date
 @return 返回年月，通过斜线分割
 */
+ (NSString *)backYMStringByVirguleSegmentWithDate:(NSDate *)date;



/**
 根据时间字符串 返回年月 Date 通过斜线分割
 
 @param timeString timeString
 @return 返回年月，通过斜线分割
 */
+ (NSDate *)backYMDateByVirguleSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月 字符串 通过斜线分割
 
 @param timestampString timestampString
 @return 返回年月，通过斜线分割
 */
+ (NSString *)backYMStringByVirguleSegmentWithTimestampString:(NSString *)timestampString;


/**
 根据NSDate 返回年月日 字符串 通过斜线分割
 
 @param date date
 @return 返回年月日，通过斜线分割
 */
+ (NSString *)backYMDStringByVirguleSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日 Date 通过斜线分割
 
 @param timeString timeString
 @return 返回年月日，通过斜线分割
 */
+ (NSDate *)backYMDDateByVirguleSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日 字符串 通过斜线分割
 
 @param timestampString timestampString
 @return 返回年月日，通过斜线分割
 */
+ (NSString *)backYMDStringByVirguleSegmentWithTimestampString:(NSString *)timestampString;



/**
 根据NSDate 返回年月日时分 字符串 通过斜线分割
 
 @param date date
 @return 返回年月日时分，通过斜线分割
 */
+ (NSString *)backYMDHMStringByVirguleSegmentWithDate:(NSDate *)date;



/**
 根据时间字符串 返回年月日时分 Date 通过斜线分割
 
 @param timeString timeString
 @return 返回年月日时分，通过斜线分割
 */
+ (NSDate *)backYMDHMDateByVirguleSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日时分 字符串 通过斜线分割
 
 @param timestampString timestampString
 @return 返回年月日时分，通过斜线分割
 */
+ (NSString *)backYMDHMStringByVirguleSegmentWithTimestampString:(NSString *)timestampString;

/**
 根据时间戳string 返回年月日字符串 通过点分割
 
 @param timestampString timestampString
 @return 返回年月日，通过点分割
 */
+ (NSString *)backYMDHMStringByPointWithTimestampString:(NSString *)timestampString;

/**
 根据NSDate 返回年月日时分秒 字符串 通过斜线分割
 
 @param date date
 @return 返回年月日时分，通过斜线分割
 */
+ (NSString *)backYMDHMSStringByVirguleSegmentWithDate:(NSDate *)date;



/**
 根据时间字符串 返回年月日时分秒 Date 通过斜线分割
 
 @param timeString timeString
 @return 返回年月日时分，通过斜线分割
 */
+ (NSDate *)backYMDHMSDateByVirguleSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日时分秒 字符串 通过斜线分割
 
 @param timestampString timestampString
 @return 返回年月日时分，通过斜线分割
 */
+ (NSString *)backYMDHMSStringByVirguleSegmentWithTimestampString:(NSString *)timestampString;



/**
 根据NSDate 返回年月 字符串 通过短横线分割
 
 @param date date
 @return 返回年月，通过短横线分割
 */
+ (NSString *)backYMStringByStrigulaSegmentWithDate:(NSDate *)date;



/**
 根据时间字符串 返回年月 Date 通过短横线分割
 
 @param timeString timeString
 @return 返回年月，通过短横线分割
 */
+ (NSDate *)backYMDateByStrigulaSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月 字符串 通过短横线分割
 
 @param timestampString timestampString
 @return 返回年月，通过短横线分割
 */
+ (NSString *)backYMStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString;



/**
 根据NSDate 返回年月日 字符串 通过短横线分割
 
 @param date date
 @return 返回年月日，通过短横线分割
 */
+ (NSString *)backYMDStringByStrigulaSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日 Date 通过短横线分割
 
 @param timeString timeString
 @return 返回年月日，通过短横线分割
 */
+ (NSDate *)backYMDDateByStrigulaSegmentWithTimeString:(NSString *)timeString;


/**
 根据时间戳string 返回年月日 字符串 通过短横线分割
 
 @param timestampString timestampString
 @return 返回年月日，通过短横线分割
 */
+ (NSString *)backYMDStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString;


/**
 根据NSDate 返回年月日时分 字符串 通过短横线分割
 
 @param date date
 @return 返回年月日时分，通过短横线分割
 */
+ (NSString *)backYMDHMStringByStrigulaSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日时分 Date 通过短横线分割
 
 @param timeString timeString
 @return 返回年月日时分，通过短横线分割
 */
+ (NSDate *)backYMDHMDateByStrigulaSegmentWithTimeString:(NSString *)timeString;



/**
 根据时间戳string 返回年月日时分 字符串 通过短横线分割
 
 @param timestampString timestampString
 @return 返回年月日时分，通过短横线分割
 */
+ (NSString *)backYMDHMStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString;



/**
 根据NSDate 返回年月日时分秒 字符串 通过短横线分割
 
 @param date date
 @return 返回年月日时分秒，通过短横线分割
 */
+ (NSString *)backYMDHMSStringByStrigulaSegmentWithDate:(NSDate *)date;


/**
 根据时间字符串 返回年月日时分秒 Date 通过短横线分割
 
 @param timeString timeString
 @return 返回年月日时分秒，通过短横线分割
 */
+ (NSDate *)backYMDHMSDateByStrigulaSegmentWithTimeString:(NSString *)timeString;



/**
 根据时间戳string 返回年月日时分秒 字符串 通过短横线分割
 
 @param timestampString timestampString
 @return 返回年月日时分秒，通过短横线分割
 */
+ (NSString *)backYMDHMSStringByStrigulaSegmentWithTimestampString:(NSString *)timestampString;
//年月日时分秒
+ (NSString *)backYMDHMSSStringByVirguleSegmentWithTimestampString:(NSString *)timestampString;

/**
 根据NSDate 返回年 字符串
 
 @param date date
 @return 根据NSDate 返回年 字符串
 */
+ (NSString *)backYearStringWithDate:(NSDate *)date;


/**
 根据NSDate 返回月 字符串
 
 @param date date
 @return 根据NSDate 返回月 字符串
 */
+ (NSString *)backMonthStringWithDate:(NSDate *)date;


/**
 根据NSDate 返回日 字符串
 
 @param date date
 @return 根据NSDate 返回日 字符串
 */
+ (NSString *)backDayStringWithDate:(NSDate *)date;


/**
 根据NSDate 返回月日 字符串
 
 @param date date
 @return 根据NSDate 返回月日 字符串
 */
+ (NSString *)backMonthAndDayStringWithDate:(NSDate *)date;


/**
 根据NSDate 返回时分秒 字符串
 
 @param date date
 @return 根据NSDate 返回时分秒 字符串
 */
+ (NSString *)backHMSStringWithDate:(NSDate *)date;

/**
 根据NSDate 返回时 字符串
 
 @param date date
 @return 根据NSDate 返回时 字符串
 */
+ (NSString *)backHStringWithDate:(NSDate *)date;

/**
 根据NSDate 返回星期几 字符串
 
 @param date date
 @return 根据NSDate 返回星期几 字符串
 */
+ (NSString *)backWeekStringWithDate:(NSDate *)date;


/**
 计算指定日期 指定天数 后的新日期
 
 @param days days
 @param timeString timeString
 @return 计算指定日期 指定天数 后的新日期
 */
+ (NSString *)backNewDateWithDays:(NSInteger)days fromTimeString:(NSString *)timeString;



/**
 返回两日期相差天数

 @param startDateStr 开始时期
 @param endDateStr 结束时间
 @return 返回两个日期相差天数
 */
+ (NSInteger)backDaysWithStartDateStr:(NSString *)startDateStr endDateStr:(NSString *)endDateStr;


/**
 返回指定时间戳与当前系统时间的时间差（秒）
 
 @param stampString 时间戳
 @return 返回指定时间戳与当前系统时间的时间差（秒）
 */
+ (NSInteger)backSecondWithTimestampString:(NSString *)stampString;

/**
 根据日期Date 返回时间戳（精确到毫秒）

 @param date date
 @return 根据日期返回时间戳（精确到毫秒）
 */
+ (NSString *)backTimestampStringWithDate:(NSDate *)date;

//根据日期返回时间戳（精确到秒）
+ (NSString *)backTimestampSecondStringWithDate:(NSDate *)date;

/**
 根据时间timeString 返回时间戳（
 
 @param timeString timeString
 @return 根据时间timeString 返回时间戳
 */
+ (NSString *)backTimestampStringWithTimeString:(NSString *)timeString;


/**
 根据年月日string返回时间戳
 
 @param timeString timeString
 @return 根据年月日string返回时间戳
 */
+ (NSString *)backTimestampStringWithYMDTimeString:(NSString *)timeString;


/**
 根据时间timeString(2018-08-09 11:20:32:23) 返回自定义时间（xx小时前）
 
 @param timeString timeString
 @return 根据时间timeString(2018-08-09 11:20:32:23) 返回自定义时间（xx小时前）
 */
+ (NSString *)customTimeStyleWithTimeString:(NSString *)timeString;

/**
 根据时间戳timestampString(127938373746) 返回自定义时间（xx小时前）
 
 @param timestampString timestampString
 @return 根据时间戳timestampString(127938373746) 返回自定义时间（xx小时前）
 */
+ (NSString *)customTimeStyleWithTimestampString:(NSString *)timestampString;

/**根据时间戳返回指定格式的时间 秒级时间戳*/
+ (NSString *)backStringWithFormatString:(NSString *)formatString timestampStringSecond:(NSString *)timestampString;

/**获取年龄*/
+ (NSString *)backAgeWithBrithdayTimeStampString:(NSString *)timeString;
@end
    
    
    
    
