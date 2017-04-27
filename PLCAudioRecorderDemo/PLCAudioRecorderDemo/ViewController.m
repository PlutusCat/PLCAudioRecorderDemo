//
//  ViewController.m
//  PLCAudioRecorderDemo
//
//  Created by PlutusCat on 2017/4/25.
//  Copyright © 2017年 PlutusCat. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewController.h"
#import "PLCAudioRecorderView.h"

@interface ViewController ()
@property (nonatomic, strong) MainTableViewController *mainTableViewVC;
@property (nonatomic, strong) PLCAudioRecorderView *recorderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    MainTableViewController *mainTableViewVC = [[MainTableViewController alloc] init];
    [self addChildViewController:mainTableViewVC];
    [self.view addSubview:mainTableViewVC.view];
    [mainTableViewVC didMoveToParentViewController:self];
    self.mainTableViewVC = mainTableViewVC;
    
    
    PLCAudioRecorderView *recorderView = [[PLCAudioRecorderView alloc] init];
    [self.view addSubview:recorderView];
    self.recorderView = recorderView;
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.recorderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.mainTableViewVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.bottom.equalTo(self.recorderView.mas_top);
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
