//
//  MMNewMoodController.h
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 27..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMoodModel.h"
#import "MMNewMoodButtonView.h"
#import "MMWheelView.h"

@interface MMNewMoodController : UIViewController

/* Model */
@property MMMoodModel *mood;
@property int moodCount;

/* IBOutlet */
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIImageView *circle;
@property (strong, nonatomic) IBOutlet MMWheelView *wheel;
@property NSArray *moodViews;
@property (strong, nonatomic) IBOutlet MMNewMoodButtonView *angry;
@property (strong, nonatomic) IBOutlet MMNewMoodButtonView *joy;
@property (strong, nonatomic) IBOutlet MMNewMoodButtonView *sad;
@property (strong, nonatomic) IBOutlet MMNewMoodButtonView *excited;
@property (strong, nonatomic) IBOutlet MMNewMoodButtonView *tired;

@end

