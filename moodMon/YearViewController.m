//
//  ViewController.m
//  JSCalendar
//
//  Created by 이재성 on 2016. 3. 27..
//  Copyright © 2016년 이재성. All rights reserved.
//

#import "YearViewController.h"

@interface YearViewController ()

@end


NSUInteger numDays;
int thisYear;
int weekday;
int tag;

@implementation YearViewController
@synthesize yearly;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
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
    [self moreDateInfo:1 xVal:20 yVal:50];
    [self moreDateInfo:2 xVal:210 yVal:50];
    [self moreDateInfo:3 xVal:20 yVal:180];
    [self moreDateInfo:4 xVal:210 yVal:180];
    [self moreDateInfo:5 xVal:20 yVal:300];
    [self moreDateInfo:6 xVal:210 yVal:300];
    [self moreDateInfo:7 xVal:20 yVal:430];
    [self moreDateInfo:8 xVal:210 yVal:430];
    [self moreDateInfo:9 xVal:20 yVal:560];
    [self moreDateInfo:10 xVal:210 yVal:560];
    [self moreDateInfo:11 xVal:20 yVal:690];
    [self moreDateInfo:12 xVal:210 yVal:690];
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
    
    for(int startDay=1; startDay<=numDays;startDay++){
        UIButton *dayButton = [UIButton buttonWithType: UIButtonTypeRoundedRect];
        
        int xCoord=(newWeekDay*20)+xVal;
        int yCoord=(yCount*20)+yVal;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        
        dayButton.frame = CGRectMake(xCoord, yCoord, 20, 20);
        [dayButton setTitle:[NSString stringWithFormat:@"%d",startDay]forState:UIControlStateNormal];
        [dayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        dayButton.tag=tag++;
        
        [self.view addSubview:dayButton];
        
    }
}
@end
