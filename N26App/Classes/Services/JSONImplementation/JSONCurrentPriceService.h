//
//  JSONCurrentPriceService.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "JSONService.h"
#import "CurrentPriceService.h"

#define PATH @"historical/close.json"

@interface JSONCurrentPriceService : JSONService <CurrentPriceService>

@end
