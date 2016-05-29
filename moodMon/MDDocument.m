//
//  MDDocument.m
//  moodMon
//
//  Created by Lee Kyu-Won on 5/29/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import "MDDocument.h"

@implementation MDDocument

-(instancetype)initWithFileURL:(NSURL *)url{
    self = [super initWithFileURL:url];
    if(self){
        _moodmonCollection = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)contentsForType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    NSData *arrayToData = [NSKeyedArchiver archivedDataWithRootObject:_moodmonCollection];
    return [NSData dataWithData:arrayToData];
}

-(BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError * _Nullable __autoreleasing *)outError{
    if([contents length] > 0){
        NSArray *arrayFromData = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
        [_moodmonCollection addObjectsFromArray:arrayFromData];
    } else {
        NSLog(@"no contents from document");
    }
    return YES;
}

@end
