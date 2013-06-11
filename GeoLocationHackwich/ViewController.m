//
//  ViewController.m
//  GeoLocationHackwich
//
//  Created by Brian Lewis on 5/20/13.
//  Copyright (c) 2013 Brian Lewis. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h> //for rounded corners of views (layers)

@interface ViewController ()
{
    CLLocationManager *locationManager;
    __weak IBOutlet MKMapView *mapView;
    __weak IBOutlet UITextField *addressTextField;
    __weak IBOutlet UIView *dimmerView;
    UIView *addressView;
    MKPointAnnotation *annotation;
    CLLocationCoordinate2D location;
}
- (IBAction)runSimulator:(id)sender;
- (IBAction)manualLocationSearch:(id)sender;
- (IBAction)showAddressTextField:(id)sender;
- (IBAction)changeMapType:(id)sender;

-(void)showLocation;
//-(void)setUpGestureRecognizer;
//-(void)goToUpLocation;


@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
   
    CLLocationCoordinate2D mobileMakers = CLLocationCoordinate2DMake(41.893942,-87.635323);
    
    location = mobileMakers;
    
    annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:location];

    addressView = [self.view viewWithTag:1];
    
    addressView.alpha = 1;
    
    [addressView.layer setCornerRadius:7];
    dimmerView.alpha = .5;
    
    UITextField *textField = (UITextField*)[addressView viewWithTag:2];
    textField.clearButtonMode = YES;
    [textField becomeFirstResponder];
    
  //  [self setUpGestureRecognizer];
    
    [self showLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*-(void)setUpGestureRecognizer{
    UISwipeGestureRecognizer *upGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToUpLocation)];
    upGesture.direction = UISwipeGestureRecognizerDirectionUp;
    upGesture.delegate = self;
    [self.view addGestureRecognizer:upGesture];
    
    UISwipeGestureRecognizer *downGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToDownLocation)];
    downGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downGesture];
    
    UISwipeGestureRecognizer *leftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToLeftLocation)];
    leftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftGesture];
    
    UISwipeGestureRecognizer *rightGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goToRightLocation)];
    rightGesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightGesture];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}*/

-(void)goToUpLocation
{
    addressTextField.text = @"233 W Erie, Chicago, IL";
    
    [self manualLocationSearch:self];
}

- (IBAction)manualLocationSearch:(id)sender {
    [locationManager stopUpdatingLocation];
    [self showLocation];
    [addressTextField resignFirstResponder];
}

- (IBAction)showAddressTextField:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        addressView.alpha = 1;
        dimmerView.alpha = .5;
    }];
    
    UITextField *textField = (UITextField*)[addressView viewWithTag:2];
    [textField becomeFirstResponder];
}

- (IBAction)changeMapType:(UISegmentedControl*)sender {
        mapView.mapType = sender.selectedSegmentIndex; //0 for std, 1 for sat, 2 for hybrid
}

-(void)showLocation{

    if (![addressTextField.text isEqual:@""]) {
    
        NSString *address = addressTextField.text;
        NSString *encodedAddress = [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=false", encodedAddress];
                
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSArray *resultsArray = [responseDictionary objectForKey:@"results"];
            
            //if resultsArray.count == 0 the app will crash on the next line, should do a check before the next steps and give some sort of alert saying that the address doesn't exist
            
            NSDictionary *locationDictionary = [[resultsArray[0] objectForKey:@"geometry"] objectForKey:@"location"];
            
            location = CLLocationCoordinate2DMake([[locationDictionary objectForKey:@"lat"] floatValue], [[locationDictionary objectForKey:@"lng"] floatValue]);
            
            MKCoordinateRegion region;
            region.center = location;
            
            MKCoordinateSpan span;
            span.latitudeDelta  = .02; // Change these values to change the zoom
            span.longitudeDelta = .02;
            region.span = span;
            
            [mapView setRegion:region animated:YES];
            
            [annotation setCoordinate:location];
            
            [mapView addAnnotation:annotation];
            
            [UIView animateWithDuration:0.5 animations:^{
                addressView.alpha = 0;
                dimmerView.alpha = 0;
            }];
            
        }];
    }
    else{
    
    MKCoordinateRegion region;
    region.center = location;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = .02; // Change these values to change the zoom
    span.longitudeDelta = .02;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
    
    [annotation setCoordinate:location];
    
    [mapView addAnnotation:annotation];
    }
}

- (IBAction)runSimulator:(id)sender {
    
    [locationManager startUpdatingLocation];
    mapView.showsUserLocation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view viewWithTag:1].alpha = 0;
        dimmerView.alpha = 0;
        
    }];

    [addressTextField resignFirstResponder];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"the location array: %@", locations);
    
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    
    MKCoordinateSpan span;
    span.latitudeDelta  = .05; // Change these values to change the zoom
    span.longitudeDelta = .05;
    region.span = span;
    
    [mapView setRegion:region animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self manualLocationSearch:self];
    
    return YES;
}
@end