//
//  RAContentLoaderDefines.m
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAContentLoaderDefines.h"

NSString * NSStringFromRAContentLoadingState (RAContentLoadingState state) {

	return ((NSString * []){
		[RAContentLoadingStateUnknown] = @"Unknown",
		[RAContentLoadingStateLoading] = @"Loading",
		[RAContentLoadingStateLoaded] = @"Loaded",
		[RAContentLoadingStateCancelled] = @"Cancelled",
		[RAContentLoadingStateError] = @"Error"
	})[state];
	
}
