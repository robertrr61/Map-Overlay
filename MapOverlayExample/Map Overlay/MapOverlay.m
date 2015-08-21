//
//  MapOverlay.m
//  MapOverlayExample
//
//  Created by Roberto Rumbaut on 4/16/15.
//  Copyright (c) 2015 mobmedianet. All rights reserved.
//

#import "MapOverlay.h"
#import "GeoJSONSerialization.h"

@implementation MapOverlay

+(void)addCountryOverlayToMap:(MKMapView *)mapView
              WithCountryCode:(NSString *)countryCode {
    if (countryCode && ![countryCode isEqualToString:@""] && countryCode.length == 2) {
        // get geojson info
        NSString *path = [[NSBundle mainBundle] pathForResource:@"countries-ISOalpha2" ofType:@"json"];
        NSData *countryPointsData = [[NSData alloc] initWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *geoJSON = [NSJSONSerialization JSONObjectWithData:countryPointsData options:0 error:&error];
        
        NSArray *countries = [geoJSON objectForKey:@"features"];
        
        // find country shape
        MKShape *shape = [[MKShape alloc] init];
        BOOL found = NO;
        for (int i = 0; i < countries.count; i++) {
            if ([[(NSDictionary*)countries[i] objectForKey:@"id"] isEqualToString:countryCode]) {
                shape = [GeoJSONSerialization shapeFromGeoJSONFeature:countries[i] error:&error];
                found = YES;
            }
        }
        
        if (found) {
            // add country overlay
            if ([shape isKindOfClass:[MKPointAnnotation class]]) {
                [mapView addAnnotation:shape];
            } else if ([shape conformsToProtocol:@protocol(MKOverlay)]) {
                [mapView addOverlay:(id <MKOverlay>)shape];
            }
            
            // in case shape is a multipolygon
            if ([shape isKindOfClass:[NSArray class]]) {
                for (MKShape *currentShape in (NSArray*)shape) {
                    if ([currentShape isKindOfClass:[MKPointAnnotation class]]) {
                        [mapView addAnnotation:currentShape];
                    } else if ([currentShape conformsToProtocol:@protocol(MKOverlay)]) {
                        [mapView addOverlay:(id <MKOverlay>)currentShape];
                    }
                }
                
                // find largest region
                MKShape *finalShape = [[MKShape alloc] init];
                finalShape = [(NSArray*)shape firstObject];
                for (MKShape *currentShape in (NSArray*)shape) {
                    if (([(MKPolyline*)currentShape boundingMapRect].size.width *  [(MKPolyline*)currentShape boundingMapRect].size.height) >
                        ([(MKPolyline*)finalShape boundingMapRect].size.width * [(MKPolyline*)finalShape boundingMapRect].size.height)) {
                        finalShape = currentShape;
                    }
                }
                // show region on map
                [mapView setVisibleMapRect:[(MKPolyline*)finalShape boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:YES];
            } else {
                // show region on map
                [mapView setVisibleMapRect:[(MKPolyline*)shape boundingMapRect] edgePadding:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0) animated:YES];
            }
        }
    }
}



@end
