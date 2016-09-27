//
//  Historical.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "Historical.h"

@implementation Historical

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [super updateFromDictionary:dictionary];

    if (dictionary[@"bpi"]) {
        self.bpi = dictionary[@"bpi"];
    }
    
    if (dictionary[@"disclaimer"]) {
        self.disclaimer = dictionary[@"disclaimer"];
    }

    if (dictionary[@"time"]) {
        self.time = [[Time alloc] initWithDictionary:dictionary[@"time"]];
    }
}

@end
