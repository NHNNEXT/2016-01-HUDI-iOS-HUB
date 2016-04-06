//
//  MMWheelView.m
//  MoodMon
//
//  Created by 김기범 on 2016. 4. 6..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import "MMWheelView.h"

@implementation MMWheelView

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)showWheelView:(MMNewMoodButtonView *)selectedMood {
    //knob이미지 += wheel이미지.  wheel이미지 = circle이미지. CGRect좌표값으로 knob위치 설정하지 말고 돌리기.
    self.hidden = NO;
    self.image = [UIImage imageNamed:[[NSString alloc]initWithFormat:@"%@_knob",selectedMood.name]];
    CGRect knobPos = selectedMood.frame;
    [self setFrame:CGRectMake(knobPos.origin.x + self.frame.size.width/2, knobPos.origin.y + self.frame.size.height/2, self.frame.size.width, self.frame.size.height)];
}

@end
