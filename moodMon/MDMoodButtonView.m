//
//  MDMoodButtonView.m
//  MoodMon
//
//  Created by Kibeom Kim on 2016. 3. 28..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "MDMoodButtonView.h"

@implementation MDMoodButtonView

@synthesize num, name, isSelected;

- (void)awakeFromNib {
    self.isSelected = NO;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}


@end
