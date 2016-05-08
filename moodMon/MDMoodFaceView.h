//
//  MDMoodFaceView.h
//  moodMon
//
//  Created by 김기범 on 2016. 5. 8..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MDMoodFaceView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *wrinkle;
@property (strong, nonatomic) IBOutlet UIImageView *eyebrow;
@property (strong, nonatomic) IBOutlet UIImageView *eye;
@property (strong, nonatomic) IBOutlet UIImageView *darkCircle;
@property (strong, nonatomic) IBOutlet UIImageView *cheek;
@property (strong, nonatomic) IBOutlet UIImageView *tear;
@property (strong, nonatomic) IBOutlet UIImageView *mouth;
@property (strong, nonatomic) IBOutlet UIImageView *background;

@property NSArray *moodName;
@property NSMutableArray<NSNumber *> *chosenMoods;

@end
