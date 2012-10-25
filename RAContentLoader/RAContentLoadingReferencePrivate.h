//
//  RAContentLoadingReferencePrivate.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/24/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import "RAContentLoadingReference.h"

@interface RAContentLoadingReference ()
@property (nonatomic, readwrite, copy) RAContentLoadingWorkerBlock workerBlock;
@property (nonatomic, readwrite, assign) NSUInteger referenceCount;
@property (nonatomic, readwrite, assign) RAContentLoadingState state;
@property (nonatomic, readwrite, strong) id results;
@property (nonatomic, readwrite, strong) id<RAContentLoadingReferenceResultVersion> version;
@property (nonatomic, readwrite, strong) NSError *error;
@end
