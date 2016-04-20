//
//  MDMoodmon.h
//  moodMon
//
//  Created by Lee Kyu-Won on 4/4/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kComment;
extern NSString *const kYear;
extern NSString *const kMonth;
extern NSString *const kDay;
extern NSString *const kTime;
extern NSString *const kChosen1;
extern NSString *const kChosen2;
extern NSString *const kChosen3;
extern NSString *const kIsDeleted;


@interface MDMoodmon : NSObject


/* COLUME_NUM & property in sql
 0 - id / int
 1 - moodComment / varchar(150)
 2 - moodYear / year
 3 - moodDateTime / dateTime
 4 - moodChosen1 / int
 5 - moodChosen2 / int
 6 - moodChosen3 / int
 7 - isDeleted / bool
 */


@property NSString *moodComment;
@property NSInteger moodYear;
@property NSInteger moodMonth;
@property NSInteger moodDay;
@property NSString *moodTime;
@property NSUInteger moodChosen1;
@property NSUInteger moodChosen2;
@property NSUInteger moodChosen3;
@property NSNumber *isDeleted;




@end
