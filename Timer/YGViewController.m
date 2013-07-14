//
//  YGViewController.m
//  raDial Timer
//
//  Created by yaakov gamliel on 4/16/13.
//  Copyright (c) 2013 SuaveApps. All rights reserved.
//

#import "YGViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JHViewController.h"
#import "JHRotaryWheel.h"

@interface YGViewController ()

@end

@implementation YGViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.bounds = [[UIScreen mainScreen]bounds];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //add some flair
    self.view.layer.backgroundColor	 = [UIColor darkGrayColor].CGColor;
    self.view.layer.cornerRadius = 0.0;
    
    JHRotaryWheel *wheel = [[JHRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 320, 480)
                                                    andDelegate:self];
    [self.view addSubview:wheel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


@end
