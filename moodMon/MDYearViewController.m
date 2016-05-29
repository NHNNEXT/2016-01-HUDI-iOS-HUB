//
//  ViewController.m
//  JSCalendar
//
//  Created by 이재성 on 2016. 3. 27..
//  Copyright © 2016년 이재성. All rights reserved.
//

#import "MDYearViewController.h"
#import "MDCustomStoryboardUnwindSegue.h"
#import "MDMoodFaceView.h"
#import "MDMoodColorView.h"
#import "MDDataManager.h"
#import "MDNavController.h"
#import "MDMonthViewController.h"
@interface MDYearViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@end


NSInteger numDays;
NSInteger thisYear;
NSArray *createdAt;
NSInteger weekday;
int tag;
int thisMonth=0;

@implementation MDYearViewController
@synthesize yearly;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDDataManager *mddm = [MDDataManager sharedDataManager];
    createdAt=[mddm moodCollection];
    
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
//    UITapGestureRecognizer *tab = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(monthTouch:)];
    
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
//- (IBAction)unwindeBackbtn:(id)sender {
//    [self performSegueWithIdentifier:@"UnwindingSegueID" sender:self];
////    [self.navigationitem removeFromSuperview];
//}
//- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier {
//    // Instantiate a new CustomUnwindSegue
//    MDCustomStoryboardUnwindSegue *segue = [[MDCustomStoryboardUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
//    // Set the target point for the animation to the center of the button in this VC
//    return segue;
//}

