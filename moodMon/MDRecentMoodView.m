//
//  MDRecentMoodView.m
//  moodMon
//
//  Created by 김기범 on 2016. 4. 18..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDRecentMoodView.h"

@interface MDRecentMoodView()
@property NSArray<UIColor *> *colors;
@property float opacity;
@end


@implementation MDRecentMoodView

- (void)awakeFromNib {
    self.opacity = 0.25;
    self.colors = @[[UIColor colorWithRed:1 green:1 blue:1 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:self.opacity], [UIColor colorWithRed:.96 green:.76 blue:.26 alpha:self.opacity], [UIColor colorWithRed:0.30 green:0.47 blue:0.76 alpha:self.opacity], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:self.opacity], [UIColor colorWithRed:.70 green:.60 blue:.87 alpha:self.opacity]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = [self gradient];
    CGPoint startPoint = CGPointMake(CGRectGetMidX(self.bounds), 0.0);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

- (CGGradientRef)gradient {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[2] = {0.0, 1.0};
    
    UIColor *topColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
    UIColor *bottomColor = self.colors[self.recentMood/10];
    CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    
    return CGGradientCreateWithColors(colorSpace, colors, locations);
}

@end
