//
//  RAContentLoaderTest.m
//  RAContentLoaderTest
//
//  Created by Evadne Wu on 10/24/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAContentLoaderTest.h"
#import "RAContentLoader.h"

@interface RAContentLoaderTest () <RAContentLoaderDataSource, RAContentLoaderDelegate>
@property (nonatomic, readonly, strong) RAContentLoader *contentLoader;
@end

@implementation RAContentLoaderTest
@synthesize contentLoader = _contentLoader;

- (void) setUp {
	
	[super setUp];
	
	_contentLoader = [RAContentLoader new];
	_contentLoader.dataSource = self;
	_contentLoader.delegate = self;
	
}

- (void) tearDown {
	
	[super tearDown];
	
	_contentLoader.dataSource = nil;
	_contentLoader.delegate = nil;
	_contentLoader = nil;
	
}

- (RAContentLoadingReference *) newLoadingReferenceForKey:(id<NSCopying>)key {
	
	NSCParameterAssert([(NSObject *)key isKindOfClass:[NSNumber class]]);

	return [[RAContentLoadingReference alloc] initWithWorkerBlock:^(RAContentLoadingCompletionBlock completionBlock) {
		
		NSTimeInterval delayInSeconds = [(NSNumber *)key doubleValue];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
			
			NSString *results = [NSString stringWithFormat:@"Result (%@)", key];
			
			completionBlock(YES, results, [NSDate date], nil);
			
		});
		
	}];

}

- (id) existingResultWithVersion:(id<RAContentLoadingReferenceResultVersion> *)outVersion forKey:(id<NSCopying>)key {
	
	if (outVersion)
		*outVersion = [NSDate date];
	
	return key;

}

- (void) contentLoader:(RAContentLoader *)loader didUpdateLoadingReference:(RAContentLoadingReference *)reference forKey:(id<NSCopying>)key {

	NSLog(@"%s %@ %@ %@", __PRETTY_FUNCTION__, loader, reference, key);

}

- (void) testExample {
	
	RAContentLoader *cl = self.contentLoader;
	
	NSArray *references = @[
		[cl beginLoadingObjectForKey:@(1)],
		[cl beginLoadingObjectForKey:@(1)],
		[cl beginLoadingObjectForKey:@(2)],
		[cl beginLoadingObjectForKey:@(3)],
		[cl beginLoadingObjectForKey:@(5)],
		[cl beginLoadingObjectForKey:@(8)]
	];
	
	STAssertEqualObjects(references[0], references[1], @"References of the same key should be identical");
	
	void (^after)(NSTimeInterval, void(^)(void)) = ^ (NSTimeInterval interval, void(^block)(void)) {
		
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2.0f * NSEC_PER_SEC), dispatch_get_main_queue(), block);
		
	};
	
	after(3.5f, ^ {
		[cl beginLoadingObjectForKey:@(1)];
		[cl beginLoadingObjectForKey:@(3)];
		[cl endLoadingObjectForKey:@(8)];
	});
	
	while (((^{
		
		for (RAContentLoadingReference *reference in references) {
			switch (reference.state) {
				case RAContentLoadingStateUnknown:
				case RAContentLoadingStateLoading:
					return YES;
				default:
					break;
			}
		}
		
		return NO;
				
	})())) {

		[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:5.0f]];
	
	}
	
	NSLog(@"everything finished (?)");
	
	STAssertEquals(
		[cl loadingReferenceForKey:@(8)].state,
		RAContentLoadingStateCancelled,
		@"Operation that’s late should be cancelled"
	);

}

@end
