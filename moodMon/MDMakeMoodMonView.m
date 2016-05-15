//
//  MDMakeMoodMonView.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 9..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDMakeMoodMonView.h"

@implementation MDMakeMoodMonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIImage*)makeMoodMon:(NSDictionary*)moodmonConf view:(MDMoodColorView*)view{
    NSNumber *tempMoodChosen = [moodmonConf valueForKey:kChosen1 ];
    if(tempMoodChosen > 0)  [view.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
    tempMoodChosen = [moodmonConf valueForKey:kChosen2 ];
    if(tempMoodChosen > 0)  [view.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
    tempMoodChosen = [moodmonConf valueForKey:kChosen3 ];
    if(tempMoodChosen > 0)  [view.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
    
    view.layer.cornerRadius = 22;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return img;
}

@end
