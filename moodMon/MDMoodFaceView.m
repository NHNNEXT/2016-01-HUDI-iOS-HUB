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
    self.layer.cornerRadius = 64;
    self.layer.masksToBounds = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
