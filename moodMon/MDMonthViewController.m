//
//  MDMonthViewController.m
//  moodMon
//
//  Created by 이재성 on 2016. 4. 9..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import "MDMonthViewController.h"

@interface MDMonthViewController (){
    BOOL toolbarIsOpen;
    BOOL toolbarIsAnimating;
    int myDay;
}

@end

extern NSUInteger numDays;
extern NSInteger thisYear;
NSUInteger thisMonth;
extern NSInteger weekday;
extern int tag;
NSArray *createdAt;
int count;
NSMutableArray *moodmonConf;
UITableViewHeaderFooterView *headerView;
NSMutableArray <NSIndexPath *> *indexPathsToDelete;
UIFont *quicksand;
UIFont *boldQuicksand;


@implementation MDMonthViewController{

}
@synthesize thisYear;
@synthesize thisMonth;

-(void)awakeFromNib{
    
    //image loading
    _angryChecked = [UIImage imageNamed:@"angry_filter@2x"];
    _angryUnchecked = [UIImage imageNamed:@"angry_unfilter@2x"];
    _happyChecked = [UIImage imageNamed:@"joy_filter@2x"];
    _happyUnchecked = [UIImage imageNamed:@"joy_unfilter@2x"];
    _sadChecked = [UIImage imageNamed:@"sad_filter@2x"];
    _sadUnchecked = [UIImage imageNamed:@"sad_unfilter@2x"];
    _exciteChecked = [UIImage imageNamed:@"excited_filter@2x"];
    _exciteUnchecked = [UIImage imageNamed:@"excited_unfilter@2x"];
    _exhaustChecked = [UIImage imageNamed:@"tired_filter@2x"];
    _exhaustUnchecked = [UIImage imageNamed:@"tired_unfilter@2x"];
    
}



- (void)viewDidLoad {
    
    count=0;
    [super viewDidLoad];
    _mddm = [MDDataManager sharedDataManager];
    //[mddm createDB];
    
    toolbarIsOpen = YES;
    toolbarIsAnimating = NO;
    self.toolbarContainer.translatesAutoresizingMaskIntoConstraints = YES;
    [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 49), self.view.frame.size.width, 49.0)];
    [self collapseToolbarWithoutBounce];
    [self.angryFilterBtn setImage: _angryUnchecked forState:UIControlStateNormal];
    [self.happyFilterBtn setImage: _happyUnchecked forState:UIControlStateNormal];
    [self.sadFilterBtn setImage: _sadUnchecked forState:UIControlStateNormal];
    [self.exciteFilterBtn setImage: _exciteUnchecked forState:UIControlStateNormal];
    [self.exhaustFilterBtn setImage: _exhaustUnchecked forState:UIControlStateNormal];
    [_angryFilterBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [_happyFilterBtn.imageView setContentMode:UIViewContentModeScaleToFill];
    [_sadFilterBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_exciteFilterBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [_exhaustFilterBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:_mddm ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:_mddm ];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(timeTableReload) name:@"newDatxaAdded" object:_mddm];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"iCloudSyncFinished" object:_mddm];
    
    quicksand = [UIFont fontWithName:@"Quicksand" size:16];
    boldQuicksand = [UIFont fontWithDescriptor:[[quicksand fontDescriptor] fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:quicksand.pointSize];
    
    createdAt=[_mddm moodCollection];
    thisYear =[[[NSCalendar currentCalendar]components:NSCalendarUnitYear fromDate:[NSDate date]]year];
    thisMonth =[[[NSCalendar currentCalendar]components:NSCalendarUnitMonth fromDate:[NSDate date]]month];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    [self moreDateInfo];
    
    indexPathsToDelete = [[NSMutableArray alloc] init];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self removeTags];
    myDay = 0;
    
    [_filterButton setFont:quicksand];
