//
//  MDNewMoodViewController.h
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodButtonView.h"
#import "MDWheelView.h"
#import "MDDataManager.h"
#import "MDWheelGestureRecognizer.h"
#import "MDRecentMoodView.h"
#import "MDMoodColorView.h"
#import "MDMoodFaceView.h"


@interface MDNewMoodViewController : UIViewController <MDWheelGestureRecognizerDelegate>

/* Model */
@property MDMoodmon *mood;

/* DataManager to save new moodmon */
@property MDDataManager *dataManager;

/* IBOutlet */
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIImageView *moodDegree;
@property (strong, nonatomic) IBOutlet MDMoodFaceView *mixedMoodFace;
@property (strong, nonatomic) IBOutlet MDMoodColorView *moodColor;
@property (strong, nonatomic) IBOutlet MDWheelView *wheel;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *angry;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *joy;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *sad;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *excited;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *tired;
@property (strong, nonatomic) IBOutlet MDRecentMoodView *recentMoodView;

/* IBAction */
- (IBAction)saveNewMoodMon:(id)sender;

-(void) showAlert:(NSNotification*)notification;
-(void) presentCalendar;

@end

