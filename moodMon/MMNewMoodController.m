//
//  MMNewMoodController.m
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 27..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import "MMNewMoodController.h"

@interface MMNewMoodController ()

@end

@implementation MMNewMoodController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.moodmonDM = [MDDataManager sharedDataManager];
    [self.moodmonDM createDB];

    
    [self initializeMoods];
    self.moodCount = 0;
    self.moodViews = @[self.angry, self.joy, self.sad, self.excited, self.tired];
    [self addTapGestureRecognizer];
}


-(void)initializeMoods {
    self.angry.name = @"angry";
    self.joy.name = @"joy";
    self.sad.name = @"sad";
    self.excited.name = @"excited";
    self.tired.name = @"tired";
}

- (void)addTapGestureRecognizer {
    for(UIImageView *emotion in self.moodViews){
        emotion.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapped:)];
        [emotion addGestureRecognizer:tap];
    }
}

- (void)tapped:(UIGestureRecognizer *)tap {
    MMNewMoodButtonView *imageView = (MMNewMoodButtonView *)tap.view;
    NSString *imageName = imageView.name;
    NSString *isSelected = (imageView.isSelected)? @"unselect" : @"selected";
    //moodCount가 3보다 큰 경우 (selected) 이미지는 그리지 말아야. 그냥 이미지 안 그리면 됨.
    imageView.image = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@_%@", imageName, isSelected]];
    imageView.isSelected = (imageView.isSelected)? NO : YES;
    (imageView.isSelected)? self.moodCount++ : self.moodCount--;
    for(MMNewMoodButtonView *moodView in self.moodViews) {
        moodView.hidden = YES;
    }
    [self.wheel showWheelView:imageView];
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
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveNewMoodMon:(id)sender {
    
    //test data
    [self.moodmonDM saveNewMoodMonOfComment:@"test" asFirstChosen:11 SecondChosen:11 andThirdChosen:11];
    
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
