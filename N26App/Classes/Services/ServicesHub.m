//
//  ServicesHub.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "ServicesHub.h"

#import "JSONHistoricalService.h"
#import "JSONCurrentPriceService.h"

@interface ServicesHub()

@property (nonatomic, strong) NSObject <HistoricalService> *historicalService;
@property (nonatomic, strong) NSObject <CurrentPriceService> *currentPriceService;

@end

@implementation ServicesHub

static ServicesHub *sharedInstance;

+ (void)initialize {
    if (sharedInstance == nil) {
        sharedInstance = [ServicesHub new];
        
        sharedInstance.historicalService = [JSONHistoricalService new];
        sharedInstance.currentPriceService = [JSONCurrentPriceService new];
    }
}

+ (ServicesHub *)sharedInstance {
    return sharedInstance;
}

@end
