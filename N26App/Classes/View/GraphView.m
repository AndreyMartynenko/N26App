//
//  GraphView.m
//  N26App
//
//  Created by Andrey Martynenko on 9/25/16.
//
//

#import "GraphView.h"

static NSInteger const offsetX = 100;
static NSInteger const offsetY = 15;
static NSInteger const stepX = 25;
static NSInteger const circleRadius = 3;
static NSInteger const touchRadius = 10;

@interface GraphView ()

@property (nonatomic, weak) id<GraphViewDelegate> delegate;

@property (nonatomic, assign) CGFloat maxValue;
@property (nonatomic, assign) CGFloat minValue;
@property (nonatomic, assign) BOOL shouldUpdate;
@property (nonatomic, assign) BOOL shouldResetDescriptionLabel;

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) NSArray *verticalAxisValues;
@property (nonatomic, strong) NSArray *normalizedValues;
@property (nonatomic, strong) NSArray *normalizedVerticalAxisValues;

@property (nonatomic, strong) NSArray *touchAreas;

@property (nonatomic, strong) UILabel *descriptionLabel;

@property (nonatomic, strong) NSDictionary *axisAttributes;
@property (nonatomic, strong) NSDictionary *labelAttributes;

@end

@implementation GraphView

- (void)updateContentWithValues:(NSArray *)values delegate:(id<GraphViewDelegate>)delegate {
    self.delegate = delegate;
    self.shouldUpdate = YES;
    self.shouldResetDescriptionLabel = YES;

    [self setupWithValues:values];
    [self setNeedsDisplay];
}

- (void)setupWithValues:(NSArray *)values {
    CGFloat maxValue = [[values valueForKeyPath:@"@max.floatValue"] floatValue];
    CGFloat minValue = [[values valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat offset = (maxValue - minValue) / 10;

    CGFloat verticalAxisMaxValue = maxValue + offset;
    CGFloat verticalAxisMinValue = (minValue - offset) > 0 ? (minValue - offset) : 0;

    NSMutableArray *verticalAxisValues = [NSMutableArray array];
    [verticalAxisValues addObject:[NSNumber numberWithFloat:verticalAxisMaxValue]];
    [verticalAxisValues addObject:[NSNumber numberWithFloat:verticalAxisMaxValue - (verticalAxisMaxValue - verticalAxisMinValue) / 4]];
    [verticalAxisValues addObject:[NSNumber numberWithFloat:maxValue - (maxValue - minValue) / 2]];
    [verticalAxisValues addObject:[NSNumber numberWithFloat:verticalAxisMinValue + (verticalAxisMaxValue - verticalAxisMinValue) / 4]];
    [verticalAxisValues addObject:[NSNumber numberWithFloat:verticalAxisMinValue]];

    self.maxValue = [[verticalAxisValues valueForKeyPath:@"@max.floatValue"] floatValue];
    self.minValue = [[verticalAxisValues valueForKeyPath:@"@min.floatValue"] floatValue];

    self.verticalAxisValues = verticalAxisValues;
    self.values = values;

    // Normalization of values for drawing
    NSMutableArray *normalizedVerticalAxisValues = [NSMutableArray array];
    for (NSNumber *value in self.verticalAxisValues) {
        [normalizedVerticalAxisValues addObject:[self normalizeValue:value]];
    }
    self.normalizedVerticalAxisValues = normalizedVerticalAxisValues;

    NSMutableArray *normalizedValues = [NSMutableArray array];
    for (NSNumber *value in self.values) {
        [normalizedValues addObject:[self normalizeValue:value]];
    }
    self.normalizedValues = normalizedValues;

    // Description label setup
    if (!self.descriptionLabel) {
        self.descriptionLabel = [UILabel new];
        self.descriptionLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        [self addSubview:self.descriptionLabel];
    }
    self.descriptionLabel.hidden = YES;

    // Font attribues
    self.axisAttributes = @{ NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:15] };
    self.labelAttributes = @{ NSFontAttributeName:self.descriptionLabel.font };
}

- (void)drawRect:(CGRect)rect {
    if (!self.shouldUpdate) {
        return;
    }

    CGContextRef context = UIGraphicsGetCurrentContext();

    [self drawVerticalAxisWithContext:context];
    [self drawLineGraphWithContext:context];

    self.shouldUpdate = NO;
}

- (void)drawLineGraphWithContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:1.0f] CGColor]);

    // Path
    CGContextBeginPath(context);

    CGContextMoveToPoint(context, offsetX, [self getOffsetYForValue:self.normalizedValues[0]]);
    for (NSInteger idx = 1; idx < self.normalizedValues.count; idx++) {
        CGContextAddLineToPoint(context, offsetX + idx * stepX, [self getOffsetYForValue:self.normalizedValues[idx]]);
    }

    CGContextDrawPath(context, kCGPathStroke);

    // Dots & touches
    NSMutableArray *touchAreas = [NSMutableArray arrayWithCapacity:self.normalizedValues.count];
    CGContextBeginPath(context);

    for (NSInteger idx = 0; idx < self.normalizedValues.count; idx++) {
        float x = offsetX + idx * stepX;
        float y = [self getOffsetYForValue:self.normalizedValues[idx]];

        CGRect rect = CGRectMake(x - circleRadius, y - circleRadius, circleRadius * 2, circleRadius * 2);
        CGContextAddEllipseInRect(context, rect);

        [touchAreas addObject:[NSValue valueWithCGRect:CGRectMake(x - touchRadius, y - touchRadius, touchRadius * 2, touchRadius * 2)]];
    }
    self.touchAreas = touchAreas;

    CGContextDrawPath(context, kCGPathFillStroke);

    // Fill
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:1.0f green:0.5f blue:0.0f alpha:0.5f] CGColor]);
    CGContextBeginPath(context);

    CGContextMoveToPoint(context, offsetX, CGRectGetHeight(self.frame) - offsetY);
    CGContextAddLineToPoint(context, offsetX, [self getOffsetYForValue:self.normalizedValues[0]]);
    for (NSInteger idx = 1; idx < self.normalizedValues.count; idx++) {
        CGContextAddLineToPoint(context, offsetX + idx * stepX, [self getOffsetYForValue:self.normalizedValues[idx]]);
    }
    CGContextAddLineToPoint(context, offsetX + (self.normalizedValues.count - 1) * stepX, CGRectGetHeight(self.frame) - offsetY);
    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFill);
}

