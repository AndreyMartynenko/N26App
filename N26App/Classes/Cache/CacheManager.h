//
//  CacheManager.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import <Foundation/Foundation.h>

@interface CacheManager : NSObject

+ (CacheManager *)sharedInstance;

- (BOOL)persistDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)retrievePersistedDictionary;

@end
