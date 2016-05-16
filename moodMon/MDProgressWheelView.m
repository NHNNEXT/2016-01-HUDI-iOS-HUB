//
//  MDProgressWheelView.m
//  moodMon
//
//  Created by 김기범 on 2016. 5. 16..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDProgressWheelView.h"

@implementation MDProgressWheelView
- (void)awakeFromNib {
    [self colorsInit];
    _bezierPath = [UIBezierPath bezierPath];
}


- (void)colorsInit {
    self.colors = @[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:1], [UIColor colorWithRed:.96 green:.76 blue:.26 alpha:1], [UIColor colorWithRed:0.30 green:0.47 blue:0.86 alpha:1], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:1], [UIColor colorWithRed:.80 green:.60 blue:.97 alpha:1]];
}


- (void)drawRect:(CGRect)rect {
    [_bezierPath removeAllPoints];
    [_bezierPath addArcWithCenter:CGPointMake(rect.size.width/2, rect.size.height/2)
                          radius:113
                      startAngle:_startAngle - M_PI_2
                        endAngle:_endAngle - M_PI_2
                       clockwise:YES];
    _bezierPath.lineWidth = 14;
    _bezierPath.lineCapStyle = kCGLineCapRound;
    [_colors[_currentMoodNum] setStroke];
    [_bezierPath stroke];
}

- (void)erasePath {
    _currentMoodNum = 0;
    [self setNeedsDisplay];
}

@end
