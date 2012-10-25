//
//  RAContentLoaderDefines.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAContentLoadingReferenceResultVersion.h"

typedef NS_ENUM (NSUInteger, RAContentLoadingState) {
	RAContentLoadingStateUnknown,
	RAContentLoadingStateLoading,
	RAContentLoadingStateLoaded,
	RAContentLoadingStateCancelled,
	RAContentLoadingStateError
};

typedef void (^RAContentLoadingCompletionBlock)(BOOL didFinish, id value, id<RAContentLoadingReferenceResultVersion> version, NSError *error);
typedef void (^RAContentLoadingWorkerBlock)(RAContentLoadingCompletionBlock completionBlock);

extern NSString * NSStringFromRAContentLoadingState (RAContentLoadingState state);
