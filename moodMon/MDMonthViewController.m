//
//  MDMonthViewController.m
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import "MDMonthViewController.h"
#import "MDMoodColorView.h"

@interface MDMonthViewController ()

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
    MDDataManager *mddm = [MDDataManager sharedDataManager];
    //[mddm createDB];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:mddm ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:mddm ];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeTableReload) name:@"newDataAdded" object:mddm];
    
     [self.navigationController setNavigationBarHidden:YES];
    
    
    createdAt=[mddm moodCollection];
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    thisMonth =[[[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:[NSDate date]]month];

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

    [self.navigationController setNavigationBarHidden:YES];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];

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
    [self resetTimeTable];
}

-(void)resetTimeTable{
    moodmonConf = NULL;
    myDay = 0;
    _clickedDate.text = @" ";
    [_tableViews reloadData];

}

-(void)removeTags{
    int x=1;
    while(x<=365){
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
    tag=1;
    if(thisMonth>12){
        thisMonth=1;
        thisYear++;
    }
    if(thisMonth<1){
        thisMonth=12;
        thisYear--;
    }
    
    int xVal=CGRectGetWidth(self.view.bounds)/9,yVal=CGRectGetHeight(self.view.bounds)/20;
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
    int xCoord=xVal;
    int yCoord=(yCount*yVal)+yVal*3.5;
    for(int i=0;i<7;i++){
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord+(xVal*i)+xVal/3, yCoord, xVal, yVal)];
        switch (i) {
            case 6:
                [monthLabel setText:[NSString stringWithFormat:@"월"]];
                break;
            case 1:
                [monthLabel setText:[NSString stringWithFormat:@"화"]];
                break;
            case 2:
                [monthLabel setText:[NSString stringWithFormat:@"수"]];
                break;
            case 3:
                [monthLabel setText:[NSString stringWithFormat:@"목"]];
                break;
            case 4:
                [monthLabel setText:[NSString stringWithFormat:@"금"]];
                break;
            case 5:
                [monthLabel setText:[NSString stringWithFormat:@"토"]];
                break;
            case 0:
                [monthLabel setText:[NSString stringWithFormat:@"일"]];
                break;
            default:
                break;
        }
    monthLabel.tag = tag++;
    [monthLabel setFont:[UIFont systemFontOfSize:20]];
    [monthLabel setTextColor:[UIColor blackColor]];
    [self.view addSubview:monthLabel];
    }
//
    _yearLabel.text=[NSString stringWithFormat:@"%d",thisYear];
    [_monthLabel setText:[NSString stringWithFormat:@"%d",thisMonth]];
    for(int startDay=1; startDay<=numDays;startDay++){
        UIButton *dayButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        xCoord=(newWeekDay*xVal)+xVal;
        yCoord=(yCount*yVal)+yVal*4.5;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        dayButton.frame = CGRectMake(xCoord, yCoord, xVal, yVal);
        [dayButton setTitle:[NSString stringWithFormat:@"%d",startDay]forState:UIControlStateNormal];
        [dayButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [dayButton addTarget:self action:@selector(buttonTouch:) forControlEvents:UIControlEventTouchUpInside];
        dayButton.tag=tag++;
        int checkFalg =0;
        for(int parseNum=0; parseNum<createdAt.count; parseNum++){
            NSDictionary *parseDate = createdAt[parseNum];
           int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
            int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
            int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
            
            if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==startDay&&(checkFalg==0))){
                checkFalg=1;
//                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
//                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
//                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
//                    }
//                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                    //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                    //                }
                MDMoodColorView *mcv = [[MDMoodColorView alloc]initWithFrame:CGRectMake(xCoord,yCoord, xVal, yVal)];
                
                [mcv awakeFromNib];
                //                mcv.backgroundColor = [UIColor clearColor];
                NSNumber *tempMoodChosen = [parseDate valueForKey:kChosen1 ];
                if(tempMoodChosen.intValue > 0)
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                tempMoodChosen = [parseDate valueForKey:kChosen2 ];
                if(tempMoodChosen.intValue > 0)
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                tempMoodChosen = [parseDate  valueForKey:kChosen3 ];
                if(tempMoodChosen.intValue > 0)
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                
//                    mmm = [[MDMakeMoodMonView alloc]init];
//                    mcv = [self.view viewWithTag:7];
//                    [dayButton setImage:[mmm makeMoodMon:createdAt[parseNum] view:mcv] forState:UIControlStateNormal];
                mcv.tag=tag++;
                mcv.layer.cornerRadius = 16;
                [mcv setNeedsDisplay];
                [self.view addSubview:mcv];
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
    
    UIView *viewForFrame =  [cell viewWithTag:3];
    MDMoodColorView *temp = [[MDMoodColorView alloc]init];
    [temp setFrame:viewForFrame.frame];
    //NSLog(@"%@",temp);
    
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
    [temp setBackgroundColor:[UIColor whiteColor]];
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

- (void)buttonTwoActionForItemText:(NSString *)itemText {
    MDSaveMoodMon *smm = [[MDSaveMoodMon alloc]init];
    [smm saveMoodMon:self.view];
    //뷰를 넘겨주면 그대로 저장
}
- (IBAction) exitFromSecondViewController:(UIStoryboardSegue *)segue
{
    NSLog(@"back from : %@", [segue.sourceViewController class]);
}

-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end