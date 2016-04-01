//
//  MDDataManger.h
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


extern NSString *const kComment;
extern NSString *const kYear;
extern NSString *const kDateTime;
extern NSString *const kChosen1;
extern NSString *const kChosen2;
extern NSString *const kChosen3;
extern NSString *const kIsDeleted;

@interface MDDataManger : NSObject

@property(strong, nonatomic) NSString *dataBasePath;
@property(nonatomic) sqlite3 *moodmonDB;

@property NSMutableArray *moodCollection;

- (void)createDB;
- (void)readAllFromDBAndSetCollection;
- (void)saveNewMoodmonIntoDB; //and collection

//-recentMoodFromCollection

@end
