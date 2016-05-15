//
//  MDNewMoodViewController.h
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"
#import "MDWheelView.h"
#import "MDMoodFaceView.h"
#import "MDMoodColorView.h"
#import "MDMoodButtonView.h"
#import "MDRecentMoodView.h"
#import "MDProgressWheelView.h"
#import "MDWheelGestureRecognizer.h"
#import "MDTouchDownGestureRecognizer.h"

@interface MDNewMoodViewController : UIViewController <MDWheelGestureRecognizerDelegate>

/* Model */
@property MDMoodmon *mood;

/* DataManager */
@property MDDataManager *dataManager;

/* Date */
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;

/* Mood Buttons */
@property (strong, nonatomic) IBOutlet MDMoodButtonView *angry;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *joy;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *sad;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *excited;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *tired;

/* Wheel */
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet MDWheelView *wheel;
@property (strong, nonatomic) IBOutlet MDProgressWheelView *progressWheel;
@property (strong, nonatomic) IBOutlet MDMoodColorView *moodColor;
@property (strong, nonatomic) IBOutlet MDMoodFaceView *mixedMoodFace;
@property (strong, nonatomic) IBOutlet UIImageView *moodIntensityView;

/* Recent Mood */
@property (strong, nonatomic) IBOutlet MDRecentMoodView *recentMoodView;

/* Skip & Save */
@property (strong, nonatomic) IBOutlet UIView *skipButtonBackground;
@property (strong, nonatomic) IBOutlet MDMoodColorView *saveButtonBackground;
- (IBAction)saveNewMoodMon:(id)sender;
- (IBAction)skip:(id)sender;
- (void) showAlert:(NSNotification*)notification;

//-(void) presentCalendar;

@end

