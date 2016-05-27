//
//  MDMonthViewController.m
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import "MDMonthViewController.h"
#import "MDMoodColorView.h"

@interface MDMonthViewController (){
    BOOL toolbarIsOpen;
    BOOL toolbarIsAnimating;
}

@end

extern NSUInteger numDays;
extern int thisYear;
int thisMonth;
extern int weekday;
extern int tag;
NSArray *createdAt;
int count;
NSMutableArray *moodmonConf;

@implementation MDMonthViewController{
    NSInteger myDay;
}





- (void)viewDidLoad {

    count=0;
    [super viewDidLoad];
    _mddm = [MDDataManager sharedDataManager];
    //[mddm createDB];
    
    toolbarIsOpen = YES;
    toolbarIsAnimating = NO;
    self.toolbarContainer.translatesAutoresizingMaskIntoConstraints = YES;
    [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 44), self.view.frame.size.width, 44.0)];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:_mddm ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:_mddm ];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeTableReload) name:@"newDataAdded" object:_mddm];
    

    createdAt=[_mddm moodCollection];
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    thisMonth =[[[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:[NSDate date]]month];

    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%d년 %d월", thisYear, thisMonth];
    _clickedDate.text = @" ";
    myDay = 0;
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self moreDateInfo];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
}


- (IBAction)expandCollapseButtonTouched
{
    if (!toolbarIsAnimating) {
        toolbarIsAnimating = YES;
        if (toolbarIsOpen) {
            [self collapseToolbarWithoutBounce];
        } else {
            [self expandToolbarWithoutBounce];
        }
    }
}

- (void)collapseToolbarWithoutBounce
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 35), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        toolbarIsOpen = NO;
        toolbarIsAnimating = NO;
        [self.collapseButton setTitle:@"\u2B06" forState:UIControlStateNormal];
    }];
}

- (void)expandToolbarWithoutBounce
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 90), self.view.frame.size.width, 100.0)];
    } completion:^(BOOL finished) {
        toolbarIsOpen = YES;
        toolbarIsAnimating = NO;
        [self.collapseButton setTitle:@"\u2B07" forState:UIControlStateNormal];
    }];
}



//#noti selector
-(void)timeTableReload{
    unsigned units = NSCalendarUnitMonth | NSCalendarUnitDay| NSCalendarUnitYear| NSCalendarUnitHour| NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDate *now = [NSDate date];
    NSCalendar *myCal = [[NSCalendar alloc]
                         initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp = [myCal components:units fromDate:now];
    NSInteger day = [comp day];
    
    if(day == myDay){
        [self showClickedDateMoodmonAtDay:myDay];
    }    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)goToYearView{
    MDYearViewController *yvc = [[MDYearViewController alloc]initWithNibName:@"yearVC" bundle:nil];
    [yvc setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentModalViewController:yvc animated:YES];
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        thisMonth++;
        [self removeTags];
        [self moreDateInfo];
        NSLog(@"down Swipe");
       
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        thisMonth--;
        [self removeTags];
        [self moreDateInfo];
        NSLog(@"up Swipe");
    }
    self.navigationController.navigationBar.topItem.title = [NSString stringWithFormat:@"%d년 %d월", thisYear,thisMonth];
    [self resetTimeTable];
}

-(void)resetTimeTable{
    moodmonConf = NULL;
    myDay = 0;
    _clickedDate.text = @" ";
    [_tableViews reloadData];

}

- (IBAction)goToNewMoodViewController:(id)sender {
    int height = [UIScreen mainScreen].bounds.size.height;
    NSString *identifier = (height<=568)?@"newMoodmonVC_4inch":@"newMoodmonVC";
    UIViewController *newMoodVC = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
//    MDCustomStoryboardSegue *segue = [[MDCustomStoryboardSegue alloc] initWithIdentifier:@"toNewMoodVC" source:self destination:newMoodVC];
//    [segue perform];
    [self presentViewController:newMoodVC animated:YES completion:nil];
}

-(void)removeTags{
    int x=1;
    while(x<=90){
        [[self.view viewWithTag:x]removeFromSuperview];
        x++;
    }
}

-(NSUInteger)getCurrDateInfo:(NSDate *)myDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate];
    NSUInteger numberOfDaysInMonth = rng.length;
    
    return numberOfDaysInMonth;
}

