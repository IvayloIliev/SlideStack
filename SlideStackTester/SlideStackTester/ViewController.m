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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.slideStack = [[SlideStackController alloc] init];
    [self.view addSubview:self.slideStack.view];
    
    [self.slideStack setMargin:-15];
    
    SlideCell *cell1 = [SlideCell getCell:^{
        NSLog(@"CELL 1");
    }];
    cell1.delegate = self.slideStack;
    [cell1 setTitle:@"CELL 1"];
    [self.slideStack addSlideCell:cell1];
    
    UIColor *cyan = [UIColor colorWithRed:0/255.0 green:204/255.0 blue:204/255.0 alpha:1];
    
    cell1.cellColor = cyan;
    
    SlideCell *cell2 = [SlideCell getCell:^{
        
    SlideCell *cell3 = [SlideCell getCell:^{
            NSLog(@"CELL 3");
    }];
    cell3.delegate = self.slideStack;
    [cell3 setTitle:@"CELL 3"];
    [self.slideStack addSlideCell:cell3 atIndex:0];

    }];
    cell2.delegate = self.slideStack;
    [cell2 setTitle:@"CELL 2"];
    [self.slideStack addSlideCell:cell2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
