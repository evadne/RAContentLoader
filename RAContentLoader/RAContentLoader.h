//
//  RAContentLoader.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAContentLoaderDefines.h"
#import "RAContentLoaderDataSource.h"
#import "RAContentLoaderDelegate.h"
#import "RAContentLoadingReference.h"

@interface RAContentLoader : NSObject

- (RAContentLoadingReference *) beginLoadingObjectForKey:(id<NSCopying>)key;
- (RAContentLoadingReference *) endLoadingObjectForKey:(id<NSCopying>)key;
- (RAContentLoadingReference *) loadingReferenceForKey:(id<NSCopying>)key;

@property (nonatomic, readwrite, weak) id<RAContentLoaderDataSource> dataSource;
@property (nonatomic, readwrite, weak) id<RAContentLoaderDelegate> delegate;

@end
