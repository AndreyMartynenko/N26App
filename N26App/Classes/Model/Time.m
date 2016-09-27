//
//  Time.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "Time.h"

@implementation Time

- (void)updateFromDictionary:(NSDictionary *)dictionary {
    [super updateFromDictionary:dictionary];

    if (dictionary[@"updated"]) {
        self.updated = dictionary[@"updated"];
    }

    if (dictionary[@"updatedISO"]) {
        self.updatedISO = dictionary[@"updatedISO"];
    }

    if (dictionary[@"updateduk"]) {
        self.updateduk = dictionary[@"updateduk"];
    }
}

@end
