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

@interface MDMonthViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *tableViews;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *yearLabel;
@property (strong, nonatomic) IBOutlet MDMoodColorView *moodColor;
-(void) showAlert:(NSNotification*)notification;


@end
