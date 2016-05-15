//
//  MDTouchDownGestureRecognizer.h
//  moodMon
//
//  Created by 김기범 on 2016. 5. 15..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITouch.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface MDTouchDownGestureRecognizer : UIGestureRecognizer

@property SEL action;

@end
