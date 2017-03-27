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

@property NSInteger *cellMargin;

//Use negetive values for overlap
-(void) setMargin:(NSInteger*) margin;

@end
