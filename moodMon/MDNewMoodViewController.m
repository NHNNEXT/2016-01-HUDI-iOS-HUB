//
//  MDNewMoodViewController.m
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 27..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "MDNewMoodViewController.h"

@interface MDNewMoodViewController () {
    float _bearing;
}
    
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
}



-(void)initiateMoodViews {
    self.moodCount = 0;
    self.centerMood.hidden = YES;
    
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
        [self setMoodButtonImage:moodButton];
    }
    self.centerMood.hidden = (self.moodCount<1)? YES:NO;
    if(moodButton.isSelected && self.moodCount<4) {
        [self showWheelView:moodButton];
    }
}



- (void)showWheelView:(MDMoodButtonView *)moodButton {
    self.wheel.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_wheel", moodButton.name]];
    self.wheel.transform = CGAffineTransformMakeRotation(moodButton.startingDegree);
    _bearing = moodButton.startingDegree;
    
    for(MDMoodButtonView *moodButton in self.moodButtons) {
        moodButton.hidden = YES;
    }
}



- (void)setMoodButtonImage:(MDMoodButtonView *)moodButton {
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
    if(_bearing < 0.01) {
        _bearing += M_PI;
    }
    else if (_bearing > 2*M_PI) {
        _bearing -= 360;
    }
    
    CGAffineTransform wheelTransform = self.wheel.transform;
    CGAffineTransform newWheelTransform = CGAffineTransformRotate(wheelTransform, angle);
    [self.wheel setTransform:newWheelTransform];
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
    
    /**********************************************************
     *                                                        *
     *                                                        *
     *  form형식이 완료되기 전까지, 테스트 데이터는 여기서 넣으면 됩니다.    *
     *                                                        *
     *                                                        *
     * ********************************************************
     */
    //test data
    
    [self.dataManager saveNewMoodMonOfComment:@"test" asFirstChosen:11 SecondChosen:24 andThirdChosen:31];
    [self.dataManager saveNewMoodMonOfComment:@"test2" asFirstChosen:12 SecondChosen:33 andThirdChosen:45];
    [self.dataManager saveNewMoodMonOfComment:@"test3" asFirstChosen:13 SecondChosen:41 andThirdChosen:21];
    
    /*
     mood int 확인,
     MDDateManager saveNewMoodMonOfComment~ 메소드에서 하고 있습니다.
     여기서 하는 게 제일 좋은 건지는 아직 모르겠네요. 방어차 남겨 놓는 것도 좋은 것 같아요.
     
     그 전에, 위 메소드 부르기 전에도  mood int 체크 하는 게 좋을 것 같아요~
     newMoodmon view에서 mood int가 어떻게 정해지는 지, 어디에 그 데이터가 남는지 아직 모르겠지만, 해당 코드 완성되면, 이 부분 한번 정하면 좋을 것 같아요.
     */
    
   
    NSLog(@"Saving new Mood mon");
    

    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void) presentCalendar{
    
}
@end
