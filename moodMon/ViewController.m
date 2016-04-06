//
//  ViewController.m
//  moodMon
//
//  Created by Lee Kyu-Won on 3/30/16.
//  Copyright © 2016 Lee Kyu-Won. All rights reserved.
//

#import "ViewController.h"
#import "MDDataManager.h"
#import "MDMoodmon.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MDDataManager *test = [[MDDataManager alloc] init];
    [test createDB];
    [test readAllFromDBAndSetCollection];
    NSLog(@"%lu", (unsigned long)[test recentMood]);
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end