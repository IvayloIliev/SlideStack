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
        self.cellList = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SlideCell *cell1 = [SlideCell getCell];
    cell1.delegate = self;
    [cell1 setTitle:@"CELL 1"];
    [self addSlideCell:cell1];

    SlideCell *cell2 = [SlideCell getCell];
    cell2.delegate = self;
    [cell2 setTitle:@"CELL 2"];
    [self addSlideCell:cell2];
    
    SlideCell *cell3 = [SlideCell getCell];
    cell3.delegate = self;
    [cell3 setTitle:@"CELL 3"];
    [self addSlideCell:cell3];
}

-(void) addSlideCell:(SlideCell*)newCell
{
    [self.cellList addObject:newCell];
    [self.view addSubview:newCell];
    [self formatCell:newCell];
}

-(void)formatCell:(SlideCell*)newCell
{
    int a = START_TOP_MARGIN +((self.cellList.count+1) * CELL_HEIGHT);
    CGRect newFrame = CGRectMake(newCell.frame.origin.x + COLAPSE_DISTANCE,
                                 START_TOP_MARGIN +((self.cellList.count) * CELL_HEIGHT)
                                 ,newCell.frame.size.width , newCell.frame.size.height);
    newCell.frame = newFrame;
    newCell.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma DELEGATES
-(void)onTap:(SlideCell *)cell
{
    if(cell.cellState == CELL_STATE_COLAPSED)
    {
        [self expandCell:cell];
    }
    else if(cell.cellState == CELL_STATE_EXPANDED)
    {
        [self collapseCell:cell];
    }
}

-(void)drag:(UIPanGestureRecognizer *)drag onCell:(SlideCell *)cell
{
    if(drag.state == UIGestureRecognizerStateBegan)
    {
        cell.pointerStartDragCoordinatesX = [drag locationInView:cell.window].x;
        cell.cellStartDragCoordinatesX = cell.frame.origin.x;
    }
    
    float currentPointerDistance = [drag locationInView:cell.window].x - cell.pointerStartDragCoordinatesX;
    CGRect collapsedFrame = CGRectMake(cell.cellStartDragCoordinatesX + currentPointerDistance,
                                       cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
    cell.frame = collapsedFrame;
    
    if(drag.state == UIGestureRecognizerStateEnded)
    {
        if(currentPointerDistance >= CELL_DRAG_TOLARANCE)
        {
            [self expandCell:cell];
        }
        else
        {
            [self collapseCell:cell];
        }
    }
}
#pragma END DELEGATES


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
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseOut
                     animations:^
     {
         CGRect collapsedFrame = CGRectMake(COLAPSE_DISTANCE, cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);

         cell.frame = collapsedFrame;
     }
                    completion:nil];
}

-(void)expandCell:(SlideCell*)cell
{
    [self collapseAllCells];
    cell.cellState = CELL_STATE_EXPANDED;
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationCurveEaseOut
                     animations:^
     {
         CGRect collapsedFrame = CGRectMake(0 , cell.frame.origin.y, cell.frame.size.width , cell.frame.size.height);
         
         cell.frame = collapsedFrame;
     }
                     completion:nil];
}

@end
