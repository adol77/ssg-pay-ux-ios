//
//  ViewController.m
//  indoormap-sample
//
//  Created by Lee muhyeon on 2015. 8. 20..
//  Copyright (c) 2015년 ssg. All rights reserved.
//

#import "ViewController.h"
#import "SSGMapView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:[[SSGMapView alloc] initWithMapData:nil]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
