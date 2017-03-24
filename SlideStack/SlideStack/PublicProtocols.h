//
//  PublicProtocols.h
//  SlideStack
//
//  Created by VCS on 3/24/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#ifndef PublicProtocols_h
#define PublicProtocols_h


#endif /* PublicProtocols_h */

@class SlideCell;

@protocol SlideCellDelegate

-(void) onTap:(SlideCell*) cell;
-(void) drag:(UIPanGestureRecognizer*) drag onCell:(SlideCell*)cell;

@end
