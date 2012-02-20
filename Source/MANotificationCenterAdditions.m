//
//  MANotificationCenterAdditions.m
//  ZeroingWeakRef
//
//  Created by Michael Ash on 7/12/10.
//

#import "MANotificationCenterAdditions.h"

#import "MAZeroingWeakRef.h"


@implementation NSNotificationCenter (MAZeroingWeakRefAdditions)

- (void)addWeakObserver: (id)observer selector: (SEL)selector name: (NSString *)name object: (NSString *)object
{
    MAZeroingWeakRef *ref = [[MAZeroingWeakRef alloc] initWithTarget: observer];
    
    id noteObj = [self addObserverForName: name object:object queue: nil usingBlock: ^(NSNotification *note) {
      @autoreleasepool {
        id target = [ref target];
        [target performSelector: selector withObject: note];
      }
    }];
    
    [ref setCleanupBlock: ^(id target) {
        [self removeObserver: noteObj];
        [ref autorelease];
    }];
}

@end
