//
//  MDDataManger.h
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MDMoodmon.h"



@interface MDDataManger : NSObject

@property(strong, nonatomic) NSString *dataBasePath;
@property(nonatomic) sqlite3 *moodmonDB;

@property NSMutableArray<MDMoodmon *> *moodCollection;
//index는 한번 만들면 지워지지 않는다.
//sql디비와 콜렉션 id 일치 
//인덱스 당 데이터는 대부분 시간순서로 되어있을 것이라 예상


- (void)createDB;
- (void)readAllFromDBAndSetCollection;
- (void)savaNewMoodMon;

- (void)saveIntoDBNewMoodmon:(MDMoodmon*)moodmon;

-(NSUInteger)recentMood;
@end