-(void)moreDateInfo{
    tag=32;
    if(thisMonth>12){
        thisMonth=1;
        thisYear++;
    }
    if(thisMonth<1){
        thisMonth=12;
        thisYear--;
    }
    
    int xVal=CGRectGetWidth(self.view.bounds)/7,yVal=CGRectGetHeight(self.view.bounds)/14;
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:1];
    [components setMonth:thisMonth];
    [components setYear:thisYear];
    NSDate * newDate = [calendar dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:newDate];
    weekday=[comps weekday];
    
    numDays=[self getCurrDateInfo:newDate];
    
    int newWeekDay=weekday-1;
    //    NSLog(@"Day week %d",newWeekDay);
    
    int yCount=1;
    int xCoord=0;
    int yCoord=(yCount*yVal)+20;
    
    UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, yCoord+10, CGRectGetWidth(self.view.bounds),yVal*2/3)];
    [backgroundLabel setBackgroundColor:[UIColor colorWithRed:222.0f/255.0f green:212.0f/255.0f blue:198.0f/255.0f alpha:1.0f]];
    [self.view addSubview:backgroundLabel];
    for(int i=0;i<7;i++){
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord+(xVal*i)+xVal/3, yCoord, xVal, yVal)];
        switch (i) {
            case 1:
                [monthLabel setText:[NSString stringWithFormat:@"MON"]];
                break;
            case 2:
                [monthLabel setText:[NSString stringWithFormat:@"TUE"]];
                break;
            case 3:
                [monthLabel setText:[NSString stringWithFormat:@"WED"]];
                break;
            case 4:
                [monthLabel setText:[NSString stringWithFormat:@"THU"]];
                break;
            case 5:
                [monthLabel setText:[NSString stringWithFormat:@"FRI"]];
                break;
            case 6:
                [monthLabel setText:[NSString stringWithFormat:@"SAT"]];
                break;
            case 0:
                [monthLabel setText:[NSString stringWithFormat:@"SUN"]];
                break;
            default:
                break;
        }
    monthLabel.tag = tag++;
    [monthLabel setFont:[UIFont systemFontOfSize:16]];
    [monthLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:monthLabel];
    }
    //
    yCount++;
//    _yearLabel.text=[NSString stringWithFormat:@"%d",thisYear];
//    [_monthLabel setText:[NSString stringWithFormat:@"%d",thisMonth]];
    for(int startDay=1; startDay<=numDays;startDay++){
        UIButton *dayButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        xCoord=(newWeekDay*xVal);
        yCoord=(yCount*yVal)+20;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        dayButton.frame = CGRectMake(xCoord, yCoord, xVal, yVal);
        [dayButton setTitle:[NSString stringWithFormat:@"%d",startDay]forState:UIControlStateNormal];
        [dayButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dayButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        dayButton.tag=startDay;
        int checkFalg =0;
        for(int parseNum=0; parseNum<createdAt.count; parseNum++){
            NSDictionary *parseDate = createdAt[parseNum];
           int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
            int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
            int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
            
            if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==startDay)&&(checkFalg==0)){
                [dayButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                checkFalg=1;
//                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
//                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
//                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
//                    }
//                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                    //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                    //                }
                
                
                
                int yCoordCenter = yVal/2+yCoord-xVal*4/10;
                int xCoordCenter = xVal/2+xCoord-xVal*4/10;
                MDMoodColorView *mcv = [[MDMoodColorView alloc]initWithFrame:CGRectMake(xCoordCenter,yCoordCenter, xVal*4/5, xVal*4/5)];
                
                [mcv awakeFromNib];
                MDMoodFaceView *mfv = [[MDMoodFaceView alloc]initWithFrame:CGRectMake(xCoordCenter, yCoord, xVal, yVal)];
                
                [mfv awakeFromNib];
                //                mcv.backgroundColor = [UIColor clearColor];
                NSArray *dayRepresenatationColors = [_mddm representationOfMoodAtYear:(NSInteger)parseYear Month:(NSInteger)parseMonth andDay:parseDay];
               
                NSNumber *tempMoodChosen = dayRepresenatationColors[0];
                if(tempMoodChosen.intValue > 0)
//                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                tempMoodChosen = dayRepresenatationColors[1];
                if(tempMoodChosen.intValue > 0)
//                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                tempMoodChosen = dayRepresenatationColors[2];
                if(tempMoodChosen.intValue > 0)
//                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                
                
//                    mmm = [[MDMakeMoodMonView alloc]init];
//                    mcv = [self.view viewWithTag:7];
//                    [dayButton setImage:[mmm makeMoodMon:createdAt[parseNum] view:mcv] forState:UIControlStateNormal];
                mcv.tag=tag++;
                mfv.tag=tag++;
                mcv.layer.cornerRadius = xVal*5/12;
                [mcv setNeedsDisplay];
                [mfv setNeedsDisplay];
                [self.view addSubview:mcv];
//                [self.view addSubview:mfv];
            }
        }
        [self.view addSubview:dayButton];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return moodmonConf.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    MDMonthTimeLineCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMonthTimeLineCellTableViewCell" forIndexPath:indexPath];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@",[moodmonConf[indexPath.row]valueForKey:@"_moodComment" ]];
    
    //NSLog(@"time is : %@", [moodmonConf[indexPath.row] valueForKey:kTime]);
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [moodmonConf[indexPath.row] valueForKey:kTime]];
    cell.itemText = [moodmonConf[indexPath.row]valueForKey:@"_moodComment" ];
   
    cell.delegate = self;
   
    
    MDMoodColorView *temp = [cell viewWithTag:100];
    //NSLog(@"before : %@",temp.chosenMoods);
    int usedChosenMoodsCount = temp.chosenMoods.count;
    if( usedChosenMoodsCount > 1){
        for(int i = 0 ; i < usedChosenMoodsCount-1 ; i++){
            [temp.chosenMoods removeLastObject];
        }
       // NSLog(@"after :%@",temp.chosenMoods);
        [temp setNeedsDisplay];
    }
    
    
    NSNumber *tempMoodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen1];
    if(tempMoodChosen.intValue != 0){
        [temp.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
    }
    
    tempMoodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen2];
    if(tempMoodChosen.intValue != 0){
        [temp.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
    }
    
    tempMoodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen3];
    if(tempMoodChosen.intValue != 0){
        [temp.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
    }
    
    temp.layer.cornerRadius = (int)temp.frame.size.width/2;
    temp.layer.masksToBounds = YES;
    temp.hidden = NO;
    [temp setBackgroundColor:[UIColor clearColor]];
    //NSLog(@"colorview : %@, chosenMood:%@",temp, temp.chosenMoods);
    [temp setNeedsDisplay];
    [cell.myContentView addSubview:temp];
    
    return cell;
}



