//
//  MDMoodButtonView.h
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 28..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMoodButtonView : UIImageView

@property NSNumber *num;
@property NSString *name; // imageName 분기문에서 활용
@property BOOL isSelected;
@property float startAngle; // wheel starting angle

@end
