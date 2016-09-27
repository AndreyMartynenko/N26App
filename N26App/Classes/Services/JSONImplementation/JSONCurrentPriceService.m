//
//  JSONCurrentPriceService.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "JSONCurrentPriceService.h"
#import "CurrentPrice.h"

static NSString * const defaultPath = @"currentprice";
static NSString * const pathExtension = @".json";

@implementation JSONCurrentPriceService

- (void)retrievePriceSuccess:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock {
    NSString *path = [NSString stringWithFormat:@"%@%@", defaultPath, pathExtension];
    [self request:path parameters:nil success:^(id responseObject) {
        CurrentPrice *response = [[CurrentPrice alloc] initWithDictionary:responseObject];
        successBlock(response);

    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

- (void)retrievePriceWithCurrency:(NSString *)currency success:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock {
    NSString *path = [NSString stringWithFormat:@"%@/%@%@", defaultPath, currency, pathExtension];
    [self request:path parameters:nil success:^(id responseObject) {
        CurrentPrice *response = [[CurrentPrice alloc] initWithDictionary:responseObject];
        successBlock(response);

    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

@end
