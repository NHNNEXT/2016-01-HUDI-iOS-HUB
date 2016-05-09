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
        self.isChecked = [@[ @NO, @NO,@NO,@NO,@NO ] mutableCopy];
        self.chosenMoodCount = 0;
        NSString *docsDir;
        NSArray *dirPath;
        
        dirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = dirPath[0];
        
        _dataBasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"moodmon.sqlite"]];
    }
    return self;
}

- (void)createDB{
    
    
    //sqlite3_stmt *statement;

    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
   // if( [filemgr fileExistsAtPath:_dataBasePath] == NO){
//        NSLog(@"no db");
    
        const char *dbpath = [_dataBasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_moodmonDB) == SQLITE_OK){
            char *errMsg;
            
//            NSLog(@"no1 : open DB" );
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS moodmon(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, moodComment VARCHAR(150) NULL, moodDate Datetime NOT NULL, moodChosen1 INTEGER NOT NULL DEFAULT 0, moodChosen2 INTEGER NOT NULL DEFAULT 0, moodChosen3 INTEGER NOT NULL DEFAULT 0, isDeleted BOOL DEFAULT false);";
            
            /* 
             moodChosen CHECK은 만들었지만 조건이 나중에 바뀔수도 있으니, 앱내에서 확인하는 게 나을 것 같아 생략
                CHECK (moodChosen1 >=0 AND moodChosen1 <56 AND moodChosen2 >=0 AND
                        moodChosen2 <56 AND moodChosen3 >=0 AND moodChosen3 <56)
             */ //이거슨 validate
            
            
            if( sqlite3_exec(_moodmonDB, sql_stmt, NULL, NULL,&errMsg) != SQLITE_OK){
                            NSLog(@"ERRor : not created" );
            }
            
            //@"Table is created";
            sqlite3_close(_moodmonDB);
            
        } else {
            //@"Failed to open/create datebase";
        }
        
//        NSLog(@"yes1 : SQL created");

        
    //} else {
       
//        NSLog(@"yes1 : read data from SQL ");
         [self readAllFromDBAndSetCollection];
        
    //}
    
    
    
}
- (void)readAllFromDBAndSetCollection{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
//        NSLog(@"yes2 : start reading from SQL");
        NSString *querySQL = @"SELECT * FROM moodmon";
        
        const char *query_stmt = [querySQL UTF8String];
        
        if(sqlite3_prepare_v2(_moodmonDB, query_stmt, -1, &statement, NULL) == SQLITE_OK){
            
//            NSLog(@"yes3 : sql function in progress");
            /* COLUME_NUM & property
                0 - id / int
                1 - moodComment / varchar(150)
                2 - moodDate / dateTime
                3 - moodChosen1 / int
                4 - moodChosen2 / int
                5 - moodChosen3 / int
                6 - isDeleted / bool
             */
            
            while(sqlite3_step(statement) <= SQLITE_ROW){
                
                int idint = sqlite3_column_int(statement, 0);
                if(idint == 0) continue;
                
//                NSLog(@"INDEX %d is saving", idint);
                NSString *comment = [[NSString alloc]initWithUTF8String:(const char*) sqlite3_column_text(statement, 1)];
                NSUInteger moodChosen1 = sqlite3_column_int(statement, 3);
                NSUInteger moodChosen2 = sqlite3_column_int(statement, 4);
                NSUInteger moodChosen3 = sqlite3_column_int(statement, 5);
                BOOL isDeleted = sqlite3_column_value(statement, 6);
                
                NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
                [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *myDate =[dateFormat dateFromString:[NSString stringWithUTF8String:(char *) sqlite3_column_text(statement, 2)]];
                
                
                unsigned units = NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitYear| NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
                NSCalendar *myCal = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *comp = [myCal components:units fromDate:myDate];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                //formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
                NSString *timeString = [formatter stringFromDate:myDate];
            
                MDMoodmon *moodmon = [MDMoodmon alloc];
                
                if(comment){
                    [moodmon setValue:comment forKey:kComment];
                }
                [moodmon setValue:[NSNumber numberWithInteger:[comp year]] forKey:kYear];
                [moodmon setValue:[NSNumber numberWithInteger:[comp month]] forKey:kMonth];
                [moodmon setValue:[NSNumber numberWithInteger:[comp day]] forKey:kDay];
                [moodmon setValue: timeString forKey:kTime];

                [moodmon setValue: [NSNumber numberWithInteger:moodChosen1] forKey:kChosen1];
                [moodmon setValue: [NSNumber numberWithInteger:moodChosen2] forKey:kChosen2];
                [moodmon setValue: [NSNumber numberWithInteger:moodChosen3] forKey:kChosen3];
                
                
                if(isDeleted){
                    [moodmon setValue: @YES forKey:kIsDeleted];
                } else{
                    [moodmon setValue: @NO forKey:kIsDeleted];
                }
                
                [self.moodCollection insertObject:moodmon atIndex:idint];
                //@"SUCCESS";
            }
            
            
            
            sqlite3_finalize(statement);
        }
        
        //_status.text = @"SQL doesn't work";
        
        sqlite3_close(_moodmonDB);
    }

}



