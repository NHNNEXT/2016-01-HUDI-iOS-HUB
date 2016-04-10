//
//  MDNewMoodController.m
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 27..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import "MDNewMoodController.h"

@interface MDNewMoodController ()

@end

@implementation MDNewMoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataManager = [MDDataManager sharedDataManager];
    [self.dataManager createDB];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"failTosaveIntoSql" object:self.dataManager ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlert:) name:@"moodNotChosen" object:self.dataManager ];
    
    self.moodCount = 0;
    self.moodButtons = @[self.angry, self.joy, self.sad, self.excited, self.tired];
    self.centerMood.hidden = YES;
    [self initiateMoodButtonsName];
    [self addTapGestureRecognizer];
}


-(void) showAlert:(NSNotification*)notification{
    NSDictionary *userInfo = [notification userInfo];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:[userInfo objectForKey:@"message"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:defaultAction];
    [self presentViewController:alertC animated:YES completion:nil];
}


-(void)initiateMoodButtonsName {
    self.angry.name = @"angry";
    self.joy.name = @"joy";
    self.sad.name = @"sad";
    self.excited.name = @"excited";
    self.tired.name = @"tired";
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
    MDMoodButtonView *imageView = (MDMoodButtonView *)tap.view;
    [self setMoodButtonImage:imageView];
    self.centerMood.hidden = (self.moodCount<1)? YES:NO;
    if(imageView.isSelected && self.moodCount<4) {
        [self showWheelView:imageView.name];
    }
}

- (void)showWheelView:(NSString *)wheelName {
    self.wheel.image = [UIImage imageNamed:[[NSString alloc] initWithFormat:@"%@_wheel", wheelName]];
    for(MDMoodButtonView *moodButton in self.moodButtons) {
        moodButton.hidden = YES;
    }
}

- (void)setMoodButtonImage:(MDMoodButtonView *)imageView {
    imageView.isSelected = !imageView.isSelected;
    imageView.isSelected ? self.moodCount++ : self.moodCount--;
    NSString *surfix = (imageView.isSelected && self.moodCount<4) ? @"selected" : @"unselect";
    NSString *imageName = [[NSString alloc]initWithFormat:@"%@_%@", imageView.name, surfix];
    imageView.image = [UIImage imageNamed:imageName];
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
    UIViewController *calendarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"yearVC"];
    //[calendarVC setModalPresentationStyle: UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:calendarVC animated:YES completion:nil];

}

-(void) presentCalendar{
    
}
@end
