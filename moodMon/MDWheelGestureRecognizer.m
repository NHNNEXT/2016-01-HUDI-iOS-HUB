//
//  MDWheelGestureRecognizer.m
//  moodMon
//
//  Created by Kibeom Kim on 2016. 4. 10..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import "MDWheelGestureRecognizer.h"

@implementation MDWheelGestureRecognizer

- (id)initWithTarget:(id)target wheelAction:(SEL)action touchUpAction:(SEL)action2 {
    if(self=[super initWithTarget:target action:action]) {
        self.delegate = target;
        self.wheelAction = action;
        self.touchUpAction = action2;
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count > 1){
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    self.touch = [touches anyObject];
    
    self.currentAngle = [self getTouchAngle:[self.touch locationInView:self.touch.view.superview]];
    self.previousAngle = [self getTouchAngle:[self.touch previousLocationInView:self.touch.view.superview]];
    
    if([self.delegate respondsToSelector:self.wheelAction]) {
        [self.delegate performSelector:self.wheelAction withObject:self];
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    if([self.delegate respondsToSelector:self.touchUpAction]) {
        [self.delegate performSelector:self.touchUpAction withObject:self];
    }
}


- (float)getTouchAngle:(CGPoint)touch {
    // Wheel View의 가운데를 원점으로 하는 좌표로 변환
    float x = touch.x - 150;
    float y = -(touch.y - 150);
    
    // 0으로 나누지 않기 위한 조치
    if (y == 0) {
        if (x > 0) {
            return M_PI_2;
        }
        return 3 * M_PI_2;
    }
    
    float arctan = atanf(x/y);
    // 1사분면에 있을 때
    if((x>=0) && (y>0)) {
        return arctan;
    }
    // 2사분면에 있을 때
    else if ((x<0) && (y>0)) {
        return arctan + 2 * M_PI;
    }
    // 3사분면에 있을 때
    else if ((x<=0) && (y<0)) {
        return arctan + M_PI;
    }
    // 4사분면에 있을 때
    else if ((x>0) && (y<0)) {
        return arctan + M_PI;
    }
    return -1;
}

@end
