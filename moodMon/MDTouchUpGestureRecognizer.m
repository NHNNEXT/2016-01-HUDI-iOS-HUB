//
//  MDTouchUpGestureRecognizer.m
//  moodMon
//
//  Created by 김기범 on 2016. 5. 16..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDTouchUpGestureRecognizer.h"

@implementation MDTouchUpGestureRecognizer

- (id)initWithTarget:(id)target action:(SEL)action {
    if(self = [super initWithTarget:target action:action]) {
        self.delegate = target;
        self.action = action;
    }
    return self;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if(touches.count > 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
    if([self.delegate respondsToSelector:_action]) {
        [self.delegate performSelector:_action withObject:self];
    }
}

@end