//    [_dataButton setTitleTextAttributes:@{NSFontAttributeName:quicksand} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                         [UIColor colorWithRed:91/255.0 green:88/255.0 blue:85/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                         quicksand, NSFontAttributeName, nil]
                                               forState:UIControlStateNormal];
    UILabel *topItem = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.width)];
    topItem.backgroundColor = [UIColor clearColor];
    topItem.font = boldQuicksand;
    topItem.textAlignment = NSTextAlignmentCenter;
    topItem.text = [NSString stringWithFormat:@"     %d년 %d월", thisYear, thisMonth];
    self.navigationItem.titleView = topItem;
    
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:boldQuicksand} forState:UIControlStateNormal];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:boldQuicksand} forState:UIControlStateNormal];
    
    [self resetTimeTable];
    [self moreDateInfo];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***************** filter tool bar animation **************/

- (IBAction)expandButtonTouched{
    if (!toolbarIsAnimating) {
        toolbarIsAnimating = YES;
        [self expandToolbarWithoutBounce];
        
    }
}

-(IBAction)collapseButtontouched{
    if (!toolbarIsAnimating) {
        toolbarIsAnimating = YES;
        [self collapseToolbarWithoutBounce];
    }
    
    [_mddm getFilteredMoodmons];
    // NSLog(@" %d", _mddm.chosenMoodCount);
}

- (void)collapseToolbarWithoutBounce{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height ), self.view.frame.size.width, 49.0)];
    } completion:^(BOOL finished) {
        toolbarIsOpen = NO;
        toolbarIsAnimating = NO;
        //[self.collapseButton setTitle:@"\u2B06" forState:UIControlStateNormal];
    }];
}

- (void)expandToolbarWithoutBounce{
    [UIView animateWithDuration:0.25 animations:^{
        [self.toolbarContainer setFrame:CGRectMake(0, (self.view.frame.size.height - 49), self.view.frame.size.width, 49.0)];
    } completion:^(BOOL finished) {
        toolbarIsOpen = YES;
        toolbarIsAnimating = NO;
        // [self.collapseButton setTitle:@"\u2B07" forState:UIControlStateNormal];
    }];
}
//filtering
- (IBAction)filterButtonClicked:(id)sender{
    if(sender == self.angryFilterBtn){
        
        if([_mddm.isChecked[0]  isEqual: @NO]){
            _mddm.isChecked[0] = @YES;
            _mddm.chosenMoodCount++;
            [self.angryFilterBtn setImage: _angryChecked forState:UIControlStateNormal];
            
        } else {
            _mddm.isChecked[0] = @NO;
            _mddm.chosenMoodCount--;
            [self.angryFilterBtn setImage: _angryUnchecked forState:UIControlStateNormal];
        }
        
        
    } else if (sender == self.happyFilterBtn){
        
        if([_mddm.isChecked[1]  isEqual: @NO]){
            _mddm.isChecked[1] = @YES;
            _mddm.chosenMoodCount++;
            [self.happyFilterBtn setImage: _happyChecked forState:UIControlStateNormal];
        } else {
            _mddm.isChecked[1] = @NO;
            _mddm.chosenMoodCount--;
            [self.happyFilterBtn setImage: _happyUnchecked forState:UIControlStateNormal];
        }
        
        
    } else if (sender == self.sadFilterBtn){
        
        if([_mddm.isChecked[2]  isEqual: @NO]){
            _mddm.isChecked[2] = @YES;
            _mddm.chosenMoodCount++;
            [self.sadFilterBtn setImage:_sadChecked forState:UIControlStateNormal];
//            [self.sadFilterBtn setBackgroundImage: _sadChecked forState:UIControlStateNormal];
        } else {
            _mddm.isChecked[2] = @NO;
            _mddm.chosenMoodCount--;
            [self.sadFilterBtn setImage: _sadUnchecked forState:UIControlStateNormal];
        }
        
    } else if (sender == self.exciteFilterBtn){
        
        if([_mddm.isChecked[3]  isEqual: @NO]){
            _mddm.isChecked[3] = @YES;
            _mddm.chosenMoodCount++;
            [self.exciteFilterBtn setImage: _exciteChecked forState:UIControlStateNormal];
            
        } else {
            _mddm.isChecked[3] = @NO;
            _mddm.chosenMoodCount--;
            [self.exciteFilterBtn setImage: _exciteUnchecked forState:UIControlStateNormal];
        }
        
    } else if (sender == self.exhaustFilterBtn){
        
        if([_mddm.isChecked[4]  isEqual: @NO]){
            _mddm.isChecked[4] = @YES;
            _mddm.chosenMoodCount++;
            [self.exhaustFilterBtn setImage: _exhaustChecked forState:UIControlStateNormal];
        } else {
            _mddm.isChecked[4] = @NO;
            _mddm.chosenMoodCount--;
            [self.exhaustFilterBtn setImage: _exhaustUnchecked forState:UIControlStateNormal];
        }
        
    } else {
        NSLog(@"wrong filter btn clicked");
    }
    [self removeTags];
    [self moreDateInfo];
    [indexPathsToDelete removeAllObjects];
    [self.tableViews reloadData];
}


