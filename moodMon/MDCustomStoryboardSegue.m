//
//  MDCustomStoryboardSegue.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 2..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDCustomStoryboardSegue.h"

@implementation MDCustomStoryboardSegue
- (void)perform {
    
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    [sourceViewController.view addSubview:destinationViewController.view];
    [destinationViewController.view setFrame:sourceViewController.view.window.frame];
    [destinationViewController.view setTransform:CGAffineTransformMakeScale(0.5,0.5)];
    [destinationViewController.view setAlpha:1.0];
    
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         [destinationViewController.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
                         [destinationViewController.view setAlpha:1.0];
                     }
                     completion:^(BOOL finished){
                         [destinationViewController.view removeFromSuperview];
                         [sourceViewController.navigationController pushViewController:destinationViewController animated:NO];
                     }];
}
@end
