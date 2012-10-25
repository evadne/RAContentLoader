//
//  RAContentLoadingReferenceDelegate.h
//  RAContentLoader
//
//  Created by Evadne Wu on 10/24/12.
//  Copyright (c) 2012 Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RAContentLoadingReference;
@protocol RAContentLoadingReferenceDelegate <NSObject>

- (void) contentLoadingReferenceDidChangeState:(RAContentLoadingReference *)reference;

@end
