//
//  MDMoodmon.m
//  moodMon
//
//  Created by Lee Kyu-Won on 4/4/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "MDMoodmon.h"
#import "MDDataManager.h"

NSString *const kComment = @"moodComment";
NSString *const kYear = @"moodYear";
NSString *const kMonth = @"moodMonth";
NSString *const kDay = @"moodDay";
NSString *const kTime = @"moodTime";
NSString *const kChosen1 = @"moodChosen1";
NSString *const kChosen2 = @"moodChosen2";
NSString *const kChosen3 = @"moodChosen3";
NSString *const kIsDeleted = @"isDeleted";


@implementation MDMoodmon

-(instancetype)init{
    self = [super self];
    if(self){
        [self setMoodYear:0];
        [self setValue:@NO forKey:kIsDeleted];
        
    }
    return self;
}



@end