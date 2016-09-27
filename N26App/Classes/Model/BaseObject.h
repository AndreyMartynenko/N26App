//
//  BaseObject.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface BaseObject : NSObject

@property (nonatomic, assign) NSInteger identifier;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)updateFromDictionary:(NSDictionary *)dictionary;

@end
