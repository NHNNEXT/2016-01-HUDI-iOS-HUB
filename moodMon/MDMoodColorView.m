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
-(instancetype)init{
    self = [super init];
    if(self){
        _chosenMoods = [[NSMutableArray alloc] initWithArray:@[@0]];
        self.colors = @[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:1], [UIColor colorWithRed:.96 green:.76 blue:.26 alpha:1], [UIColor colorWithRed:0.30 green:0.47 blue:0.86 alpha:1], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:1], [UIColor colorWithRed:.80 green:.60 blue:.97 alpha:1]];
        
    }
    return self;
}

- (void)awakeFromNib {
    _chosenMoods = [[NSMutableArray alloc] initWithArray:@[@0]];
    self.colors = @[[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1], [UIColor colorWithRed:.91 green:.33 blue:.29 alpha:1], [UIColor colorWithRed:.99 green:.75 blue:.0 alpha:1], [UIColor colorWithRed:0.30 green:0.47 blue:0.86 alpha:1], [UIColor colorWithRed:.28 green:.82 blue:.71 alpha:1], [UIColor colorWithRed:.80 green:.60 blue:.97 alpha:1]];
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
    CGFloat locations1[2] = {0.3, 0.7};
    CGFloat locations2[4] = {0.2, 0.50, 0.50, 0.8};
    
    UIColor *baseColor = _colors[[_chosenMoods[0] intValue]/10];

    if(_chosenMoods.count == 1) {
        CFArrayRef colors = (__bridge CFArrayRef)([NSArray arrayWithObjects:(id)baseColor.CGColor, (id)baseColor.CGColor, nil]);
        return CGGradientCreateWithColors(colorSpace, colors, locations1);
    }
    else if(_chosenMoods.count == 2) {
        UIColor *color1 = _colors[[_chosenMoods[1] intValue]/10];
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)color1.CGColor, (id)color1.CGColor, nil];
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
        color1 = [color1 colorWithAlphaComponent:0.8];
        UIColor *color2 = _colors[[_chosenMoods[2] intValue]/10];
        color2 = [color2 colorWithAlphaComponent:0.75];
        UIColor *color3 = _colors[[_chosenMoods[3] intValue]/10];
        color3 = [color3 colorWithAlphaComponent:0.8];
        CFArrayRef colors = (__bridge CFArrayRef)[NSArray arrayWithObjects:(id)color1.CGColor, (id)color2.CGColor, (id)color2.CGColor, (id)color3.CGColor, nil];
        return CGGradientCreateWithColors(colorSpace, colors, locations2);
    }
}


@end
