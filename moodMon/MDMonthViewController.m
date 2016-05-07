//
//  MDMonthViewController.m
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import "MDMonthViewController.h"

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

@implementation MDMonthViewController


- (void)viewDidLoad {

    count=0;
    [super viewDidLoad];
    MDDataManager *mddm = [MDDataManager sharedDataManager];
    //[mddm createDB];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:mddm ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:mddm ];
    
    createdAt=[mddm moodCollection];
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    thisMonth =[[[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:[NSDate date]]month];

    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self moreDateInfo];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
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
    int xCoord=(newWeekDay*xVal)+xVal;
    int yCoord=(yCount*yVal)+yVal*3.5;
    for(int i=0;i<7;i++){
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord+(xVal*i)+xVal/3, yCoord, xVal, yVal)];
        switch (i) {
            case 0:
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
            case 6:
                [monthLabel setText:[NSString stringWithFormat:@"일"]];
                break;
            default:
                break;
        }
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
        for(int parseNum=0; parseNum<createdAt.count; parseNum++){
            NSDictionary *parseDate = createdAt[parseNum];
           int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
            int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
            int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
            
            if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==startDay)){
                
                
                if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==startDay)){
                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
                    }
                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                    }
                }
//                dayButton.backgroundColor =self.moodColor.chosenMoods;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MDMonthTimeLineCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMonthTimeLineCellTableViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",[moodmonConf[indexPath.row]valueForKey:@"_moodComment" ]];
    return cell;
}

-(void)buttonTouch:(id)sender{
    UIButton* btn = (UIButton *)sender;
    NSMutableArray* moodmonConfig = [[NSMutableArray alloc]init];
    count=0;
    for(int parseNum=0; parseNum<createdAt.count; parseNum++){
        NSDictionary *parseDate = createdAt[parseNum];
        int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
        int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
        int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
        
        if((parseYear==thisYear)&&(parseMonth==thisMonth)&&(parseDay==btn.currentTitle.intValue)){
            
            moodmonConfig[count]=createdAt[parseNum];
            count++;
        }
    }
    moodmonConf=moodmonConfig;
    [_tableViews reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}




@end