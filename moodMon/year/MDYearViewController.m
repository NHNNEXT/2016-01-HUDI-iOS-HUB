//
//  ViewController.m
//  JSCalendar
//
//  Created by 이재성 on 2016. 3. 27..
//  Copyright © 2016년 이재성. All rights reserved.
//

#import "MDYearViewController.h"

@interface MDYearViewController ()

@end


NSUInteger numDays;
int thisYear;
int weekday;
int tag;

@implementation MDYearViewController
@synthesize yearly;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self myCalView];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        thisYear++;
        [self removeTags];
        [self myCalView];
        NSLog(@"down Swipe");
    }
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        thisYear--;
        [self removeTags];
        [self myCalView];
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
-(void)myCalView{
    tag=1;
    double xVal=CGRectGetWidth(self.view.bounds)/3,yVal=CGRectGetHeight(self.view.bounds)/5;
    
    [self moreDateInfo:1 xVal:0 yVal:yVal];
    [self moreDateInfo:2 xVal:xVal yVal:yVal];
    [self moreDateInfo:3 xVal:xVal*2 yVal:yVal];
    [self moreDateInfo:4 xVal:0 yVal:yVal*2];
    [self moreDateInfo:5 xVal:xVal yVal:yVal*2];
    [self moreDateInfo:6 xVal:xVal*2 yVal:yVal*2];
    [self moreDateInfo:7 xVal:0 yVal:yVal*3];
    [self moreDateInfo:8 xVal:xVal yVal:yVal*3];
    [self moreDateInfo:9 xVal:xVal*2 yVal:yVal*3];
    [self moreDateInfo:10 xVal:0 yVal:yVal*4];
    [self moreDateInfo:11 xVal:xVal yVal:yVal*4];
    [self moreDateInfo:12 xVal:xVal*2 yVal:yVal*4];
}

-(NSUInteger)getCurrDateInfo:(NSDate *)myDate{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate];
    NSUInteger numberOfDaysInMonth = rng.length;
    
    return numberOfDaysInMonth;
}

-(void)moreDateInfo:(int)showMonth xVal:(int)xVal yVal:(int)yVal{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc]init];
    [components setDay:1];
    [components setMonth:showMonth];
    [components setYear:thisYear];
    NSDate * newDate = [calendar dateFromComponents:components];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitWeekday fromDate:newDate];
    weekday=[comps weekday];
    
    numDays=[self getCurrDateInfo:newDate];
    
    int newWeekDay=weekday-1;
    //    NSLog(@"Day week %d",newWeekDay);
    
    int yCount=1;
    
    yearly.text=[NSString stringWithFormat:@"%d",thisYear];
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xVal+CGRectGetWidth(self.view.bounds)/7, yVal-10, 20, 20)];
    [monthLabel setText:[NSString stringWithFormat:@"%d",showMonth]];
    [self.view addSubview:monthLabel];
    for(int startDay=1; startDay<=numDays;startDay++){
        UILabel *dayButton = [[UILabel alloc]init];
        int xCoord=(newWeekDay*CGRectGetWidth(self.view.bounds)/25)+xVal+10;
        int yCoord=(yCount*14)+yVal;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        
        dayButton.frame = CGRectMake(xCoord, yCoord, CGRectGetWidth(self.view.bounds)/2.8/10, CGRectGetWidth(self.view.bounds)/2.8/10);
        [dayButton setText:[NSString stringWithFormat:@"%d",startDay]];
        [dayButton setFont:[UIFont systemFontOfSize:CGRectGetWidth(self.view.bounds)/2.8/13]];
        [dayButton setTextColor:[UIColor blackColor]];
        dayButton.tag=tag++;
        [self.view addSubview:dayButton];
    }
}
@end