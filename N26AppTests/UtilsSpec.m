//
//  UtilsSpec.m
//  N26App
//
//  Created by Andrey Martynenko on 9/27/16.
//
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>

#import "Utils.h"

@interface Utils (Testing)

@end

SpecBegin(Utils)

describe(@"Utils", ^{

    __block Utils *_sut;

    beforeEach(^{
        _sut = [Utils sharedInstance];
    });

    afterEach(^{
        _sut = nil;
    });

    describe(@"isNumeric:", ^{

        context(@"argument contains not numeric characters", ^{

            it(@"should return NO", ^{
                NSString *inputValue = @"1234qwer";

                BOOL expectedResult = [_sut isNumeric:inputValue];

                expect(expectedResult).to.beFalsy();
            });

        });

        context(@"argument is float", ^{

            it(@"should return YES", ^{
                NSString *inputValue = @"1234.56";

                BOOL expectedResult = [_sut isNumeric:inputValue];

                expect(expectedResult).to.beTruthy();
            });

        });

        context(@"argument is integer", ^{

            it(@"should return YES", ^{
                NSString *inputValue = @"1234";

                BOOL expectedResult = [_sut isNumeric:inputValue];

                expect(expectedResult).to.beTruthy();
            });

        });

    });
    
});

SpecEnd
