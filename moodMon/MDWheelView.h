//
//  MDWheelView.h
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 4. 6..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodButtonView.h"

@interface MDWheelView : UIImageView

@property CGFloat startAngle;
@property CGFloat endAngle;
@property NSArray *colors;
@property NSInteger currentMoodNum;

@end
