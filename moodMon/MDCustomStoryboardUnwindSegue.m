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
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    // Add view to super view temporarily
    [sourceViewController.view.superview insertSubview:destinationViewController.view atIndex:0];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         // Shrink!
                         sourceViewController.view.transform = CGAffineTransformMakeScale(0.05, 0.05);
                     }
                     completion:^(BOOL finished){
//                         [sourceViewController dismissViewControllerAnimated:NO completion:^{}]; // dismiss VC
//                         [sourceViewController dismissViewControllerAnimated:NO completion:nil];
                         [[self destinationViewController] dismissViewControllerAnimated:NO completion:nil];
                         [sourceViewController.view removeFromSuperview]; // remove from temp super view
//                         [presentViewController:destinationViewController animated:NO completion:^{}];
                     }];
    
    
    
//    UIView *sourceView = ((UIViewController *)self.sourceViewController).view;
//    UIView *destinationView = ((UIViewController *)self.destinationViewController).view;
//    
//    
//    
//    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
//    destinationView.center = CGPointMake(sourceView.center.x,  sourceView.center.y + destinationView.center.y);
//    [window insertSubview:destinationView belowSubview:sourceView];
//    
//    [UIView animateWithDuration:0.4
//                     animations:^{
//                         
//                         
//                         destinationView.center = CGPointMake(sourceView.center.x, sourceView.center.y);
//                         sourceView.center = CGPointMake(sourceView.center.x, 0 - 2*destinationView.center.y);
//                     }
//                     completion:^(BOOL finished){
//                         
//                         [[self destinationViewController] dismissViewControllerAnimated:NO completion:nil];
//                     }];
}
@end