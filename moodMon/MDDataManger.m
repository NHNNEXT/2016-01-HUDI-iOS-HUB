//
//  MDDataManger.m
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "MDDataManger.h"

NSString *const kComment = @"commment";
NSString *const kYear = @"year";
NSString *const kDateTime = @"dateTime";
NSString *const kChosen1 = @"chosenMood1";
NSString *const kChosen2 = @"chosenMood2";
NSString *const kChosen3 = @"chosenMood3";
NSString *const kIsDeleted = @"deleted";


@implementation MDDataManger


- (instancetype)init{
    self = [super init];
    if(self){
        self.moodCollection = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)createDB{
    
    NSString *docsDir;
    NSArray *dirPath;
    
    dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPath[0];
    
    _dataBasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"moodmon.db"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if( [filemgr fileExistsAtPath:_dataBasePath] == NO){
        NSLog(@"no db");
        
        const char *dbpath = [_dataBasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_moodmonDB) == SQLITE_OK){
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS moodmon(id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, moodComent VARCHAR(150) NULL, moodYear YEAR NOT NULL DEFAULT 0, moodDateTime DATETIME NOT NULL, moodChosen1 INT NOT NULL DEFAULT 0, moodChosen2 INT NOT NULL DEFAULT 0, moodChosen3 INT NOT NULL DEFAULT 0, isDeleted BOOL DEFAULT false);";
            
            /* 
             moodChosen CHECK은 만들었지만 조건이 나중에 바뀔수도 있으니, 앱내에서 확인하는 게 나을 것 같아 생략
                CHECK (moodChosen1 >=0 AND moodChosen1 <56 AND moodChosen2 >=0 AND
                        moodChosen2 <56 AND moodChosen3 >=0 AND moodChosen3 <56)
             */ //이거슨 kvc의 validate
            
            
            if( sqlite3_exec(_moodmonDB, sql_stmt, NULL, NULL,&errMsg) != SQLITE_OK){
                //@"Failed to create table";
            }
            
            //@"Table is created";
            sqlite3_close(_moodmonDB);
            
        } else {
            //@"Failed to open/create datebase";
        }
        
    }
    
}
- (void)readAllFromDBAndSetCollection{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
        NSLog(@"yes");
        NSString *querySQL = @"SELECT * FROM moodmon";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_moodmonDB, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            
            /* COLUME_NUM & property
                0 - id / int
                1 - moodComment / varchar(150)
                2 - moodYear / year
                3 - moodDateTime / dateTime
                4 - moodChosen1 / int
                5 - moodChosen2 / int
                6 - moodChosen3 / int
                7 - isDeleted / bool
             */
            
            if(sqlite3_step(statement) == SQLITE_ROW){
                
                int idint = sqlite3_column_int(statement, 0);
                
                NSString *comment = [[NSString alloc]initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                NSString *year = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 2)];
                 NSString *dateTime = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 3)];
                int moodChosen1 = sqlite3_column_int(statement, 4);
                int moodChosen2 = sqlite3_column_int(statement, 5);
                int moodChosen3 = sqlite3_column_int(statement, 6);
                BOOL isDeleted = sqlite3_column_value(statement, 7);
                
                //NSLog(@"is deleted : %@", (bool)isDeleted);
                
                NSMutableDictionary *moodmon = [NSMutableDictionary alloc];
                [moodmon setValue:comment forKey:kComment];
                [moodmon setValue:year forKey:kYear];
                [moodmon setValue:dateTime forKey:kDateTime];
                [moodmon setValue: [NSNumber numberWithInt:moodChosen1] forKey:kChosen1];
                [moodmon setValue: [NSNumber numberWithInt:moodChosen2] forKey:kChosen2];
                [moodmon setValue: [NSNumber numberWithInt:moodChosen3] forKey:kChosen3];
              //  [moodmon setValue: (bool)isDeleted forKey:kIsDeleted];
                
                [self.moodCollection insertObject:moodmon atIndex:idint];
                
                NSLog(@"added : %@" ,[self.moodCollection objectAtIndex:idint]);
                //@"SUCCESS";
            } else {
                //@"FAIL";
                
            }
            
            sqlite3_finalize(statement);
        }
        
        //_status.text = @"SQL doesn't work";
        
        sqlite3_close(_moodmonDB);
    }

    
}

- (void)saveNewMoodmonIntoDB{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
        NSLog(@"yes");
        
        /* COLUME_NUM & property
         0 - id / int
         1 - moodComment / varchar(150)
         2 - moodYear / year
         3 - moodDateTime / dateTime
         4 - moodChosen1 / int
         5 - moodChosen2 / int
         6 - moodChosen3 / int
         7 - isDeleted / bool
         */
    

        NSString *insertSQL =  @"INSERT INTO moodmon (moodComent, moodYear, moodDat VALUES(\"%@\", \"%@\", \"%@\")";
        // 흠.... insert문 4,5,6(>=0 && <56)은 확인하고 넣어야 해.
        
        const char* insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moodmonDB, insert_stmt, -1, &statement, NULL);
        if(sqlite3_step(statement) == SQLITE_DONE){
            //@"NEW  moodmon added";
          
            
        } else {
            //@"Failed to add";
        }
        
        //_status.text = @"SQL doesn't work";
        sqlite3_finalize(statement);
        sqlite3_close(_moodmonDB);
    }
    
}



@end
