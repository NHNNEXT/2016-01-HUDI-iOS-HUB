//
//  MDNewMoodViewController.m
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "MDNewMoodViewController.h"

@interface MDNewMoodViewController ()
@property float wheelDegree;
@property int moodCount;
@property NSArray *moodButtons;
@property NSMutableArray *chosenMoods;
@end



@implementation MDNewMoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [MDDataManager sharedDataManager];
    [self.dataManager createDB];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:self.dataManager ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:self.dataManager ];
    
    [self initiateMoodViews];
    [self addTapGestureRecognizer];
    [self addWheelGestureRecognizer];
    self.chosenMoods = [[NSMutableArray alloc] init];
}



-(void)initiateMoodViews {
    self.moodCount = 0;
    self.centerMood.hidden = YES;
    
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
    self.angry.startingDegree = 0;
    self.joy.startingDegree = 1.2;
    self.sad.startingDegree = 2.47;
    self.excited.startingDegree = 3.8;
    self.tired.startingDegree = 5.1;
    
    self.moodButtons = @[self.angry, self.joy, self.sad, self.excited, self.tired];
}



-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:defaultAction];
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)addTapGestureRecognizer {
    for(UIImageView *mood in self.moodButtons){
        mood.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapped:)];
        [mood addGestureRecognizer:tap];
    }
}



- (void)tapped:(UIGestureRecognizer *)tap {
    MDMoodButtonView *moodButton = (MDMoodButtonView *)tap.view;
    if(moodButton.isSelected || self.moodCount<3){
        [self changeMoodButtonImage:moodButton];
    }
    self.centerMood.hidden = (self.moodCount<1)? YES:NO;
    if(moodButton.isSelected && self.moodCount<4) {
        [self showWheelView:moodButton];
        [self addNewChosenMood:moodButton.num];
    }
}



- (void)showWheelView:(MDMoodButtonView *)moodButton {
    self.wheel.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_wheel", moodButton.name]];
    self.wheel.transform = CGAffineTransformMakeRotation(moodButton.startingDegree);
    self.wheelDegree = 0;
    for(MDMoodButtonView *moodButton in self.moodButtons) {
        moodButton.hidden = YES;
    }
}



- (void)addNewChosenMood:(NSNumber *)moodNum {
    // 새로 선택한 감정을 chosenMoods에 추가.
    // chosenMoods의 역할 : 선택한 mood들의 정보와 순서를 임시로 저장해둠. 나중에 chosenMoods를 바탕으로 디비에 입력할 거임.
    NSMutableDictionary *chosenMood = [@{@"moodNum" : moodNum, @"moodIntensity" : @1} mutableCopy];
    [self.chosenMoods addObject:chosenMood];
}



- (void)changeMoodButtonImage:(MDMoodButtonView *)moodButton {
    moodButton.isSelected = !moodButton.isSelected;
    moodButton.isSelected ? self.moodCount++ : self.moodCount--;
    NSString *surfix = (moodButton.isSelected) ? @"selected" : @"unselect";
    NSString *imageName = [[NSString alloc]initWithFormat:@"%@_%@", moodButton.name, surfix];
    moodButton.image = [UIImage imageNamed:imageName];
}



- (void)addWheelGestureRecognizer {
    MDWheelGestureRecognizer *recognizer = [[MDWheelGestureRecognizer alloc] initWithTarget:self action:@selector(rotateWheel:)];
    [recognizer setDelegate:self];
    [self.container addGestureRecognizer:recognizer];
}



- (void)rotateWheel:(id)sender {
    MDWheelGestureRecognizer *recognizer = (MDWheelGestureRecognizer *)sender;
    CGFloat angle = recognizer.currentAngle - recognizer.previousAngle;
    
    self.wheelDegree += angle * 180 / M_PI;
    if(self.wheelDegree < -0.5) {
        self.wheelDegree += 360;
    }
    else if (self.wheelDegree > 359.5) {
        self.wheelDegree -= 360;
    }
    CGAffineTransform wheelTransform = self.wheel.transform;
    CGAffineTransform newWheelTransform = CGAffineTransformRotate(wheelTransform, angle);
    [self.wheel setTransform:newWheelTransform];
    [self setMoodIntensity];
}



- (void)setMoodIntensity {
    NSNumber *moodIntensity = [[NSNumber alloc] initWithInt:self.wheelDegree/72 + 1];
    [[self.chosenMoods lastObject] setValue:moodIntensity forKey:@"moodIntensity"];
    NSLog(@"%@", [self.chosenMoods lastObject]);
    
}



//차후 휠 제스쳐 끝날 때 실행해야하는 메서드
- (IBAction)resetViews:(id)sender {
    self.wheel.image = [UIImage imageNamed:@"circle"];
    for(MDMoodButtonView *moodButton in self.moodButtons) {
        moodButton.hidden = NO;
    }
}

/*
- (void)showWheelView:(MMNewMoodButtonView *)selectedMood {
    //knob이미지 += wheel이미지.  wheel이미지 = circle이미지. CGRect좌표값으로 knob위치 설정하지 말고 돌리기.
    self.knob.hidden = NO;
    self.knob.image = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@_knob",selectedMood.name]];
    CGRect knobPos = selectedMood.frame;
    [self.knob setFrame:CGRectMake(knobPos.origin.x + self.knob.frame.size.width/2, knobPos.origin.y + self.knob.frame.size.height/2, self.knob.frame.size.width, self.knob.frame.size.height)];
    for(MMNewMoodButtonView *moodView in self.moodViews) {
        moodView.hidden = YES;
    }
    self.wheel.image = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@_wheel", selectedMood.name]];
}
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)saveNewMoodMon:(id)sender {
    
    //test data
    [self.dataManager saveNewMoodMonOfComment:@"test" asFirstChosen:11 SecondChosen:11 andThirdChosen:11];
    
    /*
     mood int 확인,
     MDDateManager saveNewMoodMonOfComment~ 메소드에서 하고 있습니다.
     여기서 하는 게 제일 좋은 건지는 아직 모르겠네요. 방어차 남겨 놓는 것도 좋은 것 같아요.
     
     그 전에, 위 메소드 부르기 전에도  mood int 체크 하는 게 좋을 것 같아요~
     newMoodmon view에서 mood int가 어떻게 정해지는 지, 어디에 그 데이터가 남는지 아직 모르겠지만, 해당 코드 완성되면, 이 부분 한번 정하면 좋을 것 같아요.
     */
    
    
    
//    [[self presentingViewController] dismissViewControllerAnimated:YES
//                                                        completion:^{
//                                                            [self.presentingViewController performSelector:@selector(presentCalendar)
//                                                                                                withObject:nil];
//                                                        }];
//    

    NSLog(@"no");
    UIViewController *calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"monthVC"];
    //[calendarVC setModalPresentationStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:calendarVC animated:YES completion:nil];

}

-(void) presentCalendar{
    
}
@end
