//
//  CurrentPrice.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "BaseObject.h"
#import "Time.h"
#import "BPI.h"

@interface CurrentPrice : BaseObject

@property (nonatomic, strong) BPI *bpi;
@property (nonatomic, strong) NSString *disclaimer;
@property (nonatomic, strong) Time *time;

@end