- (void)saveNewMoodMonOfComment:(NSString*)comment asFirstChosen:(int)first SecondChosen:(int)second andThirdChosen:(int)third{
    
//    NSLog(@"yes4 : Start to save new !!!");
    
    if(!first){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"moodNotChosen" object:self userInfo:@{@"message" : @"please choose a moodmon"}];
    }
    if(first < 0 || second < 0 || third < 0){
         [[NSNotificationCenter defaultCenter] postNotificationName:@"moodNotChosen" object:self userInfo:@{@"message" : @"wrong input"}];
    }
    /*
     mood int 확인,
     MDDateManager saveNewMoodMonOfComment~ 메소드에서 하고 있습니다.
     여기서 하는 게 제일 좋은 건지는 아직 모르겠네요. 방어차 남겨 놓는 것도 좋은 것 같아요.
     
     그 전에, 위 메소드 부르기 전에도 체크 하는 게 좋을 것 같아요~
     newMoodmon view에서 mood int가 어떻게 정해지는 지, 어디에 그 데이터가 남는지 아직 모르겠지만, 해당 코드 완성되면, 이 부분 한번 정하면 좋을 것 같아요.
    */
    
    
    unsigned units = NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitYear| NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [myCal components:units fromDate:now];
    NSInteger year = [comp year];
    NSInteger month = [comp month];
    NSInteger day = [comp day];
    NSInteger hour = [comp hour];
    NSInteger minute = [comp minute];
    NSInteger secondTime = [comp second];
    

    NSString *timeString = [NSString stringWithFormat:@"%ld:%ld:%ld", hour, minute, secondTime];
   
   // NSLog(@"month : %ld, day : %ld, year : %ld , %ld: %ld: %ld", (long)month,  day, (long)year, hour, minute, (long)secondTime);
    MDMoodmon *newMD = [[MDMoodmon alloc] init];
    
    [newMD setValue:[NSNumber numberWithInteger:year] forKey:kYear];
    [newMD setValue:[NSNumber numberWithInteger:month] forKey:kMonth];
    [newMD setValue:[NSNumber numberWithInteger:day] forKey:kDay];
    [newMD setValue:timeString forKey:kTime];
    [newMD setValue:@NO forKey:kIsDeleted];
    
    
    [newMD setValue: comment forKey:kComment];
    [newMD setValue: [NSNumber numberWithInt: first] forKey:kChosen1];
    [newMD setValue: [NSNumber numberWithInt: second] forKey:kChosen2];
    [newMD setValue: [NSNumber numberWithInt: third] forKey:kChosen3];
    
    
    //[newMD setValue:[[NSString alloc] initWithFormat:@"hello"] forKey:kComment]; - test
    
    [self.moodCollection insertObject:newMD atIndex:[self.moodCollection count]];
    [self saveIntoDBNewMoodmon: newMD];
    
}

