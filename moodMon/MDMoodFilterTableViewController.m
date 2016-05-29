//
//  MDMoodFilterTableViewController.m
//  moodMon
//
//  Created by Lee Kyu-Won on 4/17/16.
//  Copyright © 2016 HUB. All rights reserved.
//

#import "MDMoodFilterTableViewController.h"
#import "MDMoodFilterTableViewCell.h"

@interface MDMoodFilterTableViewController (){
    NSArray *tableTitles;
    
}

@end

@implementation MDMoodFilterTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    tableTitles = @[@[@"All mood"], @[@"Angry", @"Happy", @"Sad", @"Excited", @"Exhausted" ]];
    
    self.dataManager = [MDDataManager sharedDataManager];
    
  
    
    UINavigationItem *navItems = [[UINavigationItem alloc] initWithTitle:@"Filter"];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(moodDidChoose)];
    navItems.rightBarButtonItem = doneBtn;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Quicksand" size:15]}];
    
    NSArray *items =[[NSArray alloc]initWithObjects:navItems,nil];
    
    [self.navigationController.navigationBar setItems:items];
    
    /* 네비게이션 코드로 만들면 height처리가 좀더 복잡해 집니다. 
       그냥 네비 안에 임베디드 하고
        "self.edgesForExtendedLayout = UIRectEdgeNone;"를 추가해 주세요 ㅎㅎㅎ
     
     아래는 삽질*
     
    //  UINavigationBar *navbar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //  [navbar setItems:items];
    // [self.view addSubview:navbar];
    // [self.tableView setBounds: CGRectMake(0, 100, self.view.bounds.size.width, self.view.bounds.size.height - 100)];
     
     */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.tableView registerClass:[MDMoodFilterTableViewCell class] forCellReuseIdentifier:@"moodCell"];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"chosenMoreThan3" object:self];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 5;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDMoodFilterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"moodCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[MDMoodFilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"moodCell"];
    }
    
    cell.textLabel.text = tableTitles[indexPath.section][indexPath.row];
    
    if(indexPath.section == 0){
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectAllMood)];
        [cell addGestureRecognizer:gesture];
        return cell;
    }
    
    
    if([self.dataManager.isChecked[indexPath.row]  isEqual: @NO]){
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    
    return cell;
}


-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) return NULL;
    
    // 1. The view for the header
    UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 22)];
    
    // 2. Set a custom background color and a border
    headerView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    headerView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1.0].CGColor;
    headerView.layer.borderWidth = 1.0;
    
    // 3. Add a label
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 2, tableView.frame.size.width - 5, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.text = @"Mood";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    [headerView addSubview:headerLabel];
    
    // 5. Finally return
    return headerView;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"user selected %d", self.dataManager.chosenMoodCount);
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        if( self.dataManager.chosenMoodCount >= 3) {
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chosenMoreThan3" object:self userInfo:@{@"message" : @"You can choose at most 3 moods"}];
            return;
        }
        
        self.dataManager.chosenMoodCount++;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.dataManager.isChecked[indexPath.row] = @YES;
    } else {
        self.dataManager.chosenMoodCount--;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.dataManager.isChecked[indexPath.row] = @NO;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
   
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"user de-selected %d", self.dataManager.chosenMoodCount);
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if(cell.accessoryType == UITableViewCellAccessoryNone){
        if( self.dataManager.chosenMoodCount >= 3) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"chosenMoreThan3" object:self userInfo:@{@"message" : @"You can choose at most 3 moods"}];
            return;
        }
        self.dataManager.chosenMoodCount++;
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.dataManager.isChecked[indexPath.row] = @YES;
    } else {
        self.dataManager.chosenMoodCount--;
        cell.accessoryType = UITableViewCellAccessoryNone;
        self.dataManager.isChecked[indexPath.row] = @NO;
    }
    
    
}


-(void)moodDidChoose{
    NSLog(@"I will be dismissed");
    
    [self dismissViewControllerAnimated:self.presentedViewController completion:^{
       [self.tableView reloadData];
    }];
    
    //[self.dataManager getFilteredMoodmons]; for test
}

-(void)selectAllMood{
    NSLog(@"hello");
    for(int i = 0 ;i< 5 ; i++){
        self.dataManager.isChecked[i] = @NO;
    }
    self.dataManager.chosenMoodCount = 0;
    [self.tableView reloadData];
}

-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
