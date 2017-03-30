//
//  SlideStackController.h
//  SlideStack
//
//  Created by Nemetschek A-Team on 3/23/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicProtocols.h"

@interface SlideStackController : UIViewController<SlideCellDelegate>

@property NSInteger cellMargin;

- (void)addSlideCell:(SlideCell *)newCell;
- (void)addSlideCell:(SlideCell *)newCell atIndex:(NSInteger)index;
- (void)removeSlideCell:(SlideCell *)cell;
- (void)removeSlideCellAtIndex:(NSInteger)index;
- (void)setCellProperties:(SlideCell *)cell withColor:(UIColor *) cellColor;
- (void)setCellPropertiesAtIndex:(NSInteger)index withColor:(UIColor *) cellColor;
- (void)setControllerProperties:(NSInteger) margin;

@end
