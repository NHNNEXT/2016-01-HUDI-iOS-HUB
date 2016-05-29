//
//  MDSaveMoodFaceView.m
//  moodMon
//
//  Created by 김기범 on 2016. 5. 30..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDSaveMoodFaceView.h"

@implementation MDSaveMoodFaceView


- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self=[super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"MDSaveMoodFaceView" owner:self options:nil]objectAtIndex:0]];
    [self addSubview:_view];
    _view.frame = self.bounds;
}


- (void)awakeFromNib {
    [self setup];
    _chosenMoods = [[NSMutableArray alloc] initWithArray:@[@0]];
    _moodName = @[@"", @"angry", @"joy", @"sad", @"excited", @"tired"];
    _animationDuration = 0.4;
    self.layer.cornerRadius = self.frame.size.width/2;
    self.backgroundColor = [UIColor clearColor];
}


- (void)drawRect:(CGRect)rect {
    if(_chosenMoods.count == 1) {
        _wrinkle.image = nil;
        _eyebrow.image = nil;
        _eye.image = nil;
        _darkCircle.image = nil;
        _cheek.image = nil;
        _tear.image = nil;
        _mouth.image = nil;
    }
    if(_chosenMoods.count >= 2) {
        [self setMainFace:_chosenMoods[1]];
    }
    if(_chosenMoods.count >= 3) {
        [self setSubFace:_chosenMoods[2]];
    }
    if(_chosenMoods.count >= 4) {
        [self setSubFace:_chosenMoods[3]];
    }
}


- (void)setMainFace:(NSNumber *)num {
    int moodClass = num.intValue/10;        // 1=angry, 2=joy, 3=sad, 4=excited, 5=tired
    int intensity = num.intValue%10 + 1;   // 1 ~ 5
    if(moodClass == 4) {
        _hasExcited = YES;
    }
    
    [self setWrinkleImageWithMoodClass:moodClass Intensity:intensity];
    [self setEyebrowImageWithMoodClass:moodClass Intensity:intensity];
    [self setEyeImageWithMoodClass:moodClass Intensity:intensity];
    [self setDarkCircleImageWithMoodClass:moodClass Intensity:intensity];
    [self setCheekImageWithMoodClass:moodClass Intensity:intensity];
    [self setTearImageWithMoodClass:moodClass Intensity:intensity];
    [self setMouthImageWithMoodClass:moodClass Intensity:intensity];
}



- (void)setSubFace:(NSNumber *)num {
    int moodClass = num.intValue/10;    // 1=angry, 2=joy, 3=sad, 4=excited, 5=tired
    int intensity = num.intValue%10 + 1;   // 1 ~ 5
    
    switch (moodClass) {
        case 1:
            [self setWrinkleImageWithMoodClass:moodClass Intensity:intensity];
            (_hasExcited)?:[self setEyebrowImageWithMoodClass:moodClass Intensity:intensity];
            // 선택한 감정에 excited가 있는 경우 눈썹을 그리지 말아야 함.
            break;
        case 2:
            [self setMouthImageWithMoodClass:moodClass Intensity:intensity];
            break;
        case 3:
            [self setTearImageWithMoodClass:moodClass Intensity:intensity];
            break;
        case 4:
            [self setEyeImageWithMoodClass:moodClass Intensity:intensity];
            [self setEyebrowImageWithMoodClass:moodClass Intensity:intensity];
            _hasExcited = YES;
            break;
        case 5:
            [self setDarkCircleImageWithMoodClass:moodClass Intensity:intensity];
            break;
        default:
            break;
    }
}



- (void)setWrinkleImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"wrinkle_degree%d", intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _wrinkle.image = (moodClass==1) ? [UIImage imageNamed:imageName] : nil;
                    }
                    completion:nil];
}


- (void)setEyebrowImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"%@_eyebrow_degree%d", _moodName[moodClass], intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        if(moodClass==1 || moodClass==3 || moodClass==5) {
                            _eyebrow.image = [UIImage imageNamed:imageName];
                            return;
                        }
                        _eyebrow.image = nil;
                    }
                    completion:nil];
}


- (void)setEyeImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName;
    if(moodClass==4){
        imageName = [NSString stringWithFormat:@"excited_eye_degree%d", intensity];
    }
    else {
        imageName = [NSString stringWithFormat:@"%@_eye", (moodClass==1)?@"angry":@"default"];
    }
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _eye.image = [UIImage imageNamed:imageName];
                    }
                    completion:nil];
}


- (void)setDarkCircleImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"darkcircle_degree%d", intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _darkCircle.image = (moodClass==5) ? [UIImage imageNamed:imageName] : nil;
                    }
                    completion:nil];
}


- (void)setCheekImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"cheek_degree%d", intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _cheek.image = [UIImage imageNamed:imageName];
                    }
                    completion:nil];
}


- (void)setTearImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"tear_degree%d", intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _tear.image = (moodClass==3) ? [UIImage imageNamed:imageName] : nil;
                    }
                    completion:nil];
}


- (void)setMouthImageWithMoodClass:(int)moodClass Intensity:(int)intensity {
    NSString *imageName = [NSString stringWithFormat:@"%@_mouth_degree%d", _moodName[moodClass], intensity];
    [UIView transitionWithView:self
                      duration:_animationDuration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _mouth.image = [UIImage imageNamed:imageName];
                    }
                    completion:nil];
}



@end
