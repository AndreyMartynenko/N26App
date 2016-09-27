//
//  Historical.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "BaseObject.h"
#import "Time.h"

@interface Historical : BaseObject

@property (nonatomic, strong) NSDictionary *bpi;
@property (nonatomic, strong) NSString *disclaimer;
@property (nonatomic, strong) Time *time;

@end
