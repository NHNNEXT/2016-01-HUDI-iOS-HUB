//
//  MDMakeMoodMonView.h
//  moodMon
//
//  Created by 이재성 on 2016. 5. 9..
//  Copyright © 2016년 HUB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDDataManager.h"
#import "MDMoodColorView.h"
@interface MDMakeMoodMonView : UIView

-(UIImage*)makeMoodMon:(NSDictionary*)moodmonConf view:(MDMoodColorView*)view;
@end