/**************************************************/


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





-(void)goToYearView{
    MDYearViewController *yvc = [[MDYearViewController alloc]initWithNibName:@"yearVC" bundle:nil];
    [yvc setModalTransitionStyle:UIModalTransitionStylePartialCurl];
    [self presentViewController:yvc animated:YES completion:nil];
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
    UILabel *topItem = [[UILabel alloc] initWithFrame:CGRectMake(0,0, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.width)];
    topItem.backgroundColor = [UIColor clearColor];
    topItem.font = boldQuicksand;
    topItem.textAlignment = NSTextAlignmentCenter;
    topItem.text = [NSString stringWithFormat:@"     %d년 %d월", thisYear, thisMonth];
    self.navigationItem.titleView = topItem;
    [self resetTimeTable];
}

-(void)resetTimeTable{
    moodmonConf = NULL;
    myDay = 0;
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
-(void)removeTagsMon{
    int x=32;
    while(x<=200){
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
    int xVal=CGRectGetWidth(self.view.bounds)/7,yVal=CGRectGetHeight(self.view.bounds)/12;
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
    
    NSInteger newWeekDay=weekday-1;
    //    NSLog(@"Day week %d",newWeekDay);
    
    NSInteger yCount=1;
    NSInteger xCoord=0;
    NSInteger yCoord=self.navigationController.navigationBar.frame.size.height+20;
    UILabel *backgroundLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord, yCoord, CGRectGetWidth(self.view.bounds),yVal*2/3)];
    [backgroundLabel setBackgroundColor:[UIColor colorWithRed:222.0f/255.0f green:212.0f/255.0f blue:198.0f/255.0f alpha:1.0f]];
    [self.view addSubview:backgroundLabel];
    for(int i=0;i<7;i++){
        UILabel *monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(xCoord+(xVal*i)+xVal/3, yCoord-10, xVal, yVal)];
        switch (i) {
            case 1:
                [monthLabel setText:[NSString stringWithFormat:@"Mon"]];
                break;
            case 2:
                [monthLabel setText:[NSString stringWithFormat:@"Tue"]];
                break;
            case 3:
                [monthLabel setText:[NSString stringWithFormat:@"Wed"]];
                break;
            case 4:
                [monthLabel setText:[NSString stringWithFormat:@"Thu"]];
                break;
            case 5:
                [monthLabel setText:[NSString stringWithFormat:@"Fri"]];
                break;
            case 6:
                [monthLabel setText:[NSString stringWithFormat:@"Sat"]];
                break;
            case 0:
                [monthLabel setText:[NSString stringWithFormat:@"Sun"]];
                break;
            default:
                break;
        }
        [monthLabel setFont:[UIFont fontWithName:@"Quicksand" size:13]];
        monthLabel.tag = tag++;
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
        yCoord=(yCount*yVal);
        
        newWeekDay++;
        if(newWeekDay>6){
            newWeekDay=0;
            yCount++;
        }
        [dayButton setFont:[UIFont fontWithName:@"Quicksand" size:14]];
        dayButton.frame = CGRectMake(xCoord, yCoord, xVal, yVal);
        [dayButton setTitle:[NSString stringWithFormat:@"%d",startDay]forState:UIControlStateNormal];
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
                
                //                    [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen1"]];
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen2"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen2"]];
                //                    }
                //                    if([createdAt[parseNum] valueForKey:@"_moodChosen3"]!=0){
                //                        [self.moodColor.chosenMoods addObject:[createdAt[parseNum] valueForKey:@"_moodChosen3"]];
                //                }
                
                
                
                NSInteger yCoordCenter = yVal/2+yCoord-xVal*4/10;
                NSInteger xCoordCenter = xVal/2+xCoord-xVal*4/10;
                MDSmallMoodFaceView *mfv = [[MDSmallMoodFaceView alloc]initWithFrame:CGRectMake(0,0, xVal*4/5, xVal*4/5)];
                
                [mfv awakeFromNib];
                MDMoodColorView *mcv = [[MDMoodColorView alloc]initWithFrame:CGRectMake(xCoordCenter,yCoordCenter, CGRectGetWidth(mfv.bounds)-2 , CGRectGetWidth(mfv.bounds)-2)];
                
                [mcv awakeFromNib];
                
                //                mcv.backgroundColor = [UIColor clearColor];
