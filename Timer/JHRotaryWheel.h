//
//  JHRotaryWheel.h
//  Timer
//
//  Created by Jonathan Hirz on 3/19/12.
//  Copyright (c) 2012 SuaveApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHRotaryWheelProtocol.h"

@interface JHRotaryWheel : UIControl {
    UILabel *timerDisplay;
    NSTimer *stopWatchTimer;
    NSDate *currentDate;
    NSDateFormatter *dateFormatter;

}

@property (weak) id <JHRotaryWheelProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property CGAffineTransform startTransform;
@property (nonatomic, retain) UILabel* timerDisplay;
@property (nonatomic, retain) UIButton* startButton;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del;

@end