- (void)drawVerticalAxisWithContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);

    for (NSInteger idx = 0; idx < self.normalizedVerticalAxisValues.count; idx++) {
        // Label
        CGPoint position = CGPointMake(10, [self getOffsetYForValue:self.normalizedVerticalAxisValues[idx]]);
        NSString *value = [NSString stringWithFormat:@"€ %.2f", [self.verticalAxisValues[idx] floatValue]];
        [self drawTextWithContext:context position:position value:value];

        // Line
        CGContextMoveToPoint(context, offsetX, [self getOffsetYForValue:self.normalizedVerticalAxisValues[idx]]);
        CGContextAddLineToPoint(context, CGRectGetWidth(self.frame) - stepX, [self getOffsetYForValue:self.normalizedVerticalAxisValues[idx]]);
    }

    CGContextStrokePath(context);
    CGContextSetLineDash(context, 0, NULL, 0);
}

- (void)drawTextWithContext:(CGContextRef)context position:(CGPoint)position value:(NSString *)value {
    CGContextSetTextDrawingMode(context, kCGTextFill);
    [[UIColor blackColor] setFill];

    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:@" " attributes:self.axisAttributes];
    CGFloat textHeightOffset = attributedString.size.height / 2;

    [value drawAtPoint:CGPointMake(position.x, position.y - textHeightOffset) withAttributes:self.axisAttributes];
}

#pragma mark - Helpers

- (CGFloat)getOffsetYForValue:(NSNumber *)value {
    CGFloat maxGraphHeight = CGRectGetHeight(self.frame) - offsetY * 2;

    return CGRectGetHeight(self.frame) - maxGraphHeight * [value floatValue] - offsetY;
}

- (NSNumber *)normalizeValue:(NSNumber *)value {
    CGFloat normalizedValue = ([value floatValue] - self.minValue) / (self.maxValue - self.minValue);

    return [NSNumber numberWithFloat:normalizedValue];
}

#pragma mark - Interaction

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static NSInteger oldIndex = -1;

    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];

    for (NSInteger idx = 0; idx < self.touchAreas.count; idx++) {
        if (CGRectContainsPoint([self.touchAreas[idx] CGRectValue], point)) {
            if (idx == oldIndex && !self.shouldResetDescriptionLabel) {
                self.descriptionLabel.hidden = !self.descriptionLabel.hidden;
                return;
            }

            oldIndex = idx;
            self.shouldResetDescriptionLabel = NO;
            self.descriptionLabel.hidden = NO;

            self.descriptionLabel.text = [NSString stringWithFormat:@"€ %.2f", [self.values[idx] floatValue]];

            CGSize newSize = [self.descriptionLabel.text sizeWithAttributes:self.labelAttributes];
            CGRect frame = [self.touchAreas[idx] CGRectValue];
            frame.origin.x = frame.origin.x + frame.size.width / 2 - newSize.width / 2;
            frame.origin.y = frame.origin.y + frame.size.height / 2 - newSize.height / 2 - offsetY;
            frame.size = newSize;
            self.descriptionLabel.frame = frame;

            break;
        }
    }
}

- (void)checkTouchAreaAt:(CGPoint)point {
    for (NSInteger idx = 0; idx < self.touchAreas.count; idx++) {
        if (CGRectContainsPoint([self.touchAreas[idx] CGRectValue], point)) {
            [self.delegate updateGraphViewValueAt:idx];
            
            break;
        }
    }
}

@end
