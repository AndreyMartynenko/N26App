//
//  GraphViewController.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "GraphViewController.h"
#import "CacheManager.h"
#import "ServicesHub.h"
#import "Historical.h"
#import "CurrentPrice.h"
#import "Constants.h"
#import "Utils.h"

static NSTimeInterval const updateTimeInterval = 30;

@interface GraphViewController ()

@property (nonatomic, strong) NSTimer *updateTimer;
@property (nonatomic, strong) NSDictionary *historicalBPI;
@property (nonatomic, strong) NSArray *sortedHistoricalBPIValues;
@property (nonatomic, assign) NSInteger indexBPIValueToUpdate;

@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.currencySegmentedControl.selectedSegmentIndex = 0;

    self.historicalBPI = [[CacheManager sharedInstance] retrievePersistedDictionary];
    if (!self.historicalBPI) {
        return;
    }

    [self sortHistoricalBPIValues];

    self.graphTitleLabel.text = @"Last fetched rates of Bitcoin/EUR";
    [self.graphView updateContentWithValues:self.sortedHistoricalBPIValues delegate:self];

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didLongPress:)];
    [self.graphView addGestureRecognizer:longPress];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [self updateUIBasedOnDevice];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self updateData];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
    [self.updateTimer invalidate];
    self.updateTimer = nil;
}

#pragma mark - Data updates

- (void)updateData {
    [self updateHistoricalData];
    [self updateCurrentPrice];

    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:updateTimeInterval target:self
                                                      selector:@selector(updateCurrentPrice) userInfo:nil
                                                       repeats:YES];
}

- (void)updateHistoricalData {
    [[ServicesHub sharedInstance].historicalService retrieveHistoricalDataWithCurrency:@"EUR" startDate:[self getStartDate] endDate:[NSDate date] success:^(id object) {
        NSLog(@"__historicalService: success");

        Historical *historical = (Historical *)object;
        self.historicalBPI = historical.bpi;
        [[CacheManager sharedInstance] persistDictionary:self.historicalBPI];

        [self sortHistoricalBPIValues];

        self.graphTitleLabel.text = @"Historical exchange rate of Bitcoin/EUR";
        [self.graphView updateContentWithValues:self.sortedHistoricalBPIValues delegate:self];

    } failure:^(NSError *error) {
        NSLog(@"__historicalService: failure");
        
    }];
}

- (void)updateCurrentPrice {
    [[ServicesHub sharedInstance].currentPriceService retrievePriceWithCurrency:@"EUR" success:^(id object) {
        NSLog(@"__currentPriceService: success");

        CurrentPrice *currentPrice = (CurrentPrice *)object;

        self.updateDateLabel.text = [[Utils sharedInstance] getLocalDateFromString:currentPrice.time.updatedISO];
        self.usdPriceLabel.text = [NSString stringWithFormat:@"%.2f", currentPrice.bpi.usd.rateFloat];
        self.eurPriceLabel.text = [NSString stringWithFormat:@"%.2f", currentPrice.bpi.eur.rateFloat];

    } failure:^(NSError *error) {
        NSLog(@"__currentPriceService: failure");

    }];
}

#pragma mark - Helpers

- (NSDate *)getStartDate {
    NSDate *now = [NSDate date];

    return [now dateByAddingTimeInterval:-28*24*60*60];
}

- (NSArray *)sortHistoricalBPIKeys {
    NSArray *sortedHistoricalBPIKeys;
    sortedHistoricalBPIKeys = [self.historicalBPI.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];

    return sortedHistoricalBPIKeys;
}

- (void)sortHistoricalBPIValues {
    NSArray *sortedHistoricalBPIKeys = [self sortHistoricalBPIKeys];
    NSMutableArray *sortedHistoricalBPIValues = [NSMutableArray arrayWithCapacity:sortedHistoricalBPIKeys.count];

    for (NSDate *date in sortedHistoricalBPIKeys) {
        [sortedHistoricalBPIValues addObject:self.historicalBPI[date]];
    }

    self.sortedHistoricalBPIValues = sortedHistoricalBPIValues;
}

- (void)updateHistoricalBPIAt:(NSInteger)index value:(CGFloat)value {
    NSArray *sortedHistoricalBPIKeys = [self sortHistoricalBPIKeys];
    NSDate *date = sortedHistoricalBPIKeys[index];

    NSMutableDictionary *historicalBPI = [self.historicalBPI mutableCopy];
    historicalBPI[date] = [NSNumber numberWithFloat:value];
    self.historicalBPI = historicalBPI;

    [[CacheManager sharedInstance] persistDictionary:self.historicalBPI];

    NSMutableArray *values = [self.sortedHistoricalBPIValues mutableCopy];
    values[index] = [NSNumber numberWithFloat:value];
    self.sortedHistoricalBPIValues = values;
}

- (void)updateUIBasedOnDevice {
    if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5) {
        self.graphViewHeightConstraint.constant = 250;
        self.usdPriceLabel.font = [UIFont fontWithName:@"System" size:18];
        self.eurPriceLabel.font = [UIFont fontWithName:@"System" size:18];
    }
}

#pragma mark - Actions

- (IBAction)currencySegmentedControlAction:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.usdView.hidden = NO;
        self.eurView.hidden = YES;
    } else {
        self.usdView.hidden = YES;
        self.eurView.hidden = NO;
    }
}

- (void)didLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:self.graphView];

        [self.graphView checkTouchAreaAt:point];
    }
}

#pragma mark - FALProductAvailabilityCellDelegate

- (void)updateGraphViewValueAt:(NSInteger)index {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Change Value" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        self.indexBPIValueToUpdate = index;
        self.inputTextField.text = [NSString stringWithFormat:@"%.2f", [self.sortedHistoricalBPIValues[index] floatValue]];

        [self.inputTextField becomeFirstResponder];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete Value" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self updateHistoricalBPIAt:index value:0];
        [self.graphView updateContentWithValues:self.sortedHistoricalBPIValues delegate:self];
    }]];

    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - Keyboard notification

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:0 animations:^{
        self.inputViewBottomConstraint.constant = keyboardSize.height;
        self.inputView.hidden = NO;
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] delay:0 options:0 animations:^{
        self.inputViewBottomConstraint.constant = 0;
        self.inputView.hidden = YES;
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([[Utils sharedInstance] isNumeric:textField.text]) {
        [textField resignFirstResponder];

        [self updateHistoricalBPIAt:self.indexBPIValueToUpdate value:[textField.text floatValue]];
        [self.graphView updateContentWithValues:self.sortedHistoricalBPIValues delegate:self];

        return YES;
    }

    return NO;
}

@end
