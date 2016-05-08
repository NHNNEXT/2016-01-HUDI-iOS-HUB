//
//  MDMoodFaceView.m
//  moodMon
//
//  Created by 김기범 on 2016. 5. 8..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDMoodFaceView.h"

@implementation MDMoodFaceView

- (void)awakeFromNib {
    _chosenMoods = [[NSMutableArray alloc] initWithArray:@[@0]];
    _moodName = @[@"", @"angry", @"joy", @"sad", @"excited", @"tired"];
}


- (void)drawRect:(CGRect)rect {
    if([_chosenMoods count]>1) {
        [self setMainFace:_chosenMoods[1]];
    }
}


- (void)setMainFace:(NSNumber *)num {
    
    int moodClass = num.intValue/10;    // 1=angry, 2=joy, 3=sad, 4=excited, 5=tired
    int moodDegree = num.intValue%10 + 1;   // 1 ~ 5
    [self setWrinkleImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setEyebrowImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setEyeImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setDarkCircleImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setCheekImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setTearImageWithMoodClass:moodClass MoodDegree:moodDegree];
    [self setMouthImageWithMoodClass:moodClass MoodDegree:moodDegree];
//    @property (strong, nonatomic) IBOutlet UIImageView *eyebrow;
//    @property (strong, nonatomic) IBOutlet UIImageView *eye;
//    @property (strong, nonatomic) IBOutlet UIImageView *darkCircle;
//    @property (strong, nonatomic) IBOutlet UIImageView *cheek;
//    @property (strong, nonatomic) IBOutlet UIImageView *tear;
//    @property (strong, nonatomic) IBOutlet UIImageView *mouth;
}


- (void)setWrinkleImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"wrinkle_degree%d", moodDegree];
    _wrinkle.image = (moodClass==1) ? [UIImage imageNamed:imageName] : nil;
}


- (void)setEyebrowImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"%@_eyebrow_degree%d", _moodName[moodClass], moodDegree];
    if(moodClass==1 || moodClass==3 || moodClass==5) {
        _eyebrow.image = [UIImage imageNamed:imageName];
        return;
    }
    _eyebrow.image = nil;
}


- (void)setEyeImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName;
    if(moodClass==4){
        imageName = [NSString stringWithFormat:@"excited_eye_degree%d", moodDegree];
    }
    else {
        imageName = [NSString stringWithFormat:@"%@_eye", (moodClass==1)?@"angry":@"default"];
    }
    _eye.image = [UIImage imageNamed:imageName];
}


- (void)setDarkCircleImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"darkcircle_degree%d", moodDegree];
    _darkCircle.image = (moodClass==5) ? [UIImage imageNamed:imageName] : nil;
}


- (void)setCheekImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"cheek_degree%d", moodDegree];
    _cheek.image = [UIImage imageNamed:imageName];
}


- (void)setTearImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"tear_degree%d", moodDegree];
    _tear.image = (moodClass==3) ? [UIImage imageNamed:imageName] : nil;
}


- (void)setMouthImageWithMoodClass:(int)moodClass MoodDegree:(int)moodDegree {
    NSString *imageName = [NSString stringWithFormat:@"%@_mouth_degree%d", _moodName[moodClass], moodDegree];
    _mouth.image = [UIImage imageNamed:imageName];
}



@end
