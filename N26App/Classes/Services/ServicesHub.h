//
//  ServicesHub.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <UIKit/UIKit.h>
#import "HistoricalService.h"
#import "CurrentPriceService.h"

@interface ServicesHub : NSObject

+ (ServicesHub *)sharedInstance;

- (NSObject <HistoricalService> *)historicalService;
- (NSObject <CurrentPriceService> *)currentPriceService;

@end
