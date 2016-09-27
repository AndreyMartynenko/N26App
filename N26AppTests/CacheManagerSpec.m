//
//  CacheManagerSpec.m
//  N26App
//
//  Created by Andrey Martynenko on 9/27/16.
//
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "CacheManager.h"

@interface CacheManager (Testing)

@end

SpecBegin(CacheManager)

describe(@"CacheManager", ^{

    __block CacheManager *_sut;

    beforeEach(^{
        _sut = [CacheManager sharedInstance];
    });

    afterEach(^{
        _sut = nil;
    });

    describe(@"retrievePersistedDictionary", ^{
        it(@"should return the right dictionary", ^{
            NSDictionary *inputDictionary = @{ @"key1" : @"val1",
                                               @"key2" : @"val2" };
            [_sut persistDictionary:inputDictionary];

            NSDictionary *resultDictionary = [_sut retrievePersistedDictionary];
            expect(resultDictionary).to.equal(inputDictionary);
        });

    });

});

SpecEnd
