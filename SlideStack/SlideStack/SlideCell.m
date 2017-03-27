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
    
    [newCell.heightAnchor constraintEqualToConstant:100].active = true;
    [newCell.widthAnchor constraintEqualToConstant:300].active = true;
    
    newCell.backgroundColor = [UIColor clearColor];
    newCell.cellColor = [UIColor blackColor];
    
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
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    [trianglePath moveToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, 0)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width - ARROW_OFFSET,0)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width - ARROW_OFFSET, rect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, rect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width - ARROW_MID_POINT, rect.size.height/2)];
    [trianglePath closePath];
    [_cellColor setFill];
    [trianglePath fill];
    
    UIBezierPath *bodyPath = [UIBezierPath bezierPath];
    [bodyPath moveToPoint:CGPointMake(0,0)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, 0)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width - ARROW_MID_POINT, rect.size.height/2)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width - ARROW_WIDTH, rect.size.height)];
    [bodyPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [bodyPath closePath];
    [[UIColor colorWithWhite:WHITE_COLOR alpha:ALPHA_COLOR] setFill];
    [bodyPath fill];
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
