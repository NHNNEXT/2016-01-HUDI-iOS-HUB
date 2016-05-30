//
//  MDDataSettingTableViewController.h
//  moodMon
//
//  Created by Lee Kyu-Won on 5/22/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"

@interface MDDataSettingTableViewController : UITableViewController


@property MDDataManager *dataManager;


-(void)dataDidFinish;
-(void)showAlert:(NSNotification*)notification;
-(void)deleteAllData;




@end
