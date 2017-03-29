//
//  SlideStackController.m
//  SlideStack
//
//  Created by Nemetschek A-Team on 3/23/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "SlideStackController.h"
#import "SlideCell.h"
#import "Defines.h"

@interface SlideStackController ()
@property NSMutableArray *cellList;
@end

@implementation SlideStackController

-(instancetype)init
{
    self = [super initWithNibName:@"SlideStackController" bundle:[NSBundle bundleWithIdentifier:BUNDLE_ID_STRING]];
    if (self)
    {
        self.cellList = [[NSMutableArray alloc] init];
        self.view.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}

-(void)setMargin:(NSInteger)margin
{
    self.cellMargin = margin;
}

-(void) addSlideCell:(SlideCell*)newCell
{
    [self addSlideCell:newCell atIndex:0];
}

-(void) addSlideCell:(SlideCell*)newCell atIndex:(NSInteger)index;
{
    if(index > [self.cellList count])
    {
        [self.cellList addObject:newCell];
    }
    else
    {
        [self.cellList insertObject:newCell atIndex:index];
    }
    [self resizeView];
    [self setFrameForAnimation:newCell];
    [self rearangeCells];
    [self.view addSubview:newCell];
}

-(void) removeSlideCell:(SlideCell *)cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    [self removeSlideCellAtIndex:cellIndex];
}

-(void) removeSlideCellAtIndex:(NSInteger)index
{
    SlideCell *cell = [self.cellList objectAtIndex:index];
    [self removeCellAnimation:cell];
    [self.cellList removeObject:cell];
    [self resizeView];
    [self rearangeCells];
}

-(void) setCellProperties:(SlideCell*)cell withColor:(UIColor*) cellColor
{
    if(cellColor && cell)
    {
        [cell setColor:cellColor];
    }
}

-(void) setCellPropertiesAtIndex:(NSInteger)index withColor:(UIColor *)cellColor
{
    SlideCell *cell = [self.cellList objectAtIndex:index];
    if(cellColor && cell)
    {
        [cell setColor:cellColor];
    }
}

-(void) setControllerProperties:(NSInteger) margin
{
    if(margin)
    {
        self.cellMargin = margin;
    }
}

#pragma mark DELEGATES

-(void)onTap:(SlideCell *)cell
{
    CGRect bounceFrame = CGRectMake(BOUNCE_PULL_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
    
    [UIView animateWithDuration:0.1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         cell.frame = bounceFrame;
         [self moveNeighbouringCells:cell];
     }
                     completion:^(BOOL finished) {
                         [self rearangeCells];
                     }];
}

-(void)drag:(UIPanGestureRecognizer *)drag onCell:(SlideCell *)cell
{
    if(drag.state == UIGestureRecognizerStateBegan)
    {
        cell.pointerStartDragCoordinatesX = [drag locationInView:cell.window].x;
        cell.cellStartDragCoordinatesX = cell.frame.origin.x;
        [self moveNeighbouringCells:cell];
    }
    float currentPointerDistance = [drag locationInView:cell.window].x - cell.pointerStartDragCoordinatesX;
    CGFloat offSet = cell.cellStartDragCoordinatesX + currentPointerDistance;
    if(currentPointerDistance >= CELL_DRAG_TOLARANCE)
    {
        offSet = cell.cellStartDragCoordinatesX + CELL_DRAG_TOLARANCE;
    }
    cell.frame = CGRectMake(offSet,cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
    if(drag.state == UIGestureRecognizerStateEnded)
    {
        [self collapseCell:cell completion:^(BOOL finished) {
            if(currentPointerDistance >= CELL_DRAG_TOLARANCE)
            {
                [self executeCellAction:cell];
            }
            [self rearangeCells];
        }];
    }
}

#pragma mark Private

-(void)resizeView
{
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    NSInteger cellsCount = [[self cellList] count];
    CGFloat frameWidth = CELL_WIDTH - COLAPSE_DISTANCE;
    CGFloat frameHeight = cellsCount *(CELL_HEIGHT + self.cellMargin) - self.cellMargin;
    CGFloat x = 0;
    CGFloat y = screenHeight - VIEW_BOTTOM_MARGIN - frameHeight;
    CGRect newFrame = CGRectMake(x,y,frameWidth,frameHeight);
    self.view.frame = newFrame;
}

-(void) executeCellAction:(SlideCell*)cell
{
    [cell executeCellFunctionality];
}

-(void)collapseCell:(SlideCell*)cell
{
    [self collapseCell:cell completion:nil];
}

-(void)collapseCell:(SlideCell*)cell completion:(void (^ __nullable)(BOOL finished))completion
{
    cell.cellState = CELL_STATE_COLAPSED;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         [self refreshCell:cell];
     }
                    completion:completion];
}

-(void) refreshCell:(SlideCell*) cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    CGRect newFrame = CGRectMake(-COLAPSE_DISTANCE,
                                 self.view.frame.size.height - cellIndex * (CELL_HEIGHT + self.cellMargin) - CELL_HEIGHT,
                                 CELL_WIDTH,
                                 CELL_HEIGHT);
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveLinear
                     animations:^
     {
         cell.frame = newFrame;
     }
                     completion:nil];

    cell.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
}

-(void) rearangeCells
{
    for (SlideCell* cell in self.cellList) {
        [self refreshCell:cell];
        [self.view bringSubviewToFront:cell];
    }
}

-(void) moveNeighbouringCells:(SlideCell*) cell
{
    NSInteger index = [[self cellList] indexOfObject:cell];
    if(index > 0)
    {
        [self moveCellDown:[[self cellList] objectAtIndex:index-1]];
    }
    if(index < [self.cellList count] - 1)
    {
        [self moveCellUp:[[self cellList] objectAtIndex:index+1]];
    }
}

-(void) moveCellUp:(SlideCell*)cell
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.frame = CGRectMake(cell.frame.origin.x,cell.frame.origin.y - CELL_MOVING_DISTANCE_UP, cell.frame.size.width , cell.frame.size.height - CELL_MOVING_DISTANCE_UP);
                     }
                     completion:nil];
}

-(void) moveCellDown:(SlideCell*)cell
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         cell.frame = CGRectMake(cell.frame.origin.x,cell.frame.origin.y + CELL_MOVING_DISTANCE_DOWN, cell.frame.size.width , cell.frame.size.height - CELL_MOVING_DISTANCE_DOWN);
                     }
                     completion:nil];
}

#pragma mark Animations

-(void) setFrameForAnimation:(SlideCell*)cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    CGRect newFrame = CGRectMake(-1 * CELL_WIDTH,
                                 self.view.frame.size.height - cellIndex * (CELL_HEIGHT + self.cellMargin) - CELL_HEIGHT,
                                 CELL_WIDTH,
                                 CELL_HEIGHT);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveLinear
                     animations:^
     {
         cell.frame = newFrame;
     }
                     completion:nil];
    
}

-(void) removeCellAnimation:(SlideCell*) cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    
    CGRect newFrame = CGRectMake(-1 * CELL_WIDTH,
                                 self.view.frame.size.height - cellIndex * (CELL_HEIGHT + self.cellMargin) - CELL_HEIGHT,
                                 CELL_WIDTH,
                                 CELL_HEIGHT);
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         cell.frame = newFrame;
     }
                     completion:^(BOOL finished) {
                         [cell removeFromSuperview];
                     }];
}

@end
