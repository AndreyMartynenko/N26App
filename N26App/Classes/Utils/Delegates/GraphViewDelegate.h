//
//  GraphViewDelegate.h
//  N26App
//
//  Created by Andrey Martynenko on 9/26/16.
//
//

#import <Foundation/Foundation.h>

@protocol GraphViewDelegate <NSObject>

- (void)updateGraphViewValueAt:(NSInteger)index;

@end
