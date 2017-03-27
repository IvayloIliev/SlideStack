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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)setMargin:(NSInteger)margin
{
    self.cellMargin = margin;
}

-(void) addSlideCell:(SlideCell*)newCell
{
    [self.cellList addObject:newCell];
    [self.view addSubview:newCell];
    [self formatCell:newCell];
}

-(void) addSlideCell:(SlideCell*)newCell atIndex:(NSInteger*)index;
{
    [self.cellList insertObject:newCell atIndex:index];
    [self.view addSubview:newCell];
    [self refresh];
}

-(void) removeSlideCell:(SlideCell *)cell
{
    [cell removeFromSuperview];
    [self.cellList removeObject:cell];
    [self refresh];
}

-(void) removeSlideCellAtIndex:(NSInteger *)index
{
    [[self.cellList objectAtIndex:index] removeFromSuperview];
    [self.cellList removeObjectAtIndex:index];
    [self refresh];
}

-(void) setCellProperties:(UIColor *)cellColor withMargin:(NSInteger *)margin
{
    //redraw all
}


#pragma ----------PRIVATE------------

-(void)formatCell:(SlideCell*)cell
{
    NSInteger naturalCellIndex = [self.cellList indexOfObject:cell] + 1;
    CGRect newFrame = CGRectMake(COLAPSE_DISTANCE,
                                 START_TOP_MARGIN + (naturalCellIndex * CELL_HEIGHT) + ((long)self.cellMargin*naturalCellIndex),
                                 cell.frame.size.width,
                                 cell.frame.size.height);
    cell.frame = newFrame;
    cell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    NSLog(@"cell :%@ frame: %@", cell.titleLabel.text, [NSValue valueWithCGRect:newFrame]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark DELEGATES
-(void)onTap:(SlideCell *)cell
{
    CGRect collapsedFrame = CGRectMake(BOUNCE_PULL_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
    
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationCurveEaseOut
                     animations:^
     {
         cell.frame = collapsedFrame;
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
        if(currentPointerDistance >= CELL_DRAG_TOLARANCE)
        {
             [self executeCellAction:cell];
        }
        [self collapseCell:cell];
    }
}
#pragma mark END DELEGATES

-(void) executeCellAction:(SlideCell*)cell
{
    cell.executeCellFunctionality;
}

-(void)collapseAllCells
{
    for (SlideCell *cell in self.cellList) {
        if(cell.cellState == CELL_STATE_EXPANDED)
        {
            [self collapseCell:cell];
        }
    }
}

-(void)collapseCell:(SlideCell*)cell
{
    cell.cellState = CELL_STATE_COLAPSED;
    [UIView animateWithDuration:0.3
                          delay:0
         usingSpringWithDamping:1
          initialSpringVelocity:0.5
                        options: UIViewAnimationCurveEaseOut
                     animations:^
     {
         CGRect collapsedFrame = CGRectMake(-COLAPSE_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);

         cell.frame = collapsedFrame;
     }
                    completion:nil];
}

-(void) refresh
{
    for (SlideCell* cell in self.cellList) {
        [self formatCell:cell];
    }
}
@end
