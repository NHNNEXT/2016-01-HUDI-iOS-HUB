//
//  MDProgressWheelView.h
//  moodMon
//
//  Created by 김기범 on 2016. 5. 16..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodButtonView.h"

@interface MDProgressWheelView : UIView

@property CGFloat startAngle;
@property CGFloat endAngle;
@property CGPoint arcCenter;
@property CGFloat arcRadius;
@property NSArray *colors;
@property NSInteger currentMoodNum;
@property UIBezierPath *bezierPath;

-(void)erasePath;

@end
