//
//  MDDataManger.h
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MDDataManger : NSObject

@property(strong, nonatomic) NSString *dataBasePath;
@property(nonatomic) sqlite3 *moodmonDB;

//@property(strong, nonatomic) NSMutableDictionary
//DATAMODEL;
//key-value coding!


- (void)createDB;
- (void)readAllFromDBAndSetCollection;
- (void)saveNewMoodmonIntoDB; //and collection

//-recentMoodFromCollection

@end
