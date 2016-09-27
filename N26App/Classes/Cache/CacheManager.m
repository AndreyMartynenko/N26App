//
//  CacheManager.m
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "CacheManager.h"

@interface CacheManager()

@property (nonatomic, strong) NSString *persistencePath;

@end

@implementation CacheManager

static CacheManager *sharedInstance;

+ (void)initialize {
    if (sharedInstance == nil) {
        sharedInstance = [CacheManager new];
        
        [sharedInstance generatePersistencePath];
    }
}

+ (CacheManager *)sharedInstance {
    return sharedInstance;
}

- (void)generatePersistencePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    if ([paths count] > 0) {
        sharedInstance.persistencePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"dictionary.out"];
    }
}

- (BOOL)persistDictionary:(NSDictionary *)dictionary {
    return [dictionary writeToFile:sharedInstance.persistencePath atomically:YES];
}

- (NSDictionary *)retrievePersistedDictionary {
    return [NSDictionary dictionaryWithContentsOfFile:sharedInstance.persistencePath];
}

@end
