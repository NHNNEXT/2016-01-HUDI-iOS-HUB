//
//  MDDataSettingTableViewController.m
//  moodMon
//
//  Created by Lee Kyu-Won on 5/22/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import "MDDataSettingTableViewController.h"
#import "MDDataManager.h"

@implementation MDDataSettingTableViewController{
    NSArray *tableTitles;
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    tableTitles = @[@[@"iCloud Sync"], @[@"Erase All Local Data"]];
    
    self.dataManager = [MDDataManager sharedDataManager];
    
    
    UINavigationItem *navItems = [[UINavigationItem alloc] initWithTitle:@"Filter"];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dataDidFinish)];
    navItems.rightBarButtonItem = doneBtn;
    NSArray *items =[[NSArray alloc]initWithObjects:navItems,nil];
    [self.navigationController.navigationBar setItems:items];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(section == 0) {
        return 1;
    }
    
    else {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = tableTitles[indexPath.section][indexPath.row];

     return cell;
}



-(void)dataDidFinish{
    
    NSLog(@"I will be dismissed");
    
    [self dismissViewControllerAnimated:self.presentedViewController completion:^{
        [self.tableView reloadData];
    }];
    
}
-(void)showAlert:(NSNotification*)notification{
    
}



@end
