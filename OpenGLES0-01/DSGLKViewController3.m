//
//  DSGLKViewController3.m
//  OpenGLES0-01
//
//  Created by user on 2020/7/26.
//  Copyright © 2020 Mars. All rights reserved.
//

#import "DSGLKViewController3.h"
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>


@interface DSGLKViewController3 ()
{
    EAGLContext *context;
    GLKBaseEffect *cEffect;
}
@property (nonatomic, assign) NSInteger angle;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation DSGLKViewController3

- (void)viewDidLoad {
    [super viewDidLoad];

    // 初始化
    [self setUpConfig];
    
    // 加载顶点数据/纹理坐标数据
    [self setUpVertexData];
    
    // 加载纹理
    [self setUpTexture];
    
    [self addCADisplayLink];
    
}

- (void)setUpConfig{
    
    context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if (!context) {
        NSLog(@"Create ES context Failed");
    }
    
    [EAGLContext setCurrentContext:context];
    
    GLKView *view = (GLKView *)self.view;
    view.context = context;
    
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    glClearColor(1, 0, 0, 1);
    
    
}

- (void)setUpVertexData{
    //1.设置顶点数组(顶点坐标,纹理坐标)
    /*
     纹理坐标系取值范围[0,1];原点是左下角(0,0);
     故而(0,0)是纹理图像的左下角, 点(1,1)是右上角.
     */
    GLfloat vertexData[] = {

        // 前
        -0.5,0.5,0.5,        0,1,
        -0.5,-0.5,0.5,       0,0,
        0.5,0.5,0.5,         1,1,
        -0.5,-0.5,0.5,       0,0,
        0.5,0.5,0.5,         1,1,
        0.5,-0.5,0.5,        1,0,

        // 上
        0.5,0.5,0.5,         1,1,
        -0.5,0.5,0.5,        0,1,
        0.5,0.5,-0.5,        1,0,
        -0.5,0.5,0.5,        0,1,
        0.5,0.5,-0.5,        1,0,
        -0.5,0.5,-0.5,       0,0,

        // 下
        0.5,-0.5,0.5,         1,1,
        -0.5,-0.5,0.5,        0,1,
        0.5,-0.5,-0.5,        1,0,
        -0.5,-0.5,0.5,        0,1,
        0.5,-0.5,-0.5,        1,0,
        -0.5,-0.5,-0.5,       0,0,

        // 左
        -0.5,0.5,0.5,         1,1,
        -0.5,-0.5,0.5,        0,1,
        -0.5,0.5,-0.5,        1,0,
        -0.5,-0.5,0.5,        0,1,
        -0.5,0.5,-0.5,        1,0,
        -0.5,-0.5,-0.5,       0,0,

        // 右
        0.5,0.5,0.5,         1,1,
        0.5,-0.5,0.5,        0,1,
        0.5,0.5,-0.5,        1,0,
        0.5,-0.5,0.5,        0,1,
        0.5,0.5,-0.5,        1,0,
        0.5,-0.5,-0.5,       0,0,

        // 后
        -0.5,0.5,-0.5,       0,1,
        -0.5,-0.5,-0.5,      0,0,
        0.5,0.5,-0.5,        1,1,
        -0.5,-0.5,-0.5,      0,0,
        0.5,0.5,-0.5,        1,1,
        0.5,-0.5,-0.5,       1,0,

    };

    
    //2.开辟顶点缓存区
    //(1).创建顶点缓存区标识符ID
    GLuint bufferID;
    glGenBuffers(1, &bufferID);
    // (2).绑定顶点缓存区.(明确作用)
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);
    // (3).将顶点数组的数据copy到顶点缓存区中(GPU显存中)
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);
    
    
     //3.打开读取通道.
     /*
      (1)在iOS中, 默认情况下，出于性能考虑，所有顶点着色器的属性（Attribute）变量都是关闭的.
      意味着,顶点数据在着色器端(服务端)是不可用的. 即使你已经使用glBufferData方法,将顶点数据从内存拷贝到顶点缓存区中(GPU显存中).
      所以, 必须由glEnableVertexAttribArray 方法打开通道.指定访问属性.才能让顶点着色器能够访问到从CPU复制到GPU的数据.
      注意: 数据在GPU端是否可见，即，着色器能否读取到数据，由是否启用了对应的属性决定，这就是glEnableVertexAttribArray的功能，允许顶点着色器读取GPU（服务器端）数据。
    
     (2)方法简介
     glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)
    
     功能: 上传顶点数据到显存的方法（设置合适的方式从buffer里面读取数据）
     参数列表:
         index,指定要修改的顶点属性的索引值,例如
         size, 每次读取数量。（如position是由3个（x,y,z）组成，而颜色是4个（r,g,b,a）,纹理则是2个.）
         type,指定数组中每个组件的数据类型。可用的符号常量有GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT,GL_UNSIGNED_SHORT, GL_FIXED, 和 GL_FLOAT，初始值为GL_FLOAT。
         normalized,指定当被访问时，固定点数据值是否应该被归一化（GL_TRUE）或者直接转换为固定点值（GL_FALSE）
         stride,指定连续顶点属性之间的偏移量。如果为0，那么顶点属性会被理解为：它们是紧密排列在一起的。初始值为0
         ptr指定一个指针，指向数组中第一个顶点属性的第一个组件。初始值为0
      */
    
    //顶点坐标数据
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 0);
    
    //纹理坐标数据
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, (GLfloat *)NULL + 3);
    
}

- (void)setUpTexture {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"timg" ofType:@"jpeg"];
    
    // 设置纹理参数
    // 纹理坐标原点是左下角,但是图片显示原点应该是左上角.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];
    
    // 使用苹果GLKit 提供GLKBaseEffect 完成着色器工作(顶点/片元)
    cEffect = [[GLKBaseEffect alloc] init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = textureInfo.name;
    
}

#pragma mark - GLKViewDelegate

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    glEnable(GL_DEPTH_TEST);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [cEffect prepareToDraw];
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
    
}

-(void) addCADisplayLink{
   
    self.angle = 0;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(update)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)update {
   
    //1.计算旋转度数
    self.angle = (self.angle + 5) % 360;
    //2.修改baseEffect.transform.modelviewMatrix
    cEffect.transform.modelviewMatrix = GLKMatrix4MakeRotation(GLKMathDegreesToRadians(self.angle), 0.3, 1, -0.5);
    //3.重新渲染
    GLKView *view = (GLKView *)self.view;

    [view display];
}

@end
