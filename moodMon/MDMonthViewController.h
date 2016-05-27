//
//  MDMonthViewController.h
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMonthTimeLineCellTableViewCell.h"
#import "MDDataManager.h"
#import "MDYearViewController.h"
#import "MDMoodColorView.h"
#import "MDSaveMoodMon.h"
#import "MDMakeMoodMonView.h"
#import "MDMoodFaceView.h"
#import "MDCustomStoryboardSegue.h"
#import "MDCustomStoryboardunwindSegue.h"


@interface MDMonthViewController : UIViewController <SwipeableCellDelegate>

@property (strong, nonatomic)MDDataManager *mddm;

@property (strong, nonatomic) IBOutlet UITableView *tableViews;
@property (weak, nonatomic) IBOutlet UILabel *clickedDate;



/*for tool bar animation*/
@property (nonatomic, weak) IBOutlet UIView *toolbarContainer;
@property (nonatomic, weak) IBOutlet UIView *touchZone;
@property (nonatomic, weak) IBOutlet UIView *buttonContainer;
@property (nonatomic, weak) IBOutlet UIButton *collapseButton;
- (IBAction)expandCollapseButtonTouched;
/****************************/

-(void) showAlert:(NSNotification*)notification;
-(void)timeTableReload;
-(void)resetTimeTable;

- (IBAction)goToNewMoodViewController:(id)sender;

@end
