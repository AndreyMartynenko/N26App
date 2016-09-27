//
//  BaseObject.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "BaseObject.h"

@implementation BaseObject

static NSDateFormatter *baseDateFormatter;

+ (void)initialize {
    if (baseDateFormatter == nil) {
        baseDateFormatter = [[NSDateFormatter alloc] init];
        [baseDateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        [self updateFromDictionary:dictionary];
    }
    
    return self;
}

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    
}

@end
