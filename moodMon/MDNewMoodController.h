//
//  MDNewMoodController.h
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 27..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodModel.h"
#import "MDMoodButtonView.h"
#import "MDWheelView.h"
#import "MDDataManager.h"


@interface MDNewMoodController : UIViewController

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

