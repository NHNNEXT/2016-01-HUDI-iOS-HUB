//
//  MDNavController.m
//  moodMon
//
//  Created by 이재성 on 2016. 5. 17..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import "MDNavController.h"
#import "MDCustomStoryboardUnwindSegue.h"

@implementation MDNavController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    [self.navigationBar setTintColor:[UIColor colorWithRed:143.0f/255.0f green:126.0f/255.0f blue:123.0f/255.0f alpha:1.0f]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Quicksand" size:15]}];
    
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"Quicksand" size:15]}
     forState:UIControlStateNormal];
    
    
//    [self.navigationController.navigationItem.leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Quicksand" size:12]} forState:UIControlStateNormal];
//    [self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Quicksand" size:12]} forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStoryboardSegue *)segueForUnwindingToViewController:(UIViewController *)toViewController fromViewController:(UIViewController *)fromViewController identifier:(NSString *)identifier
{
    
    //how to set identifier for an unwind segue:
    
    //1. in storyboard -> documento outline -> select your unwind segue
    //2. then choose attribute inspector and insert the identifier name
    if ([@"JSUnwindView" isEqualToString:identifier]) {
        return [[MDCustomStoryboardUnwindSegue alloc] initWithIdentifier:identifier source:fromViewController destination:toViewController];
    }else {
        //if you want to use simple unwind segue on the same or on other ViewController this code is very important to mix custom and not custom segue
        return [super segueForUnwindingToViewController:toViewController fromViewController:fromViewController identifier:identifier];
    }
}

@end
