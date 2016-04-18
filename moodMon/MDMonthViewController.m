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

@implementation MDMonthViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    thisMonth =[[[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:[NSDate date]]month];

    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self moreDateInfo];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    int xVal=34,yVal=140;
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
//    
    _yearLabel.text=[NSString stringWithFormat:@"%d",thisYear];
    [_monthLabel setText:[NSString stringWithFormat:@"%d",thisMonth]];
    for(int startDay=1; startDay<=numDays;startDay++){
        UIButton *dayButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        int xCoord=(newWeekDay*51)+xVal;
        int yCoord=(yCount*51)+yVal;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        
        dayButton.frame = CGRectMake(xCoord, yCoord, 51, 51);
        [dayButton setTitle:[NSString stringWithFormat:@"%d",startDay]forState:UIControlStateNormal];
        [dayButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dayButton.tag=tag++;
        [self.view addSubview:dayButton];
    }
}
@end