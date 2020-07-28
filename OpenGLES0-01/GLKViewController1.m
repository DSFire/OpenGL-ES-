//
//  GLKViewController1.m
//  OpenGLES0-01
//
//  Created by user on 2020/7/26.
//  Copyright © 2020 Mars. All rights reserved.
//

#import "GLKViewController1.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface GLKViewController1()
{
    EAGLContext *context;
}

@end

@implementation GLKViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"Create ES context Failed");
    }
    
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    glClearColor(1, 0, 0, 1);
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glClear(GL_COLOR_BUFFER_BIT);
}



@end
