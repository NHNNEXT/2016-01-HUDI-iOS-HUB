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

@interface MDMonthViewController : UIViewController <SwipeableCellDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableViews;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UILabel *clickedDate;

-(void) showAlert:(NSNotification*)notification;
-(void)timeTableReload;
-(void)resetTimeTable;

@end
