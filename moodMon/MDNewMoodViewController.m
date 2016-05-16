//
//  MDNewMoodViewController.m
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "MDNewMoodViewController.h"

@interface MDNewMoodViewController ()
@property CGFloat wheelDegree;
@property NSInteger moodCount;
@property NSArray *moodButtons;
@property NSArray *choosingMoodImages;
@property NSMutableArray *chosenMoods;
@property int previousIntensity;
@end



@implementation MDNewMoodViewController

@synthesize wheelDegree;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chosenMoods = [[NSMutableArray alloc] init];
    [self notificationInit];
    [self dateInit];
    [self moodViewInit];
    [self addTapGestureRecognizer];
    [self addWheelGestureRecognizer];
    [self drawRecentMoodView];
    [self textBoxInit];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self roundedViewsInit];
}


- (void)notificationInit {
    self.dataManager = [MDDataManager sharedDataManager];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:self.dataManager ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:self.dataManager ];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"newMoodNotChosen" object:self.dataManager ];
}


- (void)dateInit {
    // mood가 nil이 아니라는 것은 edit 모드로 들어왔다는 뜻.
    // self.mood에는 edit할 MDMoodMon이 들어가 있음.
    if(self.mood) {
        [self dateInitOnEditMode];
    }
    NSDate *today = [NSDate dateWithTimeIntervalSinceNow:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    _day.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:today]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    _date.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:today]];
}


- (void)dateInitOnEditMode {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:self.mood.moodDay];
    [dateComponents setMonth:self.mood.moodMonth];
    [dateComponents setYear:self.mood.moodYear];
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setDateFormat:@"EEEE"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    
    _day.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
    [dateFormatter setDateFormat:@"d MMMM yyyy"];
    _date.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}


- (void)drawRecentMoodView {
    [self.dataManager readAllFromDBAndSetCollection];
    NSUInteger recentMood = [self.dataManager recentMood];
//    NSLog(@"recent mood : %lu", (unsigned long)recentMood);
    self.recentMoodView.recentMood = recentMood;
    [self.recentMoodView setNeedsDisplay];
}


- (void)moodViewInit {
    self.moodCount = 0;
    
    /* moodDegree init */
    self.moodIntensityView.hidden = YES;
    NSArray *angryMoodImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"angry_degree1"],[UIImage imageNamed:@"angry_degree2"],[UIImage imageNamed:@"angry_degree3"],[UIImage imageNamed:@"angry_degree4"],[UIImage imageNamed:@"angry_degree5"], nil];
    NSArray *joyMoodImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"joy_degree1"],[UIImage imageNamed:@"joy_degree2"],[UIImage imageNamed:@"joy_degree3"],[UIImage imageNamed:@"joy_degree4"],[UIImage imageNamed:@"joy_degree5"], nil];
    NSArray *sadMoodImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"sad_degree1"],[UIImage imageNamed:@"sad_degree2"],[UIImage imageNamed:@"sad_degree3"],[UIImage imageNamed:@"sad_degree4"],[UIImage imageNamed:@"sad_degree5"], nil];
    NSArray *excitedMoodImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"excited_degree1"],[UIImage imageNamed:@"excited_degree2"],[UIImage imageNamed:@"excited_degree3"],[UIImage imageNamed:@"excited_degree4"],[UIImage imageNamed:@"excited_degree5"], nil];
    NSArray *tiredMoodImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"tired_degree1"],[UIImage imageNamed:@"tired_degree2"],[UIImage imageNamed:@"tired_degree3"],[UIImage imageNamed:@"tired_degree4"],[UIImage imageNamed:@"tired_degree5"], nil];
    self.choosingMoodImages = [NSArray arrayWithObjects:angryMoodImages, joyMoodImages, sadMoodImages, excitedMoodImages, tiredMoodImages, nil];
    
    /* moodButton init */
    self.angry.num = @10;
    self.joy.num = @20;
    self.sad.num = @30;
    self.excited.num = @40;
    self.tired.num = @50;
    self.angry.name = @"angry";
    self.joy.name = @"joy";
    self.sad.name = @"sad";
    self.excited.name = @"excited";
    self.tired.name = @"tired";
    self.angry.startAngle = 0;
    self.joy.startAngle = 1.2;
    self.sad.startAngle = 2.47;
    self.excited.startAngle = 3.8;
    self.tired.startAngle = 5.1;
    self.moodButtons = @[self.angry, self.joy, self.sad, self.excited, self.tired];
    
}


