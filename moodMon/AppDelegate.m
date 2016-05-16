//
//  AppDelegate.m
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "AppDelegate.h"
#import "MDDataManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIStoryboard *launchBoard = [UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil];
    UIView* overlayView = [[launchBoard instantiateViewControllerWithIdentifier:@"LaunchVC"] view]  ;
    overlayView.frame = self.window.rootViewController.view.bounds;
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    UIStoryboard *storyboard = self.window.rootViewController.storyboard;
    
    MDDataManager *dm = [MDDataManager sharedDataManager];
    [dm createDB];
    
    UIViewController *newMoodmonVC = [storyboard instantiateViewControllerWithIdentifier:@"newMoodmonVC"];
    [newMoodmonVC setModalPresentationStyle: UIModalPresentationCurrentContext];
    [self.window makeKeyAndVisible];
    [self.window addSubview:overlayView];
    [self.window.rootViewController presentViewController:newMoodmonVC animated:NO completion:^{
//        NSLog(@"displaying (AppDelegate)");
        [UIView animateWithDuration:0.5 animations:^{
            overlayView.alpha = 0;
        } completion:^(BOOL finished) {
            [overlayView removeFromSuperview];
        }];
    }];
    
//
//    UIViewController *top = [UIApplication sharedApplication].keyWindow.rootViewController;
//    while(top.presentedViewController)
//    {
//        top = top.presentedViewController;
//    }
//    UIViewController *newMoodmonVC = [storyboard instantiateViewControllerWithIdentifier:@"newMoodmonVC"];
//    [top presentViewController:newMoodmonVC animated:YES completion: nil];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
