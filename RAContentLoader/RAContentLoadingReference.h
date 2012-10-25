//
//  RAContentLoadingReference.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAContentLoaderDefines.h"
#import "RAContentLoadingReferenceDelegate.h"
#import "RAContentLoadingReferenceResultVersion.h"

@interface RAContentLoadingReference : NSObject

- (instancetype) initWithWorkerBlock:(RAContentLoadingWorkerBlock)block;

@property (nonatomic, readwrite, weak) id<RAContentLoadingReferenceDelegate> delegate;
@property (nonatomic, readonly, copy) RAContentLoadingWorkerBlock workerBlock;
@property (nonatomic, readonly, assign) NSUInteger referenceCount;

@property (nonatomic, readonly, assign) RAContentLoadingState state;
@property (nonatomic, readonly, strong) id results;
@property (nonatomic, readonly, strong) id<RAContentLoadingReferenceResultVersion> version;
@property (nonatomic, readonly, strong) NSError *error;

- (NSUInteger) increment;
- (NSUInteger) decrement;

- (void) start;
- (void) cancel;

@end