//                NSArray *dayRepresenatationColors = [_mddm representationOfMoodAtYear:(NSInteger)parseYear Month:(NSInteger)parseMonth andDay:parseDay];
                
                NSNumber *tempMoodChosen = [parseDate valueForKey:kChosen1 ];
                if(tempMoodChosen.intValue > 0){
                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:1 ];
                }
                tempMoodChosen = [parseDate valueForKey:kChosen2 ];
                if(tempMoodChosen.intValue > 0){
                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:2 ];
                }
                tempMoodChosen =[parseDate valueForKey:kChosen3 ];
                if(tempMoodChosen.intValue > 0){
                    [mfv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                    [mcv.chosenMoods insertObject: tempMoodChosen atIndex:3 ];
                }
                mfv.backgroundColor =[UIColor clearColor];
                
                //                    mmm = [[MDMakeMoodMonView alloc]init];
                //                    mcv = [self.view viewWithTag:7];
                //                    [dayButton setImage:[mmm makeMoodMon:createdAt[parseNum] view:mcv] forState:UIControlStateNormal];
                BOOL isVisible = [self checkVisibility:mfv.chosenMoods];
                if(isVisible ==YES){
                    [dayButton setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
                    checkFalg=1;
                    mcv.tag=tag++;
                    mfv.tag=tag++;
                    mcv.layer.cornerRadius = mcv.frame.size.width/2;
                    [mcv setNeedsDisplay];
                    [mfv setNeedsDisplay];
                    [mcv addSubview:mfv];
                    mcv.layer.masksToBounds=YES;
                    [self.view addSubview:mcv];
                }
            }
        }
        [self.view addSubview:dayButton];
    }
}


