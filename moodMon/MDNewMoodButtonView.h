//
//  MDNewMoodButtonView.h
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 28..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDNewMoodButtonView : UIImageView

@property int num;
@property NSString *name; // imageName 분기문에서 활용
@property BOOL isSelected;

@end
