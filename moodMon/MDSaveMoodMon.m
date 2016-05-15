//
//  MDSaveMoodMon.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 9..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDSaveMoodMon.h"

@implementation MDSaveMoodMon
-(void)saveMoodMon:(MDMoodColorView*)view{
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    } else {
        UIGraphicsBeginImageContext(view.bounds.size);
    }
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:@"snapshot.png" options:NSDataWritingWithoutOverwriting error:Nil];
    [data writeToFile:@"snapshot.png" atomically:YES];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
}
@end
