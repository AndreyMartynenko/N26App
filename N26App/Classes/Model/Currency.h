//
//  Currency.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "BaseObject.h"

@interface Currency : BaseObject

@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *rate;
@property (nonatomic, strong) NSString *descriptionString;
@property (nonatomic, assign) CGFloat rateFloat;

@end
