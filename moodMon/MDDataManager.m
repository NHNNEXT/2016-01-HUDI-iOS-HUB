//
//  MDDataManger.m
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "MDDataManager.h"
#import "MDMoodmon.h"


@implementation MDDataManager



+(MDDataManager*)sharedDataManager{
    static MDDataManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}


- (instancetype)init{
    self = [super init];
    if(self){
        self.moodCollection = [[NSMutableArray alloc] init];
        [self.moodCollection insertObject:[[MDMoodmon alloc] init] atIndex:0];
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
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS moodmon(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, moodComment VARCHAR(150) NULL, moodYear YEAR NOT NULL DEFAULT 0, moodDateTime DATETIME NOT NULL, moodChosen1 INTEGER NOT NULL DEFAULT 0, moodChosen2 INTEGER NOT NULL DEFAULT 0, moodChosen3 INTEGER NOT NULL DEFAULT 0, isDeleted BOOL DEFAULT false);";
            
            /* 
             moodChosen CHECK은 만들었지만 조건이 나중에 바뀔수도 있으니, 앱내에서 확인하는 게 나을 것 같아 생략
                CHECK (moodChosen1 >=0 AND moodChosen1 <56 AND moodChosen2 >=0 AND
                        moodChosen2 <56 AND moodChosen3 >=0 AND moodChosen3 <56)
             */ //이거슨 validate
            
            
            if( sqlite3_exec(_moodmonDB, sql_stmt, NULL, NULL,&errMsg) != SQLITE_OK){
                //@"Failed to create table";
            }
            
            //@"Table is created";
            sqlite3_close(_moodmonDB);
            
        } else {
            //@"Failed to open/create datebase";
        }
        
        NSLog(@"yes1 : SQL created");

        
    } else {
       
        NSLog(@"yes1 : read data from SQL ");
         [self readAllFromDBAndSetCollection];
        
    }
    
    
    
}
- (void)readAllFromDBAndSetCollection{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
        NSLog(@"yes2 : start reading from SQL");
        NSString *querySQL = @"SELECT * FROM moodmon";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_moodmonDB, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            
            NSLog(@"yes3 : sql function in progress");
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
                NSLog(@"%d", idint);
                NSString *comment = [[NSString alloc]initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                NSInteger year = sqlite3_column_int(statement, 2);
                NSInteger dateTime = sqlite3_column_int(statement, 3);
                NSUInteger moodChosen1 = sqlite3_column_int(statement, 4);
                NSUInteger moodChosen2 = sqlite3_column_int(statement, 5);
                NSUInteger moodChosen3 = sqlite3_column_int(statement, 6);
                BOOL isDeleted = sqlite3_column_value(statement, 7);
                
                NSLog(@"is deleted : %d", isDeleted);
                
                
                MDMoodmon *moodmon = [MDMoodmon alloc];
                if(comment){
                    [moodmon setValue:comment forKey:kComment];
                }
                [moodmon setValue:[NSNumber numberWithInteger:year] forKey:kYear];
                [moodmon setValue:[NSNumber numberWithInteger:dateTime] forKey:kDateTime];
                [moodmon setValue: [NSNumber numberWithInteger:moodChosen1] forKey:kChosen1];
                [moodmon setValue: [NSNumber numberWithInteger:moodChosen2] forKey:kChosen2];
                [moodmon setValue: [NSNumber numberWithInteger:moodChosen3] forKey:kChosen3];
                
                
                if(isDeleted){
                    [moodmon setValue: @YES forKey:kIsDeleted];
                } else{
                    [moodmon setValue: @NO forKey:kIsDeleted];
                }
                
                [self.moodCollection insertObject:moodmon atIndex:idint];
                
                NSLog(@"Success to add : %@" ,[self.moodCollection objectAtIndex:idint]);
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



- (void)saveNewMoodMonOfComment:(NSString*)comment asFirstChosen:(int)first SecondChosen:(int)second andThirdChosen:(int)third{
    
    NSLog(@"yes4 : Start to save new !!!");

    
    unsigned units = NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit;
    NSDate *now = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comp = [myCal components:units fromDate:now];
    NSInteger month = [comp month];
    NSInteger day = [comp day];
    NSInteger year = [comp year];
    
    MDMoodmon *newMD = [[MDMoodmon alloc] init];
    
    [newMD setValue:[NSNumber numberWithInteger:year] forKey:kYear];
    [newMD setValue:[NSNumber numberWithInteger:day] forKey:kDateTime]; //시간정보도 추가해야함.
    [newMD setValue:@NO forKey:kIsDeleted];
    
    
    [newMD setValue:comment forKey:kComment];
    [newMD setValue: [NSNumber numberWithInt:first] forKey:kChosen1];
    [newMD setValue: [NSNumber numberWithInt:second] forKey:kChosen2];
    [newMD setValue: [NSNumber numberWithInt: third] forKey:kChosen3];
    
    
    //[newMD setValue:[[NSString alloc] initWithFormat:@"hello"] forKey:kComment]; - test
    
    [self.moodCollection insertObject:newMD atIndex:[self.moodCollection count]];
    [self saveIntoDBNewMoodmon: newMD];
    
}

- (void)saveIntoDBNewMoodmon:(MDMoodmon*)moodmon{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
        NSLog(@"yes5 : Start to save new into SQL");
        
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
        
        
        
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO moodmon(moodComment, moodDateTime, moodChosen1, moodChosen2, moodChosen3) VALUES(\"%@\",\"%ld\", %d,%d,%d);", moodmon.moodComment,  (long)moodmon.moodDateTime ,(int)moodmon.moodChosen1,(int)moodmon.moodChosen2,(int)moodmon.moodChosen3];
        // 흠.... insert문 4,5,6(>=0 && <56)은 확인하고 넣어야 해.
        
        const char* insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moodmonDB, insert_stmt, -1, &statement, NULL);
        
        
        if(sqlite3_step(statement) == SQLITE_DONE){
            NSLog(@"NEW  moodmon added %@", moodmon);
          
            
        } else {
            printf("??? %d   zzz\n", sqlite3_step(statement) );
            NSLog(@"ERRor : %s", sqlite3_errmsg(_moodmonDB));
        }
    
        
        //_status.text = @"SQL doesn't work";
        sqlite3_finalize(statement);
        sqlite3_close(_moodmonDB);
    }
    
}

