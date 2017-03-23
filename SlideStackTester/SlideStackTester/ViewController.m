//
//  ViewController.m
//  SlideStackTester
//
//  Created by Ivaylo Iliev on 3/22/17.
//  Copyright © 2017 Nemetschek. All rights reserved.
//

#import "ViewController.h"
#import <SlideStack/SlideStack.h>

@interface ViewController ()

@property (strong, nonatomic) SlideStackController *slideStack;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.slideStack = [[SlideStackController alloc] init];
    [self.view addSubview:self.slideStack.view];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
