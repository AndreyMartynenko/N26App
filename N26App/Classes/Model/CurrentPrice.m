//
//  CurrentPrice.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "CurrentPrice.h"
#import "Currency.h"

@implementation CurrentPrice

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [super updateFromDictionary:dictionary];

    if (dictionary[@"bpi"]) {
        self.bpi = [[BPI alloc] initWithDictionary:dictionary[@"bpi"]];
    }

    if (dictionary[@"disclaimer"]) {
        self.disclaimer = dictionary[@"disclaimer"];
    }

    if (dictionary[@"time"]) {
        self.time = [[Time alloc] initWithDictionary:dictionary[@"time"]];
    }
}

@end
