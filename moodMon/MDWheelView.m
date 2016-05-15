//
//  MDWheelView.m
//  MoodMon
//
//  Created by 김기범 on 2016. 4. 6..
//  Copyright © 2016년 김기범. All rights reserved.
//

#import "MDWheelView.h"

@implementation MDWheelView

- (void)awakeFromNib {
    [self colorsInit];
}


- (void)colorsInit {
    self.colors = @[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:1], [UIColor colorWithRed:.96 green:.76 blue:.26 alpha:1], [UIColor colorWithRed:0.30 green:0.47 blue:0.86 alpha:1], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:1], [UIColor colorWithRed:.80 green:.60 blue:.97 alpha:1]];
}


- (void)drawRect:(CGRect)rect {
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                          radius:rect.size.width/2
                      startAngle:_startAngle
                        endAngle:_endAngle
                       clockwise:YES];
    
    bezierPath.lineWidth = 20;
    [_colors[_currentMoodNum] setStroke];
    [bezierPath stroke];
}


@end
