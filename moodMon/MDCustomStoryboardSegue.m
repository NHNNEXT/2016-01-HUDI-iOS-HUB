//
//  MDCustomStoryboardSegue.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 2..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDCustomStoryboardSegue.h"
#import "MDNavController.h"
@implementation MDCustomStoryboardSegue
- (void)perform {
    
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    [sourceViewController.view addSubview:destinationViewController.view];
    [destinationViewController.view setFrame:sourceViewController.view.window.frame];
    [destinationViewController.view setTransform:CGAffineTransformMakeScale(0.5,0.5)];
    [destinationViewController.view setAlpha:1.0];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [destinationViewController.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                         [destinationViewController.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [sourceViewController presentViewController:destinationViewController animated:NO completion:nil];
                     }];
    
}
@end