- (void)roundedViewsInit {
    /* moodColor & mixedMoodFace init */
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
    self.moodColor.layer.cornerRadius = self.moodColor.frame.size.width/2;
    self.moodColor.layer.masksToBounds = YES;
    self.moodColor.hidden = NO;
    self.mixedMoodFace.layer.cornerRadius = self.mixedMoodFace.frame.size.width/2;
    self.mixedMoodFace.layer.masksToBounds = YES;
    
    /* save & reset button background */
    self.saveButtonBackground.hidden = YES;
    self.saveButtonBackground.layer.cornerRadius = self.saveButtonBackground.frame.size.width/2;
    self.saveButtonBackground.layer.masksToBounds = YES;
    self.saveButtonBackground.layer.opacity = 0.9;
    self.skipButtonBackground.layer.cornerRadius = self.skipButtonBackground.frame.size.width/2;
    self.skipButtonBackground.layer.masksToBounds = YES;
    self.skipButtonBackground.hidden = NO;
}


- (void)textBoxInit {
    /* UI init */
    UIColor *color = [[UIColor grayColor] colorWithAlphaComponent:0.7];
    self.textField.layer.borderColor = color.CGColor;
    self.textField.layer.borderWidth = 0.7;
    self.textField.layer.cornerRadius = self.textField.frame.size.height/2;
    self.textField.clipsToBounds = YES;
    self.textField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0];
    // self.mood가 nil이 아니라는 것은 edit mode라는 뜻.
    // edit mode일 때는 self.mood에 들어있는 코멘트를 placeholder와 self.comment에 지정함.
    if(self.mood) {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.mood.moodComment
                                                                               attributes:@{NSForegroundColorAttributeName:color}];
        self.comment = self.mood.moodComment;
    } else {
        self.textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Comment on your feeling!"
                                                                               attributes:@{NSForegroundColorAttributeName:color}];
    }
    
    /* gesture recognizer to cancel typing */
    [self.textField setDelegate:self];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:recognizer];
}


- (void)showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)addTapGestureRecognizer {
    for(UIImageView *mood in self.moodButtons){
        mood.userInteractionEnabled = YES;
//        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                              action:@selector(tapped:)];
        MDTouchDownGestureRecognizer *recognizer = [[MDTouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [mood addGestureRecognizer:recognizer];
    }
}



- (void)tapped:(UIGestureRecognizer *)tap {
    MDMoodButtonView *moodButton = (MDMoodButtonView *)tap.view;
    if(self.moodCount<3 || moodButton.isSelected) {     // 이미 감정을 세 개 이상 골랐으면 더 선택할 수 없음. 단 기존에 선택한 것을 해제하는건 됨.
        [self changeMoodButtonImage:moodButton];
    }
    [UIView transitionWithView:self.view
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if(self.moodCount<1) {
                            self.mixedMoodFace.hidden = YES;
                            [self.mixedMoodFace setNeedsDisplay];
                            self.saveButtonBackground.hidden = YES;
                        }
                        else {
                            self.mixedMoodFace.hidden = NO;
                            self.saveButtonBackground.hidden = NO;
                            self.skipButtonBackground.hidden = NO;
                        }
                        [self setChoosingMoodImageByNum:moodButton.num];
                    }
                    completion:nil];
    if(moodButton.isSelected) {     // 감정을 선택하기 위해 버튼을 누른 경우 휠을 띄워줌.
        [self showWheelView:moodButton];
        [self addNewChosenMood:moodButton.num];
    }
    else {      // 감정선택을 해제하기 위해 버튼을 누른 경우, 해당 감정을 chosenMoods 배열에서 제거함.
        [self deleteFromChosenMoods:moodButton.num];
    }
}



- (void)setChoosingMoodImageByNum:(NSNumber *)num {
    int moodClass = num.intValue/10 - 1;
    int moodIntensity = num.intValue%10;
    self.moodIntensityView.image = self.choosingMoodImages[moodClass][moodIntensity];
}



- (void)changeMoodButtonImage:(MDMoodButtonView *)moodButton {
    moodButton.isSelected = !moodButton.isSelected;
    moodButton.isSelected ? self.moodCount++ : self.moodCount--;
    NSString *surfix = (moodButton.isSelected) ? @"selected" : @"unselect";
    NSString *imageName = [[NSString alloc]initWithFormat:@"%@_%@", moodButton.name, surfix];
    moodButton.image = [UIImage imageNamed:imageName];
}


// 선택한 moodButton에 해당하는 wheel 색깔로 바꿔서 보여줌
- (void)showWheelView:(MDMoodButtonView *)moodButton {
//    [UIView transitionWithView:self.wheel
//                      duration:0.2
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//                    }
//                    completion:nil];
    self.wheel.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_wheel", moodButton.name]];
    self.wheel.transform = CGAffineTransformMakeRotation(moodButton.startAngle);
    self.progressWheel.currentMoodNum = moodButton.num.intValue/10;
    self.progressWheel.startAngle = moodButton.startAngle;
    
    self.moodIntensityView.hidden = (self.moodCount<1 || self.moodCount>3) ? YES:NO;
    self.wheelDegree = 0;
    self.previousIntensity = 0;
    for(MDMoodButtonView *moodButton in self.moodButtons) {
        moodButton.hidden = YES;
    }
}



- (void)addNewChosenMood:(NSNumber *)moodNum {
    // 새로 선택한 감정을 chosenMoods에 추가.
    // chosenMoods의 역할 : 선택한 mood들의 정보와 순서를 임시로 저장해둠. 나중에 chosenMoods를 바탕으로 디비에 입력할 거임.
    NSMutableDictionary *chosenMood = [@{@"moodClass" : moodNum, @"moodIntensity" : @1} mutableCopy];
    
    [self.moodColor.chosenMoods addObject:moodNum];
    [self.moodColor setNeedsDisplay];
    
    [self.saveButtonBackground.chosenMoods addObject:moodNum];
    [self.saveButtonBackground setNeedsDisplay];
    
    [self.chosenMoods addObject:chosenMood];
//    NSLog(@"%@", self.chosenMoods);
}



- (void)deleteFromChosenMoods:(NSNumber *)moodClass {
    NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"moodClass != %@", moodClass];
    self.chosenMoods = [[self.chosenMoods filteredArrayUsingPredicate:predicate1] mutableCopy];
    for(int i=0 ; i<[self.moodColor.chosenMoods count] ; i++) {
        if(self.moodColor.chosenMoods[i] == moodClass) {
            [self.moodColor.chosenMoods removeObjectAtIndex:i];
        }
    }
    for(int i=0 ; i<[self.saveButtonBackground.chosenMoods count] ; i++) {
        if(self.saveButtonBackground.chosenMoods[i] == moodClass) {
            [self.saveButtonBackground.chosenMoods removeObjectAtIndex:i];
        }
    }
    for(int i=0 ; i<[self.mixedMoodFace.chosenMoods count] ; i++) {
        if(self.mixedMoodFace.chosenMoods[i].intValue/10 == moodClass.intValue/10) {
            [self.mixedMoodFace.chosenMoods removeObjectAtIndex:i];
        }
    }
    [self.moodColor setNeedsDisplay];
    [self.saveButtonBackground setNeedsDisplay];
    [self.mixedMoodFace setNeedsDisplay];
}



- (void)addWheelGestureRecognizer {
    MDWheelGestureRecognizer *recognizer = [[MDWheelGestureRecognizer alloc] initWithTarget:self
                                                                                wheelAction:@selector(rotateWheel:)
                                                                              touchUpAction:@selector(returnToStartView)];
    [recognizer setDelegate:self];
    [self.container addGestureRecognizer:recognizer];
}



- (void)rotateWheel:(id)sender {
    if(self.moodIntensityView.hidden) {     // wheelGesture와 tapGesture가 동시에 동작하는 거 방지
        return;
    }
    
    MDWheelGestureRecognizer *recognizer = (MDWheelGestureRecognizer *)sender;
    
    //wheel 회전
    CGFloat angle = recognizer.currentAngle - recognizer.previousAngle;
    [self setWheelDegreeWithAngle:angle];
    [self transformWheelWithAngle:angle];
    
    //wheel progress bar
    self.progressWheel.endAngle = recognizer.currentAngle;
    [self.progressWheel setNeedsDisplay];
    
    //돌린 정도에 따라 휠 가운데 이미지 변화
    [self setMoodIntensity];
}



- (void)setWheelDegreeWithAngle:(CGFloat)angle {
    self.wheelDegree += angle * 180 / M_PI;
    if(self.wheelDegree < -0.5) {
        self.wheelDegree += 360;
    }
    else if (self.wheelDegree > 359.5) {
        self.wheelDegree -= 360;
    }
}



- (void)transformWheelWithAngle:(CGFloat)angle {
    CGAffineTransform wheelTransform = self.wheel.transform;
    CGAffineTransform newWheelTransform = CGAffineTransformRotate(wheelTransform, angle);
    [self.wheel setTransform:newWheelTransform];
}



