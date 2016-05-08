//
//  MDSearchTableViewController.h
//  moodMon
//
//  Created by Lee Kyu-Won on 4/25/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"


@interface MDSearchTableViewController : UITableViewController  <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>


@property MDDataManager *dataManager;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, copy) NSArray *filteredProducts;


//for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;




@end
