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
    
    UINavigationItem *navItems = [[UINavigationItem alloc] initWithTitle:@"Data Setting"];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(dataDidFinish)];
    navItems.rightBarButtonItem = doneBtn;
    NSArray *items =[[NSArray alloc]initWithObjects:navItems,nil];
    [self.navigationController.navigationBar setItems:items];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"iCloudSyncStart" object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"iCloudSyncFinished" object:_dataManager];
    
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
    
    if(indexPath.section == 0){
        cell.accessoryType = UITableViewCellAccessoryNone;
        
//        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAllMood)];
//        [cell addGestureRecognizer:gesture];
        return cell;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    

     return cell;
}


///!!!!!!!!! 해야 할 일
///alert view겁나 느림 - dispatch로 바꿈
///select류 일회적이다. select정보 저장해서 일관성있게 보여주기
/// ㄴ select시 iCloud 시작or계속 deselect시 중단
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0) return;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     if(cell.accessoryType == UITableViewCellAccessoryNone){
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
         [[NSNotificationCenter defaultCenter] postNotificationName:@"iCloudSyncStart" object:self userInfo:@{@"message" : @"iCloud동기화를 시작합니다"}];
         [_dataManager startICloudSync];
     } else {
         cell.accessoryType = UITableViewCellAccessoryNone;
     }
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0) return;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"iCloudSyncStart" object:self userInfo:@{@"message" : @"iCloud동기화를 시작합니다"}];
        [_dataManager startICloudSync];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0) return NULL;
    
    // 1. The view for the footer
    UIView* footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // 2. Set a custom background color and a border
    footerView.backgroundColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    footerView.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0].CGColor;
    footerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* footerLabel = [[UILabel alloc] init];
    footerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    footerLabel.backgroundColor = [UIColor clearColor];
    footerLabel.textColor = [UIColor blackColor];
    footerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    footerLabel.textColor = [UIColor redColor];
    footerLabel.text = @"모든 데이터를 지웁니다!";
    footerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the footer view
    [footerView addSubview:footerLabel];
    
    // 5. Finally return
    return footerView;
    
}


-(void)dataDidFinish{
    
    NSLog(@"I will be dismissed");
    
    [self dismissViewControllerAnimated:self.presentedViewController completion:^{
        [self.tableView reloadData];
    }];
    
}
-(void)showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Data" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
        
    });
    
}



@end
