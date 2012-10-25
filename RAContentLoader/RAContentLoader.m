//
//  RAContentLoader.m
//  RAContentLoader
//
//  Created by Evadne Wu on 10/23/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAContentLoader.h"
#import "RAContentLoadingReferenceDelegate.h"
#import "RAContentLoadingReferencePrivate.h"

@interface RAContentLoader () <RAContentLoadingReferenceDelegate>
@property (nonatomic, readonly, strong) dispatch_queue_t dispatchQueue;
@property (nonatomic, readonly, strong) NSMutableDictionary *keysToReferences;
@end


@implementation RAContentLoader
@synthesize dataSource = _dataSource;
@synthesize delegate = _delegate;
@synthesize keysToReferences = _keysToReferences;

- (id) init {

	self = [super init];
	if (!self)
		return nil;
	
	_keysToReferences = [NSMutableDictionary dictionary];
	
	return self;

}

- (RAContentLoadingReference *) newLoadingReferenceForKey:(id<NSCopying>)key {

	RAContentLoadingReference *reference = [self.dataSource newLoadingReferenceForKey:key];
	NSCParameterAssert(reference);
	NSCParameterAssert(!reference.delegate);
	NSCParameterAssert(!reference.version);
	NSCParameterAssert(!reference.results);
	NSCParameterAssert(!reference.error);
	
	reference.delegate = self;
	
	id<RAContentLoadingReferenceResultVersion> version = nil;
	reference.results = [self.dataSource existingResultWithVersion:&version forKey:key];
	reference.version = version;
	
	return reference;

}

- (RAContentLoadingReference *) beginLoadingObjectForKey:(id<NSCopying>)key {

	NSCParameterAssert([NSThread isMainThread]);
	
	RAContentLoadingReference *reference = [self loadingReferenceForKey:key];
	if (!reference) {
		reference = [self newLoadingReferenceForKey:key];
		[self.keysToReferences setObject:reference forKey:key];
	}
	
	[reference increment];
	
	return reference;

}

- (RAContentLoadingReference *) endLoadingObjectForKey:(id<NSCopying>)key {
	
	NSCParameterAssert([NSThread isMainThread]);
	
	RAContentLoadingReference *reference = [self loadingReferenceForKey:key];
	NSCParameterAssert(reference);
	
	[reference decrement];
	
	return reference;
	
}

- (RAContentLoadingReference *) loadingReferenceForKey:(id<NSCopying>)key {

	NSCParameterAssert([NSThread isMainThread]);
	
	RAContentLoadingReference *reference = [self.keysToReferences objectForKey:key];
	NSCParameterAssert(!reference || [reference isKindOfClass:[RAContentLoadingReference class]]);
	
	return reference;

}

- (void) contentLoadingReferenceDidChangeState:(RAContentLoadingReference *)reference {

	NSArray *allKeys = [self.keysToReferences allKeysForObject:reference];
	NSCParameterAssert([allKeys count] == 1);
	
	id<NSCopying> key = [allKeys lastObject];
	
	[self.delegate contentLoader:self didUpdateLoadingReference:reference forKey:key];

}

@end
