//
//  MDNewMoodButtonView.m
//  MoodMon
//
//  Created by 김기범 on 2016. 3. 28..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import "MDNewMoodButtonView.h"

@implementation MDNewMoodButtonView

@synthesize num, name, isSelected;

- (void)awakeFromNib {
    self.isSelected = NO;
}

@end
