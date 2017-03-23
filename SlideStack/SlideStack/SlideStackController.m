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

@end

@implementation SlideStackController

-(instancetype)init
{
    self = [super initWithNibName:@"SlideStackController" bundle:[NSBundle bundleWithIdentifier:BUNDLE_ID_STRING]];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    SlideCell *cell1 = [SlideCell getCell];
    cell1.backgroundColor = [UIColor blueColor];
    
    SlideCell *cell2 = [SlideCell getCell];
    cell2.backgroundColor = [UIColor greenColor];
    
    SlideCell *cell3 = [SlideCell getCell];
    cell3.backgroundColor = [UIColor yellowColor];
    
    self.stackView.axis = UILayoutConstraintAxisVertical;
    self.stackView.distribution = UIStackViewDistributionEqualSpacing;
    self.stackView.alignment = UIStackViewAlignmentCenter;
    self.stackView.spacing = -80;
    
    SlideCell *cell4 = [SlideCell getCell];
    
    [self.stackView addArrangedSubview:cell1];
    [self.stackView addArrangedSubview:cell2];
    [self.stackView addArrangedSubview:cell3];
    [self.stackView addArrangedSubview:cell4];
    
    self.stackView.translatesAutoresizingMaskIntoConstraints = false;
    
    //Layout for Stack View
  
    [self.view addSubview:self.stackView];
    [self.stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
    [self.stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
