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



@interface MDDataManager : NSObject{
    NSString *dataBasePath;
    sqlite3 *moodmonDB;
}

@property(strong, nonatomic) NSString *dataBasePath;
@property(nonatomic) sqlite3 *moodmonDB;

@property NSMutableArray<MDMoodmon *> *moodCollection;
//index는 한번 만들면 지워지지 않는다.
//sql디비와 콜렉션 id 일치 
//인덱스 당 데이터는 대부분 시간순서로 되어있을 것이라 예상
@property NSMutableArray *isChecked; //chosen in filter
/*
 0 - angry - 11~15
 1 - happy - 21~25
 2 - sad - 31~35
 3 - excited - 41~45
 4 - exhausted - 51~55
*/
@property int chosenMoodCount;


+(MDDataManager*)sharedDataManager; //DataManager is a singleton.

- (void)createDB;
- (void)readAllFromDBAndSetCollection;
- (void)saveNewMoodMonOfComment:(NSString*)comment asFirstChosen:(int)first SecondChosen:(int)second andThirdChosen:(int)third;

- (void)saveIntoDBNewMoodmon:(MDMoodmon*)moodmon;

-(NSUInteger)recentMood;
-(NSArray<MDMoodmon*>*)getFilteredMoodmons;
//-(NSArray<MDMoodmon*)getEventStringResult;
@end
