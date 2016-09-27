//
//  Information.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Information : BaseObject

@property (nonatomic, strong) NSString *appName;
@property (nonatomic, assign) NSInteger appIdentifier;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *supportUrl;
@property (nonatomic, strong) NSString *virtualCurrency;

@end
