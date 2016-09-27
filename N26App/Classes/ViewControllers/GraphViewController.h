//
//  GraphViewController.h
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface GraphViewController : UIViewController <GraphViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *graphTitleLabel;
@property (weak, nonatomic) IBOutlet GraphView *graphView;

@property (weak, nonatomic) IBOutlet UILabel *updateDateLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *currencySegmentedControl;
@property (weak, nonatomic) IBOutlet UIView *usdView;
@property (weak, nonatomic) IBOutlet UILabel *usdPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *eurView;
@property (weak, nonatomic) IBOutlet UILabel *eurPriceLabel;

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *graphViewHeightConstraint;

@end
