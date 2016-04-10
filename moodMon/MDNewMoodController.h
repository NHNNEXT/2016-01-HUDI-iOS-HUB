//
//  MDNewMoodController.h
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 27..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodModel.h"
#import "MDNewMoodButtonView.h"
#import "MDWheelView.h"
#import "MDDataManager.h"


@interface MDNewMoodController : UIViewController

/* Model */
@property MDMoodModel *mood;
@property int moodCount;

/*DataManager for save new moodmon*/
@property MDDataManager *moodmonDM;


/* IBOutlet */
@property (strong, nonatomic) IBOutlet UILabel *day;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UIView *container;
@property (strong, nonatomic) IBOutlet UIImageView *circle;
@property (strong, nonatomic) IBOutlet MDWheelView *wheel;
@property NSArray *moodViews;
@property (strong, nonatomic) IBOutlet MDNewMoodButtonView *angry;
@property (strong, nonatomic) IBOutlet MDNewMoodButtonView *joy;
@property (strong, nonatomic) IBOutlet MDNewMoodButtonView *sad;
@property (strong, nonatomic) IBOutlet MDNewMoodButtonView *excited;
@property (strong, nonatomic) IBOutlet MDNewMoodButtonView *tired;
- (IBAction)saveNewMoodMon:(id)sender;

-(void) showAlertOfMessage:(NSNotification*)notification;
-(void) presentCalendar;
@end

