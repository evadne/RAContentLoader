//
//  RAContentLoadingReference.m
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAContentLoadingReference.h"
#import "RAContentLoadingReferencePrivate.h"

@implementation RAContentLoadingReference

- (instancetype) initWithWorkerBlock:(RAContentLoadingWorkerBlock)block {
	
	NSCParameterAssert(block);
	
	self = [super init];
	if (!self)
		return nil;
	
	_workerBlock = [block copy];
	_referenceCount = 0;
	_state = RAContentLoadingStateUnknown;
	_results = nil;
	_version = nil;
	_error = nil;
	
	[self addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"results" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"version" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
	[self addObserver:self forKeyPath:@"error" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
	
	return self;

}

- (void) dealloc {

	[self removeObserver:self forKeyPath:@"state"];
	[self removeObserver:self forKeyPath:@"results"];
	[self removeObserver:self forKeyPath:@"version"];
	[self removeObserver:self forKeyPath:@"error"];

}

- (NSUInteger) increment {

	NSCParameterAssert([NSThread isMainThread]);
	
	return (self.referenceCount += 1);

}

- (NSUInteger) decrement {

	NSCParameterAssert([NSThread isMainThread]);
	NSCParameterAssert(_referenceCount);
	
	return (self.referenceCount -= 1);
	
}

- (void) setReferenceCount:(NSUInteger)referenceCount {

	if (_referenceCount == referenceCount)
		return;
	
	if ((_referenceCount == 0) && (referenceCount == 1)) {
	
		[self start];
	
	} else if ((_referenceCount == 1) && (referenceCount == 0)) {
	
		[self cancel];
	
	}
	
	_referenceCount = referenceCount;

}

- (void) start {

	switch (self.state) {
	
		case RAContentLoadingStateUnknown: {
			
			__weak typeof(self) wSelf = self;
			
			self.state = RAContentLoadingStateLoading;
			self.workerBlock(^(BOOL didFinish, id value, id<RAContentLoadingReferenceResultVersion> version, NSError *error){
				
				if (!wSelf) {
					NSLog(@"%s: Worker block invoked after host deallocation; potential waste.", __PRETTY_FUNCTION__);
					return;
				}
				
				NSCParameterAssert([NSThread isMainThread]);
				
				switch (wSelf.state) {
					
					case RAContentLoadingStateCancelled: {
						NSLog(@"%s: Worker block invoked after host cancellation; potential waste.", __PRETTY_FUNCTION__);
						return;
					}
					
					case RAContentLoadingStateLoading: {
						break;
					}
					
					case RAContentLoadingStateUnknown:
					case RAContentLoadingStateLoaded:
					case RAContentLoadingStateError: {
						NSCParameterAssert(NO);
					}
					
				}
				
				if (didFinish) {
				
					wSelf.results = value;
					wSelf.version = version;
					NSCParameterAssert(!wSelf.error);
					wSelf.state = RAContentLoadingStateLoaded;
					
				} else {
					
					NSCParameterAssert(!wSelf.results);
					NSCParameterAssert(!wSelf.version);
					wSelf.error = error;
					wSelf.state = RAContentLoadingStateError;
					
				}
			
			});
			
			break;
			
		}
		
		case RAContentLoadingStateLoading:
		case RAContentLoadingStateLoaded:
		case RAContentLoadingStateCancelled:
		case RAContentLoadingStateError: {
			NSLog(@"%s: Ignoring duplicate start", __PRETTY_FUNCTION__);
		}
		
	}

}

- (void) cancel {

	//	should pull the worker block
	//	TBD: replace entire object with an RAAsyncOperation
	
	switch (self.state) {
		
		case RAContentLoadingStateLoading: {
			self.state = RAContentLoadingStateCancelled;
			break;
		}
		
		case RAContentLoadingStateUnknown:
		case RAContentLoadingStateLoaded:
		case RAContentLoadingStateCancelled:
		case RAContentLoadingStateError: {
			break;
		}
		
	}

}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

	if (object == self) {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notifyDelegate) object:nil];
		[self performSelector:@selector(notifyDelegate) withObject:nil afterDelay:0.01f];
	}

}

- (void) notifyDelegate {
	
	[self.delegate contentLoadingReferenceDidChangeState:self];

}

- (NSString *) description {

	return [NSString stringWithFormat:@"<%@: %p> { State: %@; Results: %@; Version: %@; Error: %@ }", NSStringFromClass([self class]), self, NSStringFromRAContentLoadingState(self.state), self.results, self.version, self.error];

}

@end
