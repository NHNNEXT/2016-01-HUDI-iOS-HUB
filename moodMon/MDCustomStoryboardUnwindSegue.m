//
//  MDCustomStoryboardUnwindSegue.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 10..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDCustomStoryboardUnwindSegue.h"

@implementation MDCustomStoryboardUnwindSegue
- (void)perform {
    UIViewController *sourceViewController = self.sourceViewController;
    UIViewController *destinationViewController = self.destinationViewController;
    
    // Add view to super view temporarily
    [sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Shrink!
                         sourceViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
                     }
                     completion:^(BOOL finished){
                         [sourceViewController.view removeFromSuperview]; // remove from temp super view
                         [destinationViewController dismissViewControllerAnimated:NO completion:NULL]; // dismiss VC
                     }];
}
@end
