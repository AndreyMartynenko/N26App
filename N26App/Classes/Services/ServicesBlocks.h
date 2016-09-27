//
//  ServicesBlocks.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^RequestSuccessBlock)(id responseObject);
typedef void (^SuccessArrayBlock)(NSArray *results);
typedef void (^SuccessObjectBlock)(id object);
typedef void (^SuccessBlock)();
typedef void (^FailureBlock)(NSError* error);