- (void)setMoodIntensity {
    NSNumber *moodIntensity = [NSNumber numberWithInt:self.wheelDegree/72];
    
    if(_previousIntensity != moodIntensity.intValue) {
        _previousIntensity = moodIntensity.intValue;
        [[self.chosenMoods lastObject] setValue:moodIntensity forKey:@"moodIntensity"];
        int moodClass = [[[self.chosenMoods lastObject] objectForKey:@"moodClass"] intValue]/10 - 1;
        [UIView transitionWithView:self.moodIntensityView
                          duration:0.1
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            self.moodIntensityView.image = self.choosingMoodImages[moodClass][moodIntensity.intValue];
                        }
                        completion:nil];
    }
}


- (void)setMixedMoodFaceWithNum:(NSNumber *)moodNum {
    [self.mixedMoodFace.chosenMoods addObject:moodNum];
    [self.mixedMoodFace setNeedsDisplay];
}


- (void)returnToStartView {
    if(self.moodIntensityView.hidden) {     // wheelGesture와 tapGesture가 동시에 동작하는 거 방지
        return;
    }
    [UIView transitionWithView:self.view
                      duration:0.2
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if(self.moodCount<3) {
                            self.mixedMoodFace.hidden = NO;
                        }
                        self.moodIntensityView.hidden = YES;
                        self.wheel.image = [UIImage imageNamed:@"circle"];
                        for(MDMoodButtonView *moodButton in self.moodButtons) {
                            moodButton.hidden = NO;
                        }
                        
                        if(self.moodCount<1) {
                            self.saveButtonBackground.hidden = YES;
                            self.skipButtonBackground.hidden = YES;
                        }
                    }
                    completion:nil];
    int moodNum = [[self.chosenMoods lastObject][@"moodClass"] intValue] + [[self.chosenMoods lastObject][@"moodIntensity"] intValue];
    [self setMixedMoodFaceWithNum:[NSNumber numberWithInt:moodNum]];
    
    [self.progressWheel erasePath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dismissKeyboard {
    if(self.textField.editing == NO) {
        return;
    }
    [self.textField resignFirstResponder];
    [self moveEntireViewWithDuration:0.3 distance:+200];
}


- (IBAction)didTextFieldActivate:(id)sender {
    [self moveEntireViewWithDuration:0.3 distance:-200];
}

- (IBAction)didComment:(id)sender {
    self.comment = self.textField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self moveEntireViewWithDuration:0.3 distance:+200];
    return YES;
}

- (void)moveEntireViewWithDuration:(CGFloat)duration distance:(CGFloat)distance {
    [UIView transitionWithView:self.view
                      duration:duration
                       options:UIViewAnimationOptionCurveEaseInOut
                    animations:^{
                        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+distance, self.view.frame.size.width, self.view.frame.size.height)];
                    }
                    completion:nil];
}


- (IBAction)saveNewMoodMon:(id)sender {
//    NSString *comment = @"text Field's text";  //차후 로컬변수가 아닌 인스턴스 변수로 만들어야 함.
    int firstChosen=0, secondChosen=0, thirdChosen=0;
    
    if([self.chosenMoods count] > 0){
        firstChosen = [[self.chosenMoods[0] objectForKey:@"moodClass"] intValue] + [[self.chosenMoods[0] objectForKey:@"moodIntensity"] intValue];
        if([self.chosenMoods count]>=2) {
            secondChosen = [[self.chosenMoods[1] objectForKey:@"moodClass"] intValue] + [[self.chosenMoods[1] objectForKey:@"moodIntensity"] intValue];
        }
        if([self.chosenMoods count]>=3) {
            thirdChosen = [[self.chosenMoods[2] objectForKey:@"moodClass"] intValue] + [[self.chosenMoods[2] objectForKey:@"moodIntensity"] intValue];
        }
        NSLog(@"저장한 감정 : %d, %d, %d", firstChosen, secondChosen, thirdChosen);
        [self.dataManager saveNewMoodMonOfComment:_comment asFirstChosen:firstChosen SecondChosen:secondChosen andThirdChosen:thirdChosen];
    /*
     mood int 확인,
     MDDateManager saveNewMoodMonOfComment~ 메소드에서 하고 있습니다.
     여기서 하는 게 제일 좋은 건지는 아직 모르겠네요. 방어차 남겨 놓는 것도 좋은 것 같아요.
     그 전에, 위 메소드 부르기 전에도  mood int 체크 하는 게 좋을 것 같아요~
     newMoodmon view에서 mood int가 어떻게 정해지는 지, 어디에 그 데이터가 남는지 아직 모르겠지만, 해당 코드 완성되면, 이 부분 한번 정하면 좋을 것 같아요.
     */
//        NSLog(@"Saving new Mood mon");
    }
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)skip:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}


- (void) presentCalendar{
    
}

@end
