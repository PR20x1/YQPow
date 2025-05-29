#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>

#include "imgui/imgui.h"
#include "imgui/imgui_impl_metal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModController : UIViewController <MTKViewDelegate>
    @property (nonatomic, readonly) MTKView *mtkView;
    @property (nonatomic, strong) id <MTLDevice> device;
    @property (nonatomic, strong) id <MTLCommandQueue> commandQueue;
    @property (strong, nonatomic) UIWindow *window;
    @property (nonatomic, strong) UILabel *playerCountLabel;
@end

NS_ASSUME_NONNULL_END
