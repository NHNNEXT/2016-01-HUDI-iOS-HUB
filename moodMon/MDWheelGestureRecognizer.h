//
//  MDWheelGestureRecognizer.h
//  moodMon
//
//  Created by Kibeom Kim on 2016. 4. 10..
//  Copyright © 2016년 Kibeom Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITouch.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol MDWheelGestureRecognizerDelegate <UIGestureRecognizerDelegate>
@end


@interface MDWheelGestureRecognizer : UIGestureRecognizer

@property SEL wheelAction;
@property SEL touchUpAction;
@property CGFloat currentAngle;
@property CGFloat previousAngle;
@property UITouch *touch;

- (id)initWithTarget:(id)target wheelAction:(SEL)action touchUpAction:(SEL)action2;

@end
