//
//  Currency.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "Currency.h"

@implementation Currency

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [super updateFromDictionary:dictionary];

    if (dictionary[@"code"]) {
        self.code = dictionary[@"code"];
    }

    if (dictionary[@"symbol"]) {
        self.symbol = dictionary[@"symbol"];
    }

    if (dictionary[@"rate"]) {
        self.rate = dictionary[@"rate"];
    }

    if (dictionary[@"description"]) {
        self.descriptionString = dictionary[@"description"];
    }
    
    if (dictionary[@"rate_float"]) {
        self.rateFloat = [dictionary[@"rate_float"] floatValue];
    }
}

@end
