//
//  RAContentLoaderDelegate.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAContentLoader, RAContentLoadingReference;
@protocol RAContentLoaderDelegate <NSObject>

- (void) contentLoader:(RAContentLoader *)loader didUpdateLoadingReference:(RAContentLoadingReference *)reference forKey:(id<NSCopying>)key;

@end
