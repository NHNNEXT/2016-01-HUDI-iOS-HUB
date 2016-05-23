//
//  MDSmallMoodFaceView.h
//  moodMon
//
//  Created by 김기범 on 2016. 5. 23..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDSmallMoodFaceView : UIView

@property UIImageView *wrinkle;
@property UIImageView *eyebrow;
@property UIImageView *eye;
@property UIImageView *darkCircle;
@property UIImageView *cheek;
@property UIImageView *tear;
@property UIImageView *mouth;
@property UIImageView *background;


@property NSArray *moodName;
@property NSMutableArray<NSNumber *> *chosenMoods;

@property BOOL hasExcited;  // 선택한 감정에 excited가 있는 경우 눈썹을 그리지 말아야 함.

@property CGFloat animationDuration;


@end
