//
//  SettingsViewController.m
//  GeoLocationHackwich
//
//  Created by Brian Lewis on 5/20/13.
//  Copyright (c) 2013 Brian Lewis. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()
{
    __weak IBOutlet UITextField *upAddressTextField;    
    __weak IBOutlet UITextField *downAddressTextField;
    __weak IBOutlet UITextField *leftAddressTextField;
    __weak IBOutlet UITextField *rightAddressTextField;
}
- (IBAction)submitSettings:(id)sender;

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitSettings:(id)sender {
}
@end
