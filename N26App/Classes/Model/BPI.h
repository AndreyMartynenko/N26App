//
//  BPI.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import "BaseObject.h"
#import "Currency.h"

@interface BPI : BaseObject

@property (nonatomic, strong) Currency *usd;
@property (nonatomic, strong) Currency *gbp;
@property (nonatomic, strong) Currency *eur;

@end
