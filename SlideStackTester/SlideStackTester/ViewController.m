//
//  ViewController.m
//  SlideStackTester
//
//  Created by Ivaylo Iliev on 3/22/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "ViewController.h"
#import <SlideStack/SlideStack.h>
#import <SlideStack/SlideCell.h>

@interface ViewController ()

@property (strong, nonatomic) SlideStackController *slideStack;
@property NSInteger colorSaturation;
@property NSInteger count;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *plusImage = [UIImage imageNamed:@"plus" inBundle:[NSBundle bundleWithIdentifier:@"net.nemetschek.SlideStack"] compatibleWithTraitCollection:nil];
    UIImage *minusImage = [UIImage imageNamed:@"minus" inBundle:[NSBundle bundleWithIdentifier:@"net.nemetschek.SlideStack"] compatibleWithTraitCollection:nil];
    
    _colorSaturation = 200;

    self.slideStack = [[SlideStackController alloc] init];
    [self.view addSubview:self.slideStack.view];

    self.slideStack.cellMargin = -15;
    SlideCell *cell2;

    cell2 = [SlideCell getCell:^{
        SlideCell *cell3 = [SlideCell getCell:nil];
        [cell3 setBlock:^{
            [self.slideStack removeSlideCell:cell3];
        }];
        
        cell3.delegate = self.slideStack;
        [cell3 setImage:minusImage];
        [cell3 setTitle:[NSString stringWithFormat:@"Cell %li",(long)_count]];
        [cell3 setColor:[UIColor colorWithRed:0/255.0 green:_colorSaturation/255.0 blue:_colorSaturation/255.0 alpha:1]];
        _count++;
        if(_colorSaturation >= 255)
        {
            _colorSaturation = 200;
        }
        _colorSaturation += 20;
        
        [self.slideStack addSlideCell:cell3 atIndex:3];
    }];
    
    SlideCell *cell1 = [SlideCell getCell:^{
        [self.slideStack removeSlideCellAtIndex:1];
    }];
    cell1.delegate = self.slideStack;
    
    [cell1 setTitle:@"CELL 1"];
    [self.slideStack addSlideCell:cell1];
    [cell1 setColor:[UIColor colorWithRed:0/255.0 green:_colorSaturation/255.0 blue:_colorSaturation/255.0 alpha:1]];
    
    cell2.delegate = self.slideStack;
    [cell2 setImage:plusImage];
    [cell2 setTitle:@"CELL 2"];
    [self.slideStack addSlideCell:cell2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
