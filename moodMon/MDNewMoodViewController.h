//
//  MDNewMoodViewController.h
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodModel.h"
#import "MDMoodButtonView.h"
#import "MDWheelView.h"
#import "MDDataManager.h"
#import "MDWheelGestureRecognizer.h"


@interface MDNewMoodViewController : UIViewController <MDWheelGestureRecognizerDelegate>

/* Model */
@property MDMoodmon *mood;
@property int moodCount;

/* DataManager to save new moodmon */
@property MDDataManager *dataManager;

/* IBOutlet */
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet MDWheelView *wheel;
@property (strong, nonatomic) IBOutlet UIImageView *centerMood;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *angry;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *joy;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *sad;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *excited;
@property (strong, nonatomic) IBOutlet MDMoodButtonView *tired;
@property NSArray *moodButtons;

/* IBAction */
- (IBAction)resetViews:(id)sender;
- (IBAction)saveNewMoodMon:(id)sender;

-(void) showAlert:(NSNotification*)notification;
-(void) presentCalendar;

@end

