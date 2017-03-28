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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark PUBLIC

-(void)setMargin:(NSInteger)margin
{
    self.cellMargin = margin;
}

-(void) addSlideCell:(SlideCell*)newCell
{
    [self.cellList insertObject:newCell atIndex:0];
    [self rearangeCells:newCell];
    [self.view addSubview:newCell];
    [self collapseCell:newCell];
}

-(void) addSlideCell:(SlideCell*)newCell atIndex:(NSInteger)index;
{
    [self.cellList insertObject:newCell atIndex:index];
    [self rearangeCells:newCell];
    [self.view addSubview:newCell];
    [self collapseCell:newCell];
}

-(void) removeSlideCell:(SlideCell *)cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    
    for (NSInteger i = cellIndex; i < self.cellList.count; i++) {
        [self pullCellDown: [self.cellList objectAtIndex:i]];
    }
    [self removeCellAnimation:cell];
}

-(void) removeSlideCellAtIndex:(NSInteger)index
{
    SlideCell *cell = [self.cellList objectAtIndex:index];
    
    for (NSInteger i = index; i < self.cellList.count; i++) {
        [self pullCellDown: [self.cellList objectAtIndex:i]];
    }
    [self removeCellAnimation:cell];
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

#pragma mark PRIVATE

-(void) pullCellUp:(SlideCell*) cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    CGRect newFrame = CGRectMake(-1 * COLAPSE_DISTANCE,
                                 self.view.frame.size.height - (START_TOP_MARGIN + (cellIndex * CELL_HEIGHT) + ((long)self.cellMargin*cellIndex)),
                                 cell.frame.size.width,
                                 cell.frame.size.height);
    
    cell.cellState = CELL_STATE_COLAPSED;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
                     cell.frame = newFrame;
     }
                     completion:nil];
    
    cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

-(void) pullCellDown:(SlideCell*) cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell] - 1;
    
    CGRect newFrame = CGRectMake(-1 * COLAPSE_DISTANCE,
                                 self.view.frame.size.height -(START_TOP_MARGIN + (cellIndex * CELL_HEIGHT) + ((long)self.cellMargin*cellIndex)),
                                 cell.frame.size.width,
                                 cell.frame.size.height);
    
    cell.cellState = CELL_STATE_COLAPSED;
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationCurveEaseOut
                     animations:^
     {
         cell.frame = newFrame;
     }
                     completion:nil];
    
    cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

-(void) removeCellAnimation:(SlideCell*) cell
{
    NSInteger cellIndex = [self.cellList indexOfObject:cell];
    
    CGRect newFrame = CGRectMake(-300,
                                 self.view.frame.size.height - (START_TOP_MARGIN + (cellIndex * CELL_HEIGHT) + ((long)self.cellMargin*cellIndex)),
                                 cell.frame.size.width,
                                 cell.frame.size.height);
    
    [UIView animateWithDuration:0.5
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         cell.frame = newFrame;
     }
                     completion:^(BOOL finished) {
                         [cell removeFromSuperview];
                         [self.cellList removeObject:cell];
                     }];
}



#pragma mark DELEGATES

-(void)onTap:(SlideCell *)cell
{
    CGRect bounceFrame = CGRectMake(BOUNCE_PULL_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         cell.frame = bounceFrame;
     }
                     completion:^(BOOL finished) {
                         [self collapseCell:cell];
                     }];
}

-(void)drag:(UIPanGestureRecognizer *)drag onCell:(SlideCell *)cell
{
    if(drag.state == UIGestureRecognizerStateBegan)
    {
        cell.pointerStartDragCoordinatesX = [drag locationInView:cell.window].x;
        cell.cellStartDragCoordinatesX = cell.frame.origin.x;
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
        }];
    }
}

#pragma mark END DELEGATES

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
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect collapsedFrame = CGRectMake(-COLAPSE_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);

         cell.frame = collapsedFrame;
     }
                    completion:completion];
}

-(void) rearangeCells:(SlideCell*) cell
{
    NSInteger index = [self.cellList indexOfObject:cell];
    
    for (NSInteger i = index + 1; i < self.cellList.count; i++) {
        [self pullCellUp: [self.cellList objectAtIndex:i]];
    }
    
    NSInteger cellIndex = index;
    CGRect newFrame = CGRectMake(-300,
                                 self.view.frame.size.height -(START_TOP_MARGIN + (cellIndex * CELL_HEIGHT) + ((long)self.cellMargin*cellIndex)),
                                 cell.frame.size.width,
                                 cell.frame.size.height);
    cell.frame = newFrame;
    cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

@end
