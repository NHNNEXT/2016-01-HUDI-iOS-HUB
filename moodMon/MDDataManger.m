//
//  MDDataManger.m
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "MDDataManger.h"

@implementation MDDataManger


- (instancetype)init{
    self = [super init];
    if(self){
        //_dir
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
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS moodmon(id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, moodComent VARCHAR(150) NULL, moodYear YEAR NOT NULL DEFAULT 0, moodDate DATETIME NOT NULL, moodChosen1 INT NOT NULL DEFAULT 0, moodChosen2 INT NOT NULL DEFAULT 0, moodChosen3 INT NOT NULL DEFAULT 0);";
            
            /* 
             moodChosen CHECK은 만들었지만 조건이 나중에 바뀔수도 있으니, 앱내에서 확인하는 게 나을 것 같아 생략
                CHECK (moodChosen1 >=0 AND moodChosen1 <56 AND moodChosen2 >=0 AND
                        moodChosen2 <56 AND moodChosen3 >=0 AND moodChosen3 <56)
             */
            
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
        NSLog(@"yes ");
        NSString *querySQL = @"SELECT * FROM moodmon";
        
        const *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_moodmonDB, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            
            /* COLUME_NUM & property
                0 - id
                1 - moodComment
                2 - moodYear
                3 - moodDate
                4 - moodChosen1
                5 - moodChosen2
                6 - moodChosen3
             */
            
            if(sqlite3_step(statement) == SQLITE_ROW){
                NSString *addressField = [[NSString alloc]initWithUTF8String:(const char*) sqlite3_column_text(statement, 0)];
                NSString *phoneField = [[NSString alloc] initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                
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
         0 - id
         1 - moodComment
         2 - moodYear
         3 - moodDate
         4 - moodChosen1
         5 - moodChosen2
         6 - moodChosen3
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
