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

// @property (nonatomic, copy, nullability) returnType (^blockName)(parameterTypes);


@end

@implementation SlideCell

+(SlideCell *)getCell
{
    SlideCell* newCell = [[[NSBundle bundleWithIdentifier:BUNDLE_ID_STRING] loadNibNamed:@"SlideCell" owner:self options:nil] firstObject];
    newCell.cellState = CELL_STATE_COLAPSED;
    
    [newCell.heightAnchor constraintEqualToConstant:100].active = true;
    [newCell.widthAnchor constraintEqualToConstant:300].active = true;
    
    newCell.backgroundColor = [UIColor clearColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:newCell
                                   action:@selector(tapped:)];

    [newCell addGestureRecognizer:tap];
    return newCell;
}

-(void) tapped:(UITapGestureRecognizer*)tap
{
    [self.delegate onTap:self];
}

-(void)drawRect:(CGRect)rect
{
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    [trianglePath moveToPoint:CGPointMake(rect.size.width / 1.6, 0)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width/1.1,0)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width, rect.size.height/2)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width/1.1, rect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width/1.6, rect.size.height)];
    [trianglePath addLineToPoint:CGPointMake(rect.size.width/1.4, rect.size.height/2)];
    [trianglePath closePath];
    [[UIColor blackColor] setFill];
    [trianglePath fill];
    
    UIBezierPath *bodyPath = [UIBezierPath bezierPath];
    [bodyPath moveToPoint:CGPointMake(0,0)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width / 1.6, 0)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width/1.4, rect.size.height/2)];
    [bodyPath addLineToPoint:CGPointMake(rect.size.width/1.6, rect.size.height)];
    [bodyPath addLineToPoint:CGPointMake(0, rect.size.height)];
    [bodyPath closePath];
    [[UIColor colorWithWhite:0.1 alpha:0.8] setFill];
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

-(void) setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}
@end