-(NSUInteger)recentMood{
    
    /* 감정별 숫자 매칭
     angry - 11~15
     happy - 21~25
     sad - 31~35
     excited - 41~45
     exhausted - 51~55
    */
    
    int count = (int)[self.moodCollection count];
    int chosenCount = 0;
    int sum = 0;
    
    if(count < 5){
        for(int i = count -1 ; i >= 0 ; i--){
            MDMoodmon *temp = [self.moodCollection objectAtIndex:i];
            if((int)temp.moodChosen1) chosenCount ++;
            if((int)temp.moodChosen2) chosenCount ++;
            if((int)temp.moodChosen3) chosenCount ++;
            sum += (int)temp.moodChosen1;
            sum += (int)temp.moodChosen2;
            sum += (int)temp.moodChosen3;
        }
    } else {
        for(int i = count-1 ; i >= (count-1)-5 ; i--){
            MDMoodmon *temp = [self.moodCollection objectAtIndex:i];
            if((int)temp.moodChosen1) chosenCount ++;
            if((int)temp.moodChosen2) chosenCount ++;
            if((int)temp.moodChosen3) chosenCount ++;
            sum += (int)temp.moodChosen1;
            sum += (int)temp.moodChosen2;
            sum += (int)temp.moodChosen3;
        }
    }
    
    return (int)sum/(int)chosenCount;
}



@end
