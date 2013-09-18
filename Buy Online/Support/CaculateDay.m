//
//  CaculateDay.m
//  Buy Online
//
//  Created by Nguyen Huy Hung on 9/9/13.
//  Copyright (c) 2013 Nguyen Huy Hung. All rights reserved.
//

#import "CaculateDay.h"

@implementation CaculateDay
+(NSString *)caculateDate:(int)day month:(int)month year:(int)year
{
    //int cMonth = [CaculateDay changeMonth:month];
    NSString *cDay;
    int songay,thu;
    int a[]={31,28,31,30,31,30,31,31,30,31,30,31};
    songay=((year-1)%7)*365+(year-1)/4;
    
    if(year%4==0) a[1]=29;
    for(int i=0;i<(month-1);i++) songay+=a[i];
    songay+=day;
    thu=songay%7;
    cDay = [CaculateDay changeDay:thu];

    return cDay;
}
+(NSString *)changeMonth : (int)month
{
    NSString *cMonth;
    if (month == 1) {
        cMonth = @"JANUARY";
    }else if (month ==2){
        cMonth = @"FEBRUARY";
    }else if (month ==3){
        cMonth = @"MARCH";
    }else if (month ==4){
        cMonth = @"APRIL";
    }else if (month ==5){
        cMonth = @"MAY";
    }else if (month ==6){
        cMonth = @"JUNE";
    }else if (month ==7){
        cMonth = @"JULY";
    }else if (month ==8){
        cMonth = @"AUGUST";
    }else if (month ==9){
        cMonth = @"SEPTEMBER";
    }else if (month ==10){
        cMonth = @"OCTORBER";
    }else if (month ==11){
        cMonth = @"NOVEMBER";
    }else {
        cMonth = @"DECEMBER";
    }
    return cMonth;
}

+(NSString *)changeDay : (int)day
{
    NSString *cDay;
    if (day == 2) {
        cDay = @"MON";
    }else if (day == 3){
        cDay = @"TUE";
    }else if (day == 4){
        cDay = @"WED";
    }else if (day == 5){
        cDay = @"THU";
    }else if (day == 6){
        cDay = @"FRI";
    }else if (day == 0){
        cDay = @"SAT";
    }else if (day == 1){
        cDay = @"SUN";
    }else{
        cDay = @"WRONG DAY";
    }
    return cDay;
}

@end