- (void)saveIntoDBNewMoodmon:(MDMoodmon*)moodmon{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_dataBasePath UTF8String];
    
    if(sqlite3_open( dbpath, &_moodmonDB) == SQLITE_OK ){
//        NSLog(@"yes5 : Start to save new into SQL");
        
        /* COLUME_NUM & property
         0 - id / int
         1 - moodComment / varchar(150)
         2 - moodDate / dateTime
         3 - moodChosen1 / int
         4 - moodChosen2 / int
         5 - moodChosen3 / int
         6 - isDeleted / bool
         */
        
        NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld %@", moodmon.moodYear, moodmon.moodMonth, moodmon.moodDay, moodmon.moodTime] ;
        
//        NSLog(@"now : %@",dateString);
        NSString *insertSQL =  [NSString stringWithFormat:@"INSERT INTO moodmon(moodComment, moodDate, moodChosen1, moodChosen2, moodChosen3) VALUES(\"%@\",\"%@\", %d,%d,%d);", moodmon.moodComment,  dateString ,(int)moodmon.moodChosen1,(int)moodmon.moodChosen2,(int)moodmon.moodChosen3];
        // 흠.... insert문 4,5,6(>=0 && <56)은 확인하고 넣어야 해.
        
//        NSLog(@"demand : %@", insertSQL);
        const char* insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moodmonDB, insert_stmt, -1, &statement, NULL);
        
        
        if(sqlite3_step(statement) == SQLITE_DONE){
//            NSLog(@"NEW  moodmon added, the time of %@", moodmon.moodTime);
          
            
        } else {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"failTosaveIntoSql" object:self userInfo:@{@"message" : @"Fail to save into Sqlite"}];
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
   // NSLog(@"count : %d",count);
    if(count == 1) return 0;
    int chosenCount = 0;
    int sum[5] = {0,0,0,0,0};
    
    if(count < 6){
        for(int i = count -1 ; i >= 1 ; i--){
           // NSLog(@"count : %d",count);
            MDMoodmon *temp = [self.moodCollection objectAtIndex:i];
            if((int)temp.moodChosen1 ) {
                chosenCount ++;
                sum[((int)temp.moodChosen1/10)-1] += (int)temp.moodChosen1 % 10;
            }
            
            if((int)temp.moodChosen2 ){
                chosenCount ++;
                sum[((int)temp.moodChosen2/10)-1] += (int)temp.moodChosen2 % 10;
            }
            if((int)temp.moodChosen3 ) {
                chosenCount ++;
                sum[((int)temp.moodChosen3/10)-1] += (int)temp.moodChosen3 % 10;
            }
          
            
        }
    } else {
        for(int i = count-1 ; i >= (count-1)-5 ; i--){
            MDMoodmon *temp = [self.moodCollection objectAtIndex:i];
            if((int)temp.moodChosen1 ) {
                
                chosenCount ++;
                sum[((int)temp.moodChosen1/10)-1] += (int)temp.moodChosen1 % 10;
            }
            
            if((int)temp.moodChosen2 ){
                chosenCount ++;
                sum[((int)temp.moodChosen2/10)-1] += (int)temp.moodChosen2 % 10;
            }
            if((int)temp.moodChosen3 ) {
                chosenCount ++;
                sum[((int)temp.moodChosen3/10)-1] += (int)temp.moodChosen3 % 10;
            }
        }
    }
    
    
    int bigIndex = 0;
    for(int i = 0 ; i < 5 ; i++){
        if(sum[i] > sum[bigIndex]) bigIndex = i;
    }
   // NSLog(@"count : %d",bigIndex);
    //NSLog(@"%d %d %d %d %d ", sum[0], sum[2])

    
    return 10 *(bigIndex + 1) + ((int)sum[bigIndex]/(int)chosenCount);
}

/*
 0 - angry - 11~15
 1 - happy - 21~25
 2 - sad - 31~35
 3 - excited - 41~45
 4 - exhausted - 51~55
 */
-(NSArray<MDMoodmon*>*)getFilteredMoodmons{
    
    NSMutableArray *result = [[NSMutableArray alloc]init];
    NSMutableSet *chosenMoodInteger = [[NSMutableSet alloc]initWithCapacity:_chosenMoodCount];
    
    for(int i = 0 ; i<5 ; i++){
        if ([_isChecked[i] isEqual:@YES]){
            [chosenMoodInteger addObject: [NSNumber numberWithInteger:(i+1)]];
        }
    }

    
    NSEnumerator *enumerator = [_moodCollection objectEnumerator];
    MDMoodmon *object;
    NSMutableSet *objectInteger =[[NSMutableSet alloc]init];
    while ((object = [enumerator nextObject])) {
        NSNumber *first = [NSNumber numberWithInteger:[[object valueForKey:kChosen1] integerValue]/ 10];
        [objectInteger addObject:  first];
        NSNumber *second = [NSNumber numberWithInteger:[[object valueForKey:kChosen2] integerValue]/ 10];
        [objectInteger addObject:  second];
        NSNumber *third = [NSNumber numberWithInteger:[[object valueForKey:kChosen3] integerValue]/ 10];
        [objectInteger addObject:  third];
        [objectInteger intersectSet:chosenMoodInteger];
        
        if([objectInteger count]>= _chosenMoodCount){
            [result addObject:object];
         }
        [objectInteger removeAllObjects];
    }
    
    NSLog(@"filtered: %@", result);
    
    
    return NULL;
}



@end
