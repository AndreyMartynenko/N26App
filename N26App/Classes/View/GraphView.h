//
//  GraphView.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <UIKit/UIKit.h>
#import "GraphViewDelegate.h"

@interface GraphView : UIView

- (void)updateContentWithValues:(NSArray *)values delegate:(id<GraphViewDelegate>)delegate;
- (void)checkTouchAreaAt:(CGPoint)point;

@end
