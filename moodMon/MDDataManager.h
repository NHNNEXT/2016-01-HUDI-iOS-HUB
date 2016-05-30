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
#import "MDDocument.h"


@interface MDDataManager : NSObject{
    BOOL hasICloud;
    NSString *dataBasePath;
    sqlite3 *moodmonDB;
}

@property(strong, nonatomic) NSString *dataBasePath;
@property(nonatomic) sqlite3 *moodmonDB;

@property NSMutableArray<MDMoodmon *> *moodCollection;
//index는 한번 만들면 지워지지 않는다.
//sql디비와 콜렉션 id 일치 
//인덱스 당 데이터는 대부분 시간순서로 되어있을 것이라 예상

/******* for iCloud ***************/
@property MDDocument *document;
@property NSURL *documentURL;

@property NSURL *ubiquityURL;
@property NSMetadataQuery *metadataQuery;

-(void)makeICloud;
- (void)startICloudSync;
- (void)metadataQueryDidFinishGathering:(NSNotification*)notification;
/**********************************/


/******** for filter ***************/
@property NSMutableArray *isChecked; //chosen in filter
@property int chosenMoodCount;
-(NSArray<MDMoodmon*>*)getFilteredMoodmons;
/**********************************/

+(MDDataManager*)sharedDataManager; //DataManager is a singleton.

- (void)createDB;
- (void)readAllFromDBAndSetCollection;
- (void)saveNewMoodMonOfComment:(NSString*)comment asFirstChosen:(int)first SecondChosen:(int)second andThirdChosen:(int)third;

-(void)saveDocument:(MDMoodmon*)moodmon;
-(void)saveIntoDBNewMoodmon:(MDMoodmon*)moodmon;
-(void)readJustSavedMoodMon;

-(void)deleteAllData;





///////////////////////////// 이하 감정 계산 메소드

-(NSUInteger)recentMood;
/*
 * representationOfMoodAtDate - 
 * 해당 날짜의 대표 감정을 숫자배열로 알려준다
 * count가 가장 큰 감정(정도 정보 포함)을 알려준다.
 * count가 동일한 갯우일 경우에만 최대 3개. 기본은 한개. 
 * count동일한 감정이 4개 이상일 때는, 정도기준 3개.
 * 정도기준에서도 4개 이상의 동점이 나올 경우에는 십의 자리가 큰 감정들 먼저 나온다. //이건 그냥 알고리즘구현으로 인해...
 */
-(NSMutableArray<NSNumber*>*)representationOfMoodAtYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day;


@end
