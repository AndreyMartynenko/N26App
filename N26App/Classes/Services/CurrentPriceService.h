//
//  CurrentPriceService.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "ServicesBlocks.h"

@protocol CurrentPriceService <NSObject>

- (void)retrievePriceSuccess:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock;
- (void)retrievePriceWithCurrency:(NSString *)currency success:(SuccessObjectBlock)successBlock failure:(FailureBlock)failureBlock;

@end