- (BOOL)checkVisibility:(NSArray *)chosenMoods {
    if([_mddm.isChecked[0] isEqual:@NO]&&[_mddm.isChecked[1] isEqual:@NO]&&[_mddm.isChecked[2] isEqual:@NO]&&[_mddm.isChecked[3] isEqual:@NO]&&[_mddm.isChecked[4] isEqual:@NO]){
        return YES;
    }
    else{
        if([_mddm.isChecked[0] isEqual:@YES]){
            for (NSString *checked in chosenMoods) {
                if(checked.intValue /10 ==1)
                    return YES;
            }
        }if([_mddm.isChecked[1] isEqual:@YES]){
            for (NSString *checked in chosenMoods) {
                if(checked.intValue /10 ==2)
                    return YES;
            }
        }if([_mddm.isChecked[2] isEqual:@YES]){
            for (NSString *checked in chosenMoods) {
                if(checked.intValue /10 ==3)
                    return YES;
            }
        }if([_mddm.isChecked[3] isEqual:@YES]){
            for (NSString *checked in chosenMoods) {
                if(checked.intValue /10 ==4)
                    return YES;
            }
        }if([_mddm.isChecked[4] isEqual:@YES]){
            for (NSString *checked in chosenMoods) {
                if(checked.intValue /10 ==5)
                    return YES;
            }
        }
        return NO;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >0) {
        headerView.transform = CGAffineTransformMakeTranslation(0, offsetY);
    } else {
        headerView.transform = CGAffineTransformMakeTranslation(0, MAX(offsetY, 0));
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return moodmonConf.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(myDay == 0) {
        return nil;
    }
    NSString *date =[NSString stringWithFormat:@"%d년 %d월 %d일", thisYear, thisMonth, myDay];
    return date;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.font = [UIFont fontWithName:@"Quicksand" size:14];
    header.textLabel.frame = header.frame;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    headerView = (UITableViewHeaderFooterView *)view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MDMonthTimeLineCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MDMonthTimeLineCellTableViewCell" forIndexPath:indexPath];
    cell.commentLabel.text = [NSString stringWithFormat:@"%@",[moodmonConf[indexPath.row]valueForKey:@"_moodComment" ]];
    NSString *timeText = [NSString stringWithFormat:@"%@", [moodmonConf[indexPath.row] valueForKey:kTime]];
//    timeText = [timeText stringByReplacingOccurrencesOfString:@"시 " withString:@" : "];
//    timeText = [timeText stringByReplacingOccurrencesOfString:@"분 " withString:@" : "];
//    timeText = [timeText stringByReplacingOccurrencesOfString:@"초" withString:@"   "];
    cell.timeLabel.text = timeText;
    cell.itemText = [moodmonConf[indexPath.row] valueForKey:@"_moodComment"];
    cell.delegate = self;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *viewForFrame =  [cell viewWithTag:100];
    viewForFrame.layer.cornerRadius = viewForFrame.frame.size.width/2;
    viewForFrame.layer.masksToBounds = YES;
    
    MDMoodColorView *colorView = [[MDMoodColorView alloc] init];
    MDSmallMoodFaceView *faceView = [[MDSmallMoodFaceView alloc] init];

    CGRect frame = CGRectMake(0, 0, viewForFrame.frame.size.width, viewForFrame.frame.size.height);
    [colorView setFrame:frame];
    [faceView setFrame:frame];
    
    [viewForFrame addSubview:colorView];
    [viewForFrame addSubview:faceView];
    
    
    for(int i = 1 ;i <colorView.chosenMoods.count ; i++){
        [colorView.chosenMoods removeObjectAtIndex:i];
        [faceView.chosenMoods removeObjectAtIndex:i];
    }
    
    [faceView awakeFromNib];
    
    NSNumber *moodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen1];
    if(moodChosen.intValue != 0){
        [colorView.chosenMoods insertObject: moodChosen atIndex:1 ];
        [faceView.chosenMoods insertObject: moodChosen atIndex:1 ];
    }
    moodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen2];
    if(moodChosen.intValue != 0){
        [colorView.chosenMoods insertObject: moodChosen atIndex:2 ];
        [faceView.chosenMoods insertObject: moodChosen atIndex:2 ];
    }
    moodChosen = [moodmonConf[indexPath.row] valueForKey:kChosen3];
    if(moodChosen.intValue != 0){
        [colorView.chosenMoods insertObject: moodChosen atIndex:3 ];
        [faceView.chosenMoods insertObject: moodChosen atIndex:3 ];
    }
    
    BOOL isVisible = [self checkVisibility:colorView.chosenMoods];
    
    if(isVisible == NO) {
        cell.isFiltered = YES;
        [indexPathsToDelete addObject:indexPath];
    }
    
    colorView.layer.cornerRadius = (int)colorView.frame.size.width/2;
    colorView.layer.masksToBounds = YES;
    [colorView setNeedsDisplay];
    [faceView setNeedsDisplay];
    
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([indexPathsToDelete containsObject:indexPath]) {
        return 0;
    }
    return 60;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // [_objects removeObjectAtIndex:indexPath.row];
        [self.tableViews deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        NSLog(@"Unhandled editing style! %d",editingStyle);
    }
}


#pragma mark - MDSwipeableCellDelegate
- (void)buttonOneActionForItemText:(NSString *)itemText {
}

- (void)buttonTwoActionForItemText:(MDMoodColorView *)itemText {
    MDSaveMoodMon *smm = [[MDSaveMoodMon alloc] init];
    [smm saveMoodMon:itemText];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"SAVE" message:@"저장되었습니다." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
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