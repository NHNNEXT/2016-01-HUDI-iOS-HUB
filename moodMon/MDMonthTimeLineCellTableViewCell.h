//
//  MDMonthTimeLineCellTableViewCell.h
//  moodMon
//
//  Created by 이재성 on 2016. 4. 15..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDMoodColorView.h"
//#import "MDMonthViewController.h"

@protocol SwipeableCellDelegate <NSObject>
- (void)buttonOneActionForItemText:(NSString *)itemText;
- (void)buttonTwoActionForItemText:(MDMoodColorView *)itemText;
@end

@interface MDMonthTimeLineCellTableViewCell : UITableViewCell <UIGestureRecognizerDelegate>

@property BOOL isFiltered;
@property (nonatomic, weak) id <SwipeableCellDelegate> delegate;
@property (nonatomic, weak) NSString *itemText;

@property MDMoodColorView *MCView;
//@property (nonatomic, weak)IBOutlet UIButton *editBtn;
@property (nonatomic, weak)IBOutlet UIButton *saveMoodmonBtn;
@property (nonatomic, weak)IBOutlet UIView *myContentView;

@property (strong, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewRightConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewLeftConstraint;

- (CGFloat)buttonTotalWidth;

@end
