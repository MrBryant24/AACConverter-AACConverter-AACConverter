AACConverter
============
#把Mp3等格式转换为M4r
#还有还有wav.tiff转换为aac/m4a

[TPAACAudioConverter](https://github.com/namebryant/TPAACAudioConverter)

---

>	有实现这个功能多数人会用到外国一大神写的开源库`AACConverterViewController.h`,但是那个哥的库N年不更新，现在xcode5都编译不了
>

*	今天有个业务需要把MP3来源转换为ios的铃声，铃声是m4r格式的
*	我的Demo没有设置UI控件,结果直接看沙盒合适




</code>
---
#在转换方法里


主要方法：
```objc

 NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    audioConverter = [[TPAACAudioConverter alloc] initWithDelegate:self
                                                             source:[[NSBundle mainBundle] pathForResource:@"a" ofType:@"mp3"]
                                                        destination:[[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"audso.m4r"]];
    [audioConverter start];
    
```    
 方法结束后,用`SimPholders`查看沙盒的 `audso.m4r  ` 

---

#转换处理时的代理监听

```objc

#pragma mark - Audio converter delegate
/**
 *  监听转换进度
 *
 *  @param converter TPAACAudioConverter
 *  @param progress  进度数值
 */
-(void)AACAudioConverter:(TPAACAudioConverter *)converter didMakeProgress:(CGFloat)progress {
    
    
    //    self.progressView.progress = progress;
}
/**
 *  转换结束
 *
 *  @param converter TPAACAudioConverter
 */
-(void)AACAudioConverterDidFinishConversion:(TPAACAudioConverter *)converter {
    
    audioConverter = nil;
}

-(void)AACAudioConverter:(TPAACAudioConverter *)converter didFailWithError:(NSError *)error {
   
    audioConverter = nil;
}

```

#有两个静态方法直接复制就好,下面转换方法会调用

1.static inline BOOL _checkResult(OSStatus result, const char *operation, const char* file, int line) 

2.static void interruptionListener(void *inClientData, UInt32 inInterruption)

#具体看Demo

额额,其实不懂只是我的表达能力问题！
