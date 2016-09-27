//
//  HistoricalService.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "ServicesBlocks.h"

@protocol HistoricalService <NSObject>

- (void)retrieveHistoricalDataSuccess:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock;
- (void)retrieveHistoricalDataWithCurrency:(NSString *)currency startDate:(NSDate *)startDate endDate:(NSDate *)endDate success:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock;

@end