-(void)buttonTouch:(id)sender{
    UIButton* btn = (UIButton *)sender;
    [self showClickedDateMoodmonAtDay:btn.currentTitle.intValue];
   
}


-(void)showClickedDateMoodmonAtDay:(int)day{
    NSMutableArray* moodmonConfig = [[NSMutableArray alloc]init];
    count=0;
    NSString *clickedDateString =[NSString stringWithFormat:@"%d년 %d월 %d일", thisYear, thisMonth, day];
    _clickedDate.text = clickedDateString;
    myDay = day;
    
   

    
    for(int parseNum=0; parseNum<createdAt.count; parseNum++){
        NSDictionary *parseDate = createdAt[parseNum];
        int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
        int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
        int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
        
        if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==day)){
            
            moodmonConfig[count]=createdAt[parseNum];
            count++;
        }
    }
    moodmonConf=moodmonConfig;
    [_tableViews reloadData];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableViews deselectRowAtIndexPath:indexPath animated:NO];

}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       // [_objects removeObjectAtIndex:indexPath.row];
        [self.tableViews deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %ld",(long)editingStyle);
    }
}


#pragma mark - SwipeableCellDelegate
- (void)buttonOneActionForItemText:(NSString *)itemText {
    NSLog(@"In the delegate, Clicked button one for %@", itemText);
}

- (void)buttonTwoActionForItemText:(MDMoodColorView *)itemText {
    NSLog(@"In the delegate, Clicked button two");
    MDSaveMoodMon *smm = [[MDSaveMoodMon alloc]init];
    [smm saveMoodMon:itemText];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SAVE" message:@"SAVE" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];

    
    //뷰를 넘겨주면 그대로 저장
}
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue
{
    NSLog(@"back from : %@", [segue.sourceViewController class]);
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    
    //how to set identifier for an unwind segue:
    
    //1. in storyboard -> documento outline -> select your unwind segue
    //2. then choose attribute inspector and insert the identifier name
    if ([@"JSUnwindView" isEqualToString:identifier]) {
        return [[MDCustomStoryboardUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }else {
        //if you want to use simple unwind segue on the same or on other ViewController this code is very important to mix custom and not custom segue
        return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    }
}

-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end