//
//  MDMoodColorView.m
//  moodMon
//
//  Created by 김기범 on 2016. 4. 25..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDMoodColorView.h"

@interface MDMoodColorView ()
@property NSArray *colors;
@end

@implementation MDMoodColorView

- (void)awakeFromNib {
    _chosenMoods = [[NSMutableArray alloc] initWithObjects:@0, nil];
    self.colors = @[[UIColor colorWithRed:1 green:1 blue:1 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:0], [UIColor colorWithRed:.96 green:.76 blue:.26 alpha:0], [UIColor colorWithRed:0.30 green:0.47 blue:0.76 alpha:0], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:0], [UIColor colorWithRed:.70 green:.60 blue:.87 alpha:0]];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = [self gradient];
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(self.bounds), CGRectGetMaxY(self.bounds));
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

- (CGGradientRef)gradient {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations1[2] = {0.0, 1.0};
    CGFloat locations2[3] = {0.0, 0.5, 1.0};
    
    UIColor *baseColor = _colors[[_chosenMoods[0] intValue]/10];

    if(_chosenMoods.count == 1) {
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)baseColor.CGColor, (id)baseColor.CGColor, nil];
        return CGGradientCreateWithColors(colorSpace, colors, locations1);
    }
    else if(_chosenMoods.count == 2) {
        UIColor *color1 = _colors[[_chosenMoods[1] intValue]/10];
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)baseColor.CGColor, (id)color1.CGColor, nil];
        return CGGradientCreateWithColors(colorSpace, colors, locations1);
    }
    else if(_chosenMoods.count == 3) {
        UIColor *color1 = _colors[[_chosenMoods[1] intValue]/10];
        UIColor *color2 = _colors[[_chosenMoods[2] intValue]/10];
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, nil];
        return CGGradientCreateWithColors(colorSpace, colors, locations1);
    }
    else {
        UIColor *color1 = _colors[[_chosenMoods[1] intValue]/10];
        UIColor *color2 = _colors[[_chosenMoods[2] intValue]/10];
        UIColor *color3 = _colors[[_chosenMoods[3] intValue]/10];
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, (id)color3.CGColor, nil];
        return CGGradientCreateWithColors(colorSpace, colors, locations2);
    }
}


@end
