//
//  MDMonthTimeLineCellTableViewCell.m
//  moodMon
//
//  Created by 이재성 on 2016. 4. 15..
//  Copyright © 2016년 Lee Kyu-Won. All rights reserved.
//

#import "MDMonthTimeLineCellTableViewCell.h"

static CGFloat const kBounceValue = 40.0f;

@implementation MDMonthTimeLineCellTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.isFiltered = NO;
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
    self.panRecognizer.delegate = self;
    [self.myContentView addGestureRecognizer:self.panRecognizer];
//    self.commentLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    self.commentLabel.numberOfLines = 0;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing
{
    if (self.startingRightLayoutConstraintConstant == 0 &&
        self.contentViewRightConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    self.contentViewRightConstraint.constant = -kBounceValue;
    self.contentViewLeftConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self.contentViewRightConstraint.constant = 0;
        self.contentViewLeftConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate
{
    //1
    if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
        self.contentViewRightConstraint.constant == [self buttonTotalWidth]) {
        return;
    }
    //2
    self.contentViewLeftConstraint.constant = -[self buttonTotalWidth] - kBounceValue;
    self.contentViewRightConstraint.constant = [self buttonTotalWidth] + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        //3
        self.contentViewLeftConstraint.constant = -[self buttonTotalWidth];
        self.contentViewRightConstraint.constant = [self buttonTotalWidth];
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            //4
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
        }];
    }];
}

- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:self.myContentView];
            self.startingRightLayoutConstraintConstant = self.contentViewRightConstraint.constant;
            //NSLog(@"Pan Began at %@", NSStringFromCGPoint(self.panStartPoint));
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:self.myContentView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {  //1
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) { //2
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0); //3
                    if (constant == 0) { //4
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //5
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]); //6
                    if (constant == [self buttonTotalWidth]) { //7
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //8
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            //NSLog(@"Pan Moved %f", deltaX);
            } else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX; //1
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0); //2
                    if (constant == 0) { //3
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else { //4
                        self.contentViewRightConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, [self buttonTotalWidth]); //5
                    if (constant == [self buttonTotalWidth]) { //6
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else { //7
                        self.contentViewRightConstraint.constant = constant;
                    }
                }
            }
            
            self.contentViewLeftConstraint.constant = -self.contentViewRightConstraint.constant; //8
            
        }
            break;
            
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) { //1
                //Cell was opening
                CGFloat halfOfButtonOne = CGRectGetWidth(self.saveMoodmonBtn.frame) / 2; //2
                if (self.contentViewRightConstraint.constant >= halfOfButtonOne) { //3
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                CGFloat buttonOnePlusHalfOfButton2 =  (CGRectGetWidth(self.saveMoodmonBtn.frame) / 2); //4 //CGRectGetWidth(self.editBtn.frame) +
                if (self.contentViewRightConstraint.constant >= buttonOnePlusHalfOfButton2) { //5
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
            
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;

            
        default:
            break;
    }

}

- (CGFloat)buttonTotalWidth {
    
    return CGRectGetWidth(self.frame) -CGRectGetMinX(self.saveMoodmonBtn.frame) + 10;
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.1;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}


- (IBAction)buttonClicked:(id)sender {
//    if (sender == self.editBtn) {
//        
//        [self.delegate buttonOneActionForItemText:self.itemText];
//        
//    } else
    if (sender == self.saveMoodmonBtn) {
//        MDMoodColorView *saveMCView = [[MDMoodColorView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
//        saveMCView.bounds = saveMCView.frame;
//        saveMCView.chosenMoods = [self.MCView.chosenMoods copy];
//        [saveMCView setNeedsDisplay];
//        [self.delegate buttonTwoActionForItemText:saveMCView];
        MDMoodColorView *colorView = (MDMoodColorView *)[self viewWithTag:100].subviews[0];
        [self.delegate buttonTwoActionForItemText:colorView];
    } else {
        NSLog(@"Clicked unknown button!");
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
