//
//  JSONHistoricalService.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "JSONHistoricalService.h"
#import "Historical.h"

static NSString * const path = @"historical/close.json";

static NSString * const currencyKey = @"currency";
static NSString * const startDateKey = @"start";
static NSString * const endDateKey = @"end";

@implementation JSONHistoricalService

- (void)retrieveHistoricalDataSuccess:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:@"EUR" forKey:currencyKey];

    [self request:path parameters:parameters success:^(id responseObject) {
        Historical *response = [[Historical alloc] initWithDictionary:responseObject];
        successBlock(response);

    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

- (void)retrieveHistoricalDataWithCurrency:(NSString *)currency startDate:(NSDate *)startDate endDate:(NSDate *)endDate success:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"YYYY-MM-dd";

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:currency forKey:currencyKey];
    [parameters setObject:[dateFormatter stringFromDate:startDate] forKey:startDateKey];
    [parameters setObject:[dateFormatter stringFromDate:endDate] forKey:endDateKey];

    [self request:path parameters:parameters success:^(id responseObject) {
        Historical *response = [[Historical alloc] initWithDictionary:responseObject];
        successBlock(response);

    } failure:^(NSError *error) {
        failureBlock(error);
    }];
}

@end
