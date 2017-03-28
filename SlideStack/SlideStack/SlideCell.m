//
//  SlideCell.m
//  SlideStack
//
//  Created by Nemetschek A-Team on 3/23/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "SlideCell.h"
#import "Defines.h"

@interface SlideCell ()

 @property void (^cellFunctionality)(void);


@end

@implementation SlideCell

+(SlideCell *)getCell:(void (^)(void))cellFunctionality
{
    SlideCell* newCell = [[[NSBundle bundleWithIdentifier:BUNDLE_ID_STRING] loadNibNamed:@"SlideCell" owner:self options:nil] firstObject];
    
    newCell.cellState = CELL_STATE_COLAPSED;
    newCell.cellFunctionality = cellFunctionality;
    
    newCell.backgroundColor = [UIColor clearColor];
    newCell.cellColor = [UIColor grayColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:newCell
                                   action:@selector(tapped:)];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]
                                             initWithTarget:newCell
                                             action:@selector(dragged:)];
    
    [newCell addGestureRecognizer:tap];
    [newCell addGestureRecognizer:panRecognizer];
    return newCell;
}

-(void) tapped:(UITapGestureRecognizer*)tap
{
    [self.delegate onTap:self];
}

-(void)dragged:(UIPanGestureRecognizer*)drag
{
     [self.delegate drag:drag onCell:self];
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *trianglePath = [self drawTrianglePath:rect];
    CGFloat red, green, blue, alpha;
    [self.cellColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [[UIColor colorWithRed:red green:green blue:blue alpha:0.8] setFill];
    [trianglePath fill];
    
    UIBezierPath *bodyPath = [self drawBodyPath:rect];
    [[UIColor colorWithWhite:WHITE_COLOR alpha:ALPHA_COLOR] setFill];
    [bodyPath fill];
    
    [self addSubview:[self getGradientView:rect]];
}

-(UIBezierPath*) drawTrianglePath:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_OFFSET,0)];
    [path addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_OFFSET, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_MID_POINT, rect.size.height/2)];
    [path closePath];
    return path;
}

-(UIBezierPath*) drawBodyPath:(CGRect)rect
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(rect.size.width/4,0)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, 0)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_MID_POINT, rect.size.height/2)];
    [path addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, rect.size.height)];
    [path addLineToPoint:CGPointMake(rect.size.width/4, rect.size.height)];
    [path closePath];
    return path;
}

-(UIView*) getGradientView:(CGRect)rect
{
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    CGRect gradientFrame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width/4, rect.size.height);
    UIView *gradientView = [[UIView alloc] initWithFrame:gradientFrame];
    gradientMask.frame = gradientFrame;
    gradientMask.startPoint = CGPointMake(1, 0);
    gradientMask.endPoint = CGPointMake(0, 0);
    gradientMask.colors = @[(id)[UIColor colorWithWhite:WHITE_COLOR alpha:ALPHA_COLOR].CGColor,(id)self.cellColor.CGColor];
    [gradientView.layer addSublayer:gradientMask];
    return gradientView;
}

-(void) setDescription:(NSString *)description
{
    [self.descriptionTextView setText:description];
}

-(void) setTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

-(void)executeCellFunctionality
{
    if (self.cellFunctionality == nil)
    {
        return;
    }
    self.cellFunctionality();
}

-(void) setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}

-(void)setColor:(UIColor *)color
{
    _cellColor = color;
}
@end
