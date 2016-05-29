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
//    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
//        UIGraphicsBeginImageContextWithOptions(CGRectMake(view.bounds.origin.x, view.bounds.origin.y, view.bounds.size.width+20, view.bounds.size.height+20).size, NO, [UIScreen mainScreen].scale);
//    } else {
//        UIGraphicsBeginImageContext(view.bounds.size);
//    }
//    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    bigView.layer.cornerRadius = bigView.frame.size.width/2;
    bigView.layer.masksToBounds = YES;
    MDMoodColorView *colorView = [[MDMoodColorView alloc] initWithFrame:bigView.frame];
    MDSaveMoodFaceView *faceView = [[MDSaveMoodFaceView alloc] initWithFrame:bigView.frame];
    [bigView addSubview:colorView];
    [bigView addSubview:faceView];
    
    [colorView awakeFromNib];
    colorView.chosenMoods = view.chosenMoods;
    [colorView setNeedsDisplay];
    colorView.layer.cornerRadius = colorView.frame.size.width/2;
    colorView.layer.masksToBounds = YES;

    
    [faceView awakeFromNib];
    faceView.chosenMoods = view.chosenMoods;
    [faceView setNeedsDisplay];
    faceView.backgroundColor = [UIColor clearColor];
    faceView.layer.cornerRadius = faceView.frame.size.width/2;
    faceView.layer.masksToBounds = YES;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(300, 300), bigView.opaque, 0.0);
    [bigView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:@"snapshot.png" options:NSDataWritingWithoutOverwriting error:Nil];
    [data writeToFile:@"snapshot.png" atomically:YES];
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:data], nil, nil, nil);
}
@end
