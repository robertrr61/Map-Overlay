//
//  ViewController.m
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 4/16/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapOverlay.h"
#import "MBProgressHUD.h"

@interface MapViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation MapViewController

#pragma View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // map view setup
    [self.mapView setDelegate:self];
    
    // map gestures
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGesture.minimumPressDuration = 0.3;
    [self.mapView addGestureRecognizer:longPressGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // initial map camera
    CLLocationCoordinate2D startCoord = CLLocationCoordinate2DMake(0, -80);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, 180, 180)];
    adjustedRegion.span.latitudeDelta = 180;
    adjustedRegion.span.longitudeDelta = 180;
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    // show instructions toast
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Long press on a country to add overlay over it";
    hud.labelFont = [UIFont boldSystemFontOfSize:10];
    hud.yOffset = self.view.bounds.size.height/3;
    hud.margin = 10.f;
    [hud hide:YES afterDelay:2.0];
}

#pragma mark - Handle Gesture
- (void)handleLongPress:(UIGestureRecognizer*)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Long pressed");
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        // remove previous annotations and overlays
        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView removeOverlays:self.mapView.overlays];
        
        // get coordinate
        CGPoint touchPoint = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        // move to touch point
//        CLLocationCoordinate2D startCoord = touchMapCoordinate;
//        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:MKCoordinateRegionMakeWithDistance(startCoord, .5, .5)];
//        adjustedRegion.span.latitudeDelta = 30;
//        adjustedRegion.span.longitudeDelta = 30;
//        [self.mapView setRegion:adjustedRegion animated:YES];
        
        NSLog(@"Coordinate: %.02f, %.02f",touchMapCoordinate.latitude, touchMapCoordinate.longitude);
        
        // add overlay
        [self addOverlayToCountryWithLat:touchMapCoordinate.latitude AndLon:touchMapCoordinate.longitude];
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        
    }
}

#pragma mark - Reverse Geocode
- (void)addOverlayToCountryWithLat:(double)latitude AndLon:(double)longitude {
    
    // geocoder
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    // reverse geocode
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (!error) {
            // get country code with placemark
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSString *countryCode = placemark.ISOcountryCode;
            NSLog(@"Country: %@",countryCode);
            
            // add overlay
            [MapOverlay addCountryOverlayToMap:self.mapView
                               WithCountryCode:countryCode];
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // show country name
            if (placemark.country && ![placemark.country isEqualToString:@""]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = placemark.country;
                hud.labelFont = [UIFont boldSystemFontOfSize:14];
                hud.margin = 10.f;
                hud.yOffset = self.view.bounds.size.height/3;
                
                [hud hide:YES afterDelay:1.0];
            }
            
        } else {
            NSLog(@"Not found");
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

#pragma mark - MKMapViewDelegate
-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id)overlay{
    if([overlay isKindOfClass:[MKPolygon class]]){
        MKPolygonView *view = [[MKPolygonView alloc] initWithOverlay:overlay];
        view.lineWidth=5;
        view.strokeColor=[UIColor blueColor];
        view.fillColor=[[UIColor blueColor] colorWithAlphaComponent:0.2];
        return view;
    } else {
        return nil;
    }
}

@end
