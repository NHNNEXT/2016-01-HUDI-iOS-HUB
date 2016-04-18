//
//  MDMoodFilterTableViewController.h
//  moodMon
//
//  Created by Lee Kyu-Won on 4/17/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"

@interface MDMoodFilterTableViewController : UITableViewController


@property MDDataManager *dataManager;


-(void)moodDidChoose;
-(void)selectAllMood;
-(void)showAlert:(NSNotification*)notification;

@end
