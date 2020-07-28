//
//  ViewController.m
//  OpenGLES0-01
//
//  Created by user on 2020/7/26.
//  Copyright © 2020 Mars. All rights reserved.
//

#import "ViewController.h"
#import "GLKViewController1.h"
#import "DSGLKViewController2.h"
#import "DSGLKViewController3.h"
#import "DSViewController4.h"
#import "DSViewController5.h"

@interface ViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSArray * dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];

}


#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = self.dataArr[indexPath.row];
//    cell.backgroundColor = [UIColor redColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            GLKViewController1 *vc1 = [[GLKViewController1 alloc] init];
            [self.navigationController pushViewController:vc1 animated:true];
        }
            break;
        case 1:
        {
            DSGLKViewController2 *vc2 = [[DSGLKViewController2 alloc] init];
            [self.navigationController pushViewController:vc2 animated:true];
        }
            break;
        case 2:
        {
            DSGLKViewController3 *vc3 = [[DSGLKViewController3 alloc] init];
            [self.navigationController pushViewController:vc3 animated:true];
        }
            break;
        case 3:
        {
            DSViewController4 *vc4 = [[DSViewController4 alloc] init];
            [self.navigationController pushViewController:vc4 animated:true];
        }
        case 4:
        {
            DSViewController5 *vc5 = [[DSViewController5 alloc] init];
            [self.navigationController pushViewController:vc5 animated:true];
        }
            break;
        default:
            break;
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.rowHeight = 80;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        
    }
    return _tableView;;
    
}


-(NSArray *)dataArr {
    if(_dataArr == nil){
        _dataArr = [NSArray array];
        _dataArr = @[@"OpenGL ES 设置背景色", @"OpenGL ES 绘制图片", @"使用GLKit实现正方体的渲染+旋转", @"使用CoreAnimation实现正方体的渲染+旋转", @"使用GLKit实现实现一个有纹理的立方体"];
    }
    return _dataArr;
}



@end
