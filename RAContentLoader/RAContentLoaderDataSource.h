//
//  RAContentLoaderDataSource.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAContentLoadingReference.h"

@protocol RAContentLoaderDataSource <NSObject>

- (RAContentLoadingReference *) newLoadingReferenceForKey:(id<NSCopying>)key;

- (id) existingResultWithVersion:(id<RAContentLoadingReferenceResultVersion> *)outVersion forKey:(id<NSCopying>)key;

@end
