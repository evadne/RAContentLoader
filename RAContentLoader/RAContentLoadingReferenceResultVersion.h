//
//  RAContentLoadingReferenceResultVersion.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/24/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RAContentLoadingReferenceResultVersion <NSObject>

- (NSComparisonResult) compare:(id<RAContentLoadingReferenceResultVersion>)otherVersion;

@end
