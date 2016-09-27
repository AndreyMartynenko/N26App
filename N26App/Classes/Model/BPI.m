//
//  BPI.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "BPI.h"

@implementation BPI

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [super updateFromDictionary:dictionary];

    if (dictionary[@"USD"]) {
        self.usd = [[Currency alloc] initWithDictionary:dictionary[@"USD"]];
    }

    if (dictionary[@"GBP"]) {
        self.gbp = [[Currency alloc] initWithDictionary:dictionary[@"GBP"]];
    }

    if (dictionary[@"EUR"]) {
        self.eur = [[Currency alloc] initWithDictionary:dictionary[@"EUR"]];
    }
}

@end
