//
//  Utils.h
//  N26App
//
//  Created by Andrey Martynenko on 9/27/16.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (Utils *)sharedInstance;

- (BOOL)isNumeric:(NSString *)value;
- (NSString *)getLocalDateFromString:(NSString *)dateString;

@end