-(void)removeTags{
    int x=1;
    while(x<=900){
        [[self.view viewWithTag:x]removeFromSuperview];
        x++;
    }
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.destinationViewController isKindOfClass:[MDMonthViewController class]]) {
        MDMonthViewController *mainViewConroller = segue.destinationViewController;
        if (thisMonth) {
            mainViewConroller.thisMonth = thisMonth;
        }
    }
}
- (IBAction)monthTouch:(id)sender {
    CGPoint point = [sender locationInView:[self.view superview]];
    double xVal=CGRectGetWidth(self.view.bounds)/3,yVal=CGRectGetHeight(self.view.bounds)/5;
    if(point.x <= xVal*1&&point.y<=yVal*1+84){
        thisMonth=1;
//        UINavigationController *navController = (UINavigationController *)segue.destinationViewController;
    }else if(point.x <= xVal*2 && point.y<=yVal*1+84){
        thisMonth=2;
        
    }else if(point.x <= xVal*3 && point.y<=yVal*1+84){
        thisMonth=3;
    
    }else if(point.x <= xVal*1 && point.y<=yVal*2+84){
        
        thisMonth=4;
    }else if(point.x <= xVal*2 && point.y<=yVal*2+84){
        
        thisMonth=5;
    }else if(point.x <= xVal*3 && point.y<=yVal*2+84){
        
        thisMonth=6;
    }else if(point.x <= xVal*1 && point.y<=yVal*3+84){
        
        thisMonth=7;
    }else if(point.x <= xVal*2 && point.y<=yVal*3+84){
        
        thisMonth=8;
    }else if(point.x <= xVal*3 && point.y<=yVal*3+84){
        
        thisMonth=9;
    }else if(point.x <= xVal*1 && point.y<=yVal*4+84){
        
        thisMonth=10;
    }else if(point.x <= xVal*2 && point.y<=yVal*4+84){
        
        thisMonth=11;
    }else if(point.x < xVal*3 && point.y<=yVal*4+84){
        
        thisMonth=12;
    }
    
    [self performSegueWithIdentifier:@"JSUnwindView" sender:self];
}
-(void)myCalView{
    tag=1;
    _titleLabel.text= [NSString stringWithFormat:@"%lu년", thisYear];
    [_titleLabel setFont:[UIFont fontWithName:@"Quicksand-Regular" size:19]];

    double xVal=CGRectGetWidth(self.view.bounds)/3,yVal=CGRectGetHeight(self.view.bounds)/5;
    
    [self moreDateInfo:1 xVal:0 yVal:yVal*0+84];
    [self moreDateInfo:2 xVal:xVal yVal:yVal*0+84];
    [self moreDateInfo:3 xVal:xVal*2 yVal:yVal*0+84];
    [self moreDateInfo:4 xVal:0 yVal:yVal*1+84];
    [self moreDateInfo:5 xVal:xVal yVal:yVal*1+84];
    [self moreDateInfo:6 xVal:xVal*2 yVal:yVal*1+84];
    [self moreDateInfo:7 xVal:0 yVal:yVal*2+84];
    [self moreDateInfo:8 xVal:xVal yVal:yVal*2+84];
    [self moreDateInfo:9 xVal:xVal*2 yVal:yVal*2+84];
    [self moreDateInfo:10 xVal:0 yVal:yVal*3+84];
    [self moreDateInfo:11 xVal:xVal yVal:yVal*3+84];
    [self moreDateInfo:12 xVal:xVal*2 yVal:yVal*3+84];
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
    
    NSInteger newWeekDay=weekday-1;
    //    NSLog(@"Day week %d",newWeekDay);
    
    int yCount=1;
    
    yearly.text=[NSString stringWithFormat:@"%lu",thisYear];
    UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xVal+CGRectGetWidth(self.view.bounds)/6, yVal-10, 20, 20)];
    monthLabel.tag=tag++;
    [monthLabel setText:[NSString stringWithFormat:@"%d",showMonth]];
    [monthLabel setFont:[UIFont fontWithName:@"Quicksand" size:CGRectGetWidth(self.view.bounds)/2.8/12]];
    [self.view addSubview:monthLabel];
    for(int startDay=1; startDay<=numDays;startDay++){
        UILabel *dayButton = [[UILabel alloc]init];
        
        int xCoord=(newWeekDay*CGRectGetWidth(self.view.bounds)/2.8/8)+xVal+5;
        int yCoord=(yCount*CGRectGetWidth(self.view.bounds)/2.8/8)+yVal;
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        
        dayButton.frame = CGRectMake(xCoord+(CGRectGetWidth(self.view.bounds)/2.8/8/5), yCoord, CGRectGetWidth(self.view.bounds)/2.8/8, CGRectGetWidth(self.view.bounds)/2.8/8);
        [dayButton setText:[NSString stringWithFormat:@"%d",startDay]];
        [dayButton setFont:[UIFont fontWithName:@"Quicksand-Regular" size:CGRectGetWidth(self.view.bounds)/2.8/13]];
        [dayButton setTextColor:[UIColor blackColor]];
        dayButton.tag=tag++;
        [self.view addSubview:dayButton];
        int checkFalg =0;
        for(int parseNum=0; parseNum<createdAt.count; parseNum++){
            NSDictionary *parseDate = createdAt[parseNum];
            int parseMonth=[[parseDate valueForKey:@"_moodMonth"] intValue];
            int parseYear=[[parseDate valueForKey:@"_moodYear"] intValue];
            int parseDay=[[parseDate valueForKey:@"_moodDay"] intValue];
            
            if((parseYear==thisYear)&&(parseMonth==showMonth)&&(parseDay==startDay)&&(checkFalg==0)){
                [dayButton setTextColor:[UIColor clearColor]];
                checkFalg=1;
                //                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
                //                    }
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                //                }
                MDMoodColorView *mcv = [[MDMoodColorView alloc]initWithFrame:CGRectMake(xCoord, yCoord, CGRectGetWidth(self.view.bounds)/2.8/8, CGRectGetWidth(self.view.bounds)/2.8/8)];
                
                [mcv awakeFromNib];
                MDMoodFaceView *mfv = [[MDMoodFaceView alloc]initWithFrame:CGRectMake(xCoord, yCoord, xVal, yVal)];
                
                [mfv awakeFromNib];
                //                mcv.backgroundColor = [UIColor clearColor];
                NSNumber *tempMoodChosen = [parseDate valueForKey:kChosen1 ];
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                tempMoodChosen = [parseDate valueForKey:kChosen2 ];
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                tempMoodChosen = [parseDate  valueForKey:kChosen3 ];
                if(tempMoodChosen.intValue > 0)
                    //                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                
                
                //                    mmm = [[MDMakeMoodMonView alloc]init];
                //                    mcv = [self.view viewWithTag:7];
                //                    [dayButton setImage:[mmm makeMoodMon:createdAt[parseNum] view:mcv] forState:UIControlStateNormal];
                mcv.tag=tag++;
//                mfv.tag=tag++;
                mcv.layer.cornerRadius = mcv.frame.size.width/6;
//                mcv.layer.cornerRadius = mcv.frame.size.width/2;
                [mcv setNeedsDisplay];
//                [mfv setNeedsDisplay];
                [self.view addSubview:mcv];
                
                //                [self.view addSubview:mfv];
            }
        }

        
        
    }
}
@end