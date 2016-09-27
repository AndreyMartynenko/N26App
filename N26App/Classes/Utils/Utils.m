//
//  Utils.m
//  N26App
//
//  Created by Andrey Martynenko on 9/27/16.
//
//

#import "Utils.h"

@implementation Utils

static Utils *sharedInstance;

+ (void)initialize {
    if (sharedInstance == nil) {
        sharedInstance = [Utils new];
    }
}

+ (Utils *)sharedInstance {
    return sharedInstance;
}

- (BOOL)isNumeric:(NSString *)value {
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];
    NSNumber *number = [numberFormatter numberFromString:value];

    if (number != nil) {
        return true;
    }

    return false;
}

- (NSString *)getLocalDateFromString:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss+SS:SS";

    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    dateFormatter.timeZone = utcTimeZone;

    NSDate *utcDate = [dateFormatter dateFromString:dateString];

    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    dateFormatter.timeZone = localTimeZone;
    dateFormatter.dateFormat = @"HH:mm";

    return [dateFormatter stringFromDate:utcDate];
}

@end
