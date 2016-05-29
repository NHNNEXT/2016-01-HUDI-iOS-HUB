//
//  MDMonthViewController.h
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"
#import "MDYearViewController.h"
#import "MDMoodColorView.h"
#import "MDSaveMoodMon.h"
#import "MDMakeMoodMonView.h"
#import "MDSmallMoodFaceView.h"
#import "MDCustomStoryboardSegue.h"
#import "MDCustomStoryboardunwindSegue.h"
#import "MDMonthTimeLineCellTableViewCell.h"

@interface MDMonthViewController : UIViewController <SwipeableCellDelegate, UITableViewDelegate>

@property (strong, nonatomic)MDDataManager *mddm;

@property (strong, nonatomic) IBOutlet UITableView *tableViews;

/*for filter tool bar animation*/
@property (nonatomic, weak) IBOutlet UIView *toolbarContainer;
@property (nonatomic, weak) IBOutlet UIView *buttonContainer;
@property (weak, nonatomic) IBOutlet UIButton *angryFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *sadFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *happyFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *exhaustFilterBtn;
@property (weak, nonatomic) IBOutlet UIButton *exciteFilterBtn;
/*
 0 - angry - 11~15
 1 - happy - 21~25
 2 - sad - 31~35
 3 - excited - 41~45
 4 - exhausted - 51~55
 */
@property UIImage *angryChecked;
@property UIImage *angryUnchecked;
@property UIImage *happyChecked;
@property UIImage *happyUnchecked;
@property UIImage *sadChecked;
@property UIImage *sadUnchecked;
@property UIImage *exciteChecked;
@property UIImage *exciteUnchecked;
@property UIImage *exhaustChecked;
@property UIImage *exhaustUnchecked;



@property NSInteger thisYear;
@property NSInteger thisMonth;

-(IBAction)expandButtonTouched;
-(IBAction)collapseButtontouched;
//filtering
- (IBAction)filterButtonClicked:(id)sender;
/****************************/

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property (strong, nonatomic) IBOutlet UIButton *filterButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *dataButton;
-(void) showAlert:(NSNotification*)notification;
-(void)timeTableReload;
-(void)resetTimeTable;

- (IBAction)goToNewMoodViewController:(id)sender;

@end
