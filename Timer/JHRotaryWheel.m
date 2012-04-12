//
//  JHRotaryWheel.m
//  Timer
//
//  Created by Jonathan Hirz on 3/19/12.
//  Copyright (c) 2012 SuaveApps. All rights reserved.
//

#import "JHRotaryWheel.h"
#import <QuartzCore/QuartzCore.h>

@interface JHRotaryWheel()
- (void)drawWheel;
- (void)setupTimer;
- (void)drawTimerDisplay;
- (float)calculateDistanceFromCenter:(CGPoint)point;
@end

static float deltaAngle;
float timerDisplayAmount = 0;

// - conditions -
// is timer counting down? (don't spin wheel if timer is running)
BOOL countdownHasStarted = NO;

@implementation JHRotaryWheel

@synthesize delegate, container, startTransform, timerDisplay, startButton;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del {
    if ((self = [super initWithFrame:frame])) {
        self.delegate = del;
        [self drawWheel];
        [self drawTimerDisplay];
        [self drawStartButton];
        [self setupTimer];
    }
    return self;
}

#pragma mark - Drawing Things

- (void)drawWheel {
    container = [[UIView alloc] initWithFrame:self.frame];
    UIImage *wheel = [UIImage imageNamed:@"wheel.png"];
    UIImageView *wheelView = [[UIImageView alloc] initWithImage:wheel];
    wheelView.layer.anchorPoint = CGPointMake(0.5f, 0.5f);
    wheelView.layer.position = CGPointMake(container.bounds.size.width/2.0, container.bounds.size.height/2.0);
    [container addSubview:wheelView];
    container.userInteractionEnabled = NO;
    [self addSubview:container];
}

- (void)drawTimerDisplay {
    timerDisplay = [[UILabel alloc] initWithFrame:CGRectMake(0,10,320,75)];
    timerDisplay.textAlignment = UITextAlignmentCenter;
    timerDisplay.backgroundColor = [UIColor clearColor];
    timerDisplay.textColor = [UIColor blackColor];
    [timerDisplay setFont:[UIFont fontWithName:@"Helvetica-Bold" size:70.0]];
    timerDisplay.text = @"00:00:00";
    timerDisplay.tag = 1;
    [self addSubview:timerDisplay];
}

- (void)drawStartButton {
    startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchDown];
    [startButton setTitle:@"Start" forState:UIControlStateNormal];
    startButton.frame = CGRectMake(self.frame.size.width/2 - 25, self.frame.size.height - 60, 50, 30);
    [self addSubview:startButton];
}

#pragma mark - Timer Setup & Maintenence

- (void)setupTimer {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    currentDate = [gregorian dateFromComponents:comps];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timerString = [dateFormatter stringFromDate:currentDate];
    timerDisplay.text = timerString;

    //turning the wheel increases/decreases the amount of time set on the timer
    //pushing the start button starts the countdown
    //  -figure out current time, time elapsed since start was pushed, then subtract that
    //   from the timer amount. Hopefully there's an easy way to subtract NSDates
    //   Might need to setTimeWithInterval (or whatever) with number of seconds
    //pushing stop button pauses the countdown
}

- (void)updateTimer {
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *timerString = [dateFormatter stringFromDate:currentDate];
    timerDisplay.text = timerString;
}

- (void)startCountdown {
    // somehow stop wheel controls so you can't change time while counting down
    // set up alert
    // countdown?
    // needs to be some code to handle if the app is closed. 
    //      when started, figure out the exact time when this timer will be done
    //      set an alert for this time, use as reference to update timer when restarted
    countdownHasStarted = YES;
    currentDate = [currentDate dateByAddingTimeInterval:-1.0/10];
    [self updateTimer];
}

- (void)startButtonPressed {
    // this timer should 'countdown' the current date by 1 second every second.
    if (countdownHasStarted == NO) {
        stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10
                                                          target:self
                                                        selector:@selector(startCountdown)
                                                        userInfo:nil 
                                                         repeats:YES];
    }

}

#pragma mark - Touch Controls

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist < 40 || dist > 100) {
        NSLog(@"Ignoring tap (%f, %f)", touchPoint.x, touchPoint.y);
        return  NO;
    }
    float dx = touchPoint.x - container.center.x;
    float dy = touchPoint.y - container.center.y;
    deltaAngle = atan2(dy, dx);
    startTransform = container.transform;
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint pt = [touch locationInView:self];
    CGPoint previousPt = [touch previousLocationInView:self];
    float dist = [self calculateDistanceFromCenter:pt];
    if (dist < 40) {
        NSLog(@"Movement cancelled, too close to center");
        return NO;
    }
    float dx = pt.x - container.center.x;
    float dy = pt.y - container.center.y;
    float ang = atan2(dy,dx);
    float angleDifference = deltaAngle - ang;
    

    if (countdownHasStarted == NO) {

        container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
        
        //figure out angle of just-previous touch during movement
        float preDx = previousPt.x - container.center.x;
        float preDy = previousPt.y - container.center.y;
        float preAng = atan2(preDy, preDx);
        
        //compare touch to previous touch to determine which direction wheel is spinning
        if (preAng < ang) [self addValue:1.0];
        if (preAng > ang) [self subValue:1.0];
    
    }
    return YES;
    // 4/1/2012
    // add some code in here to track the number of completed rotations
    // after a certain number of successive rotations, add MORE to the clock on each turn
    // this makes adding a lot of time easier, you don't have to spin as much
    
    // should also normalize the added time somehow (one full rotation adds a minute, etc)
    // also need to fix the bug at the left side of wheel (9 o'clock) where it will add/sub weirdly
}

#pragma mark - Miscellaneous Functions

- (float)calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    //NSLog(@"CENTER is at (%f, %f)", center.x, center.y);
    float dx = point.x - center.x;
    float dy = point.y - center.y;
    return sqrt(dx*dx + dy*dy);
}

- (void)addValue:(float)value{
    // could set a max time here, check the same way as subValue
    currentDate = [currentDate dateByAddingTimeInterval:1.0];
    [self updateTimer];
}

- (void)subValue:(float)value{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:currentDate];
    int hours = [comps hour];
    int minutes = [comps minute];
    int seconds = [comps second];
    int totalSeconds = seconds + 60*minutes + 60*60*hours;
    //NSLog(@"H:%i M:%i S:%i", hours, minutes, seconds);
    //NSLog(@"totalSeconds:%i", totalSeconds);

    if (totalSeconds > 0) {
        currentDate = [currentDate dateByAddingTimeInterval:-1.0];
        [self updateTimer];
    }
}

@end
