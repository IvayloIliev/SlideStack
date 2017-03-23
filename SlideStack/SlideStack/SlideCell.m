//
//  SlideCell.m
//  SlideStack
//
//  Created by Nemetschek A-Team on 3/23/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "SlideCell.h"
#import "Defines.h"
@implementation SlideCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(SlideCell *)getCell
{
    SlideCell* myViewObject = [[[NSBundle bundleWithIdentifier:BUNDLE_ID_STRING] loadNibNamed:@"SlideCell" owner:self options:nil] firstObject];
    
    [myViewObject.heightAnchor constraintEqualToConstant:100].active = true;
    [myViewObject.widthAnchor constraintEqualToConstant:120].active = true;
    
    return myViewObject;
}
@end
