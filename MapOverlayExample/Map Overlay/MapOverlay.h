//
//  MapOverlay.h
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 4/16/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapOverlay : NSObject

+ (void)addCountryOverlayToMap:(MKMapView*)mapView
               WithCountryCode:(NSString*)countryCode;

@end

