//
//  DSViewController4.m
//  OpenGLES0-01
//
//  Created by user on 2020/7/26.
//  Copyright © 2020 Mars. All rights reserved.
//

#import "DSViewController4.h"

@interface DSViewController4 ()
{
    UIView *layerView;
}
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) NSMutableArray<UIImageView *> *views;

@end

@implementation DSViewController4

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self setUpConfig];

    [self addCADisplayLink];
}

- (void)setUpConfig{

    layerView = [[UIView alloc] initWithFrame: self.view.bounds];
    layerView.backgroundColor = [UIColor redColor];
    layerView.center = self.view.center;
    [self.view addSubview:layerView];
    
    for (NSInteger i = 0; i < 6; i++) {
        UIImageView * imgV = [[UIImageView alloc] init];
        imgV.image = [UIImage imageNamed:@"timg.jpeg"];
        imgV.frame = CGRectMake(0, 0, 200, 200);
        [self.views addObject:imgV];
    }

    
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    layerView.layer.sublayerTransform = perspective;
    // 1
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:0 withTransform:transform];
    // 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    // 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    // 4
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 0, 1);
    [self addFace:3 withTransform:transform];
    // 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    // 6
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:5 withTransform:transform];
    
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform{

    UIImageView *face = self.views[index];
    [layerView addSubview:face];

    CGSize containerSize = layerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2.0, containerSize.height / 2.0);
    face.layer.transform = transform;
}


-(void) addCADisplayLink{
   
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)update {
   
    //1.计算旋转度数
    static CGFloat angle = 1.0f;

    CATransform3D transform3d = layerView.layer.sublayerTransform;
    transform3d = CATransform3DRotate(transform3d, angle/180.0f*M_PI, 0.0f, 1.0f, 0.0f);
        layerView.layer.sublayerTransform = transform3d;
}

- (NSMutableArray<UIImageView *> *)views {
    if (!_views) {
        _views = [NSMutableArray array];
    }
    return _views;
}


@end
