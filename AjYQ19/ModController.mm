#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Metal/Metal.h>
#import <MetalKit/MetalKit.h>
#include "imgui/imgui.h"
#include "imgui/imgui_impl_metal.h"
#include "imgui/imgui_internal.h"
#include "imgui/Recto.hpp"

#import "Utilities/Macros.h"
#import "Utilities/Obfuscate.h"
#import "Utilities/XORstring.h"

#import "UnityStructs/Quaternion.hpp"
#import "UnityStructs/Vector3.h"
#import "UnityStructs/Vector2.h"
#import "UnityStructs/Vector4.h"
#import "UnityStructs/Matrix4x4.h"
#import "UnityStructs/Unity.h"

#import "Draw/Draw.h"

#include "CheatState/CheatState.hpp"
#include "ModController.h"
#include "font.h"
#include "iconcpp.h"
#import "icons.h"

#import "Stream/HeeeNoScreenShotView.h"
#import "Hosts/NSObject+URL.h"

#define kWidth  [UIScreen mainScreen].bounds.size.width
#define kHeight [UIScreen mainScreen].bounds.size.height
#define kScale [UIScreen mainScreen].scale

#define ICON_FA_CROSSHAIRS "\xef\x81\x9b"
#define ICON_FA_EYE "\xef\x81\xae"
#define ICON_FA_COG "\xef\x80\x93"

// 1.0.50 IOS Global Offsets 64 bit 
// void* (*GetBoneTransform)(void* component, int boneID) = (void* (*)(void*, int))getRealOffset(0x106E092B8); // public Transform GetBoneTransform(HumanBodyBones humanBoneId) { } // 1 lista
// bool (*Linecast)(Vector3, Vector3, long) = (bool (*)(Vector3, Vector3, long))getRealOffset(0x106E926BC); // public static bool Linecast(Vector3 start, Vector3 end, long layerMask) { } // 1 lista
// int (*GetLayer)(void*) = (int (*)(void*))getRealOffset(0x106E49058); // public int get_layer() { } // 1 lista
// void *(*GetMainCamera)() = (void *(*)())getRealOffset(0x106E43DA4); // public static Camera get_main() { } // 1 lista
// void *(*GetComponentTransform)(void *component) = (void *(*)(void *))getRealOffset(0x106E49710); // public Transform get_transform() { } // 1 lista
// void (*GetTransformPosition)(void *transform, Vector3 *out) = (void (*)(void *, Vector3 *))getRealOffset(0x106EBE3FC); // private void INTERNAL_get_position(out Vector3 value) { } // 1 lista
// Matrix4x4 (*GetWorldToCameraMatrix)(void* camera) = (Matrix4x4(*)(void*))getRealOffset(0x106E43668); // public Matrix4x4 get_worldToCameraMatrix() { } // 1 lista
// Matrix4x4 (*GetProjectionMatrix)(void* camera) = (Matrix4x4(*)(void*))getRealOffset(0x106E43750); // public Matrix4x4 get_projectionMatrix() { } // 1 lista
// void* (*GetGameplayInstance)() = (void *(*)())getRealOffset(0x101B8BE34); // public static BaseGame get_Game() { } // 1 lista
// bool (*IsAlive)(void *info) = (bool (*)(void *))getRealOffset(0x101270E24); // public override bool get_IsAlive() { } // 3 lista
// bool (*IsRobot)(void *info) = (bool (*)(void *))getRealOffset(0x101E5C310); // public bool get_IsRobot() { } // 1 lista
// float (*GetHealth)(void *pawn) = (float (*)(void*))getRealOffset(0x10126D62C); // public override float get_Health() { } // 4 lista
// void* (*getLocalPawn)() = (void *(*)())getRealOffset(0x101B8E6B4); // public static Pawn get_LocalPawn() { }
// bool (*GetIsFiring)(void *) = (bool (*)(void *))getRealOffset(0x101B28754); // public bool GetIsFiring() { } // 1 lista
// bool (*GetIsAiming)(void *) = (bool (*)(void *))getRealOffset(0x10127A188); // public bool IsAiming() { } // 1 lista
// Quaternion (*getAimRotation)(void*) = (Quaternion (*)(void*))getRealOffset(0x10126D664); // public virtual Quaternion get_AimRotation() { } // 1 lista
// void (*setAimRotation)(void*, Quaternion) = (void (*)(void*, Quaternion))getRealOffset(0x101281BF0); // public virtual void SetAimRotation(Quaternion rotation) { } // 1 lista

// Function pointers
void* (*GetBoneTransform)(void* component, int boneID) = (void* (*)(void*, int))getRealOffset(0x106E092B8); // public Transform GetBoneTransform(HumanBodyBones humanBoneId) { } // 1 lista
bool (*Linecast)(Vector3, Vector3, long) = (bool (*)(Vector3, Vector3, long))getRealOffset(0x106E926BC); // public static bool Linecast(Vector3 start, Vector3 end, long layerMask) { } // 1 lista
int (*GetLayer)(void*) = (int (*)(void*))getRealOffset(0x106E49058); // public int get_layer() { } // 1 lista
void *(*GetMainCamera)() = (void *(*)())getRealOffset(0x106E43DA4); // public static Camera get_main() { } // 1 lista
void *(*GetComponentTransform)(void *component) = (void *(*)(void *))getRealOffset(0x106E49710); // public Transform get_transform() { } // 1 lista
void (*GetTransformPosition)(void *transform, Vector3 *out) = (void (*)(void *, Vector3 *))getRealOffset(0x106EBE3FC); // private void INTERNAL_get_position(out Vector3 value) { } // 1 lista
Matrix4x4 (*GetWorldToCameraMatrix)(void* camera) = (Matrix4x4(*)(void*))getRealOffset(0x106E43668); // public Matrix4x4 get_worldToCameraMatrix() { } // 1 lista
Matrix4x4 (*GetProjectionMatrix)(void* camera) = (Matrix4x4(*)(void*))getRealOffset(0x106E43750); // public Matrix4x4 get_projectionMatrix() { } // 1 lista
void* (*GetGameplayInstance)() = (void *(*)())getRealOffset(0x101B8BE34); // public static BaseGame get_Game() { } // 1 lista
bool (*IsAlive)(void *info) = (bool (*)(void *))getRealOffset(0x101270E24); // public override bool get_IsAlive() { } // 3 lista
bool (*IsRobot)(void *info) = (bool (*)(void *))getRealOffset(0x101E5C310); // public bool get_IsRobot() { } // 1 lista
float (*GetHealth)(void *pawn) = (float (*)(void*))getRealOffset(0x10126D62C); // public override float get_Health() { } // 4 lista
void* (*getLocalPawn)() = (void *(*)())getRealOffset(0x101B8E6B4); // public static Pawn get_LocalPawn() { }
bool (*GetIsFiring)(void *) = (bool (*)(void *))getRealOffset(0x101B28754); // public bool GetIsFiring() { } // 1 lista
bool (*GetIsAiming)(void *) = (bool (*)(void *))getRealOffset(0x10127A188); // public bool IsAiming() { } // 1 lista
Quaternion (*getAimRotation)(void*) = (Quaternion (*)(void*))getRealOffset(0x10126D664); // public virtual Quaternion get_AimRotation() { } // 1 lista
void (*setAimRotation)(void*, Quaternion) = (void (*)(void*, Quaternion))getRealOffset(0x101281BF0); // public virtual void SetAimRotation(Quaternion rotation) { } // 1 lista

@interface InheritGesture : UITapGestureRecognizer
@property (nonatomic) int number;
@property (nonatomic) NSString *text;
@property (nonatomic) void (*ptr)();
@end

@implementation InheritGesture: UITapGestureRecognizer
@end

@implementation ModController {
    HeeeNoScreenShotView *noScreenShotView;
    UILabel *menuTitle;
    UIButton *pulsatingButton;
    UILabel *_playerCountLabel;
    ImFont *_espFont;
    ImFont *_titleFont;
}

static int totalEnemies = 0;
static float tDis = 0, tDistance = 0, markDistance, markDis;
Vector3 TargetPos;
static bool needAdjustAim = false;
static Vector2 markScreenPos;

#pragma mark - Position Helpers

Vector3 GetPlayerPosition(void *player) {
    Vector3 location;
    GetTransformPosition(GetComponentTransform(player), &location);
    return location;
}

Vector3 GetTransformPositionInternal(void *transform) {
    Vector3 location;
    GetTransformPosition(transform, &location);
    return location;
}

Matrix4x4 GetWorldToCamera() {
    if (GetMainCamera() != nullptr) {
        return GetWorldToCameraMatrix(GetMainCamera());
    }
    return Matrix4x4();
}

Matrix4x4 GetProjectionMatrixInternal() {
    if (GetMainCamera() != nullptr) {
        return GetProjectionMatrix(GetMainCamera());
    }
    return Matrix4x4();
}

#pragma mark - Visibility Check

bool IsEnemyVisible(void* enemyPawn, Vector3 localPlayerPos) {
    void* headBone = *(void**)((uint64_t)enemyPawn + 0x2E8); // protected Transform m_HeadBone 
    if (!headBone) return false;
    
    Vector3 enemyHeadPos = GetTransformPositionInternal(headBone);
    
    // Adjust positions slightly
    localPlayerPos.y += 0.5f;  // ~chest height
    enemyHeadPos.y -= 0.1f;    // slightly below head
    
    // Layer mask handling
    long layerMask = ~0; // Default to all layers
    int enemyLayer = GetLayer(enemyPawn);
    if (enemyLayer >= 0 && enemyLayer < 64) {
        layerMask &= ~(1 << enemyLayer); // Exclude enemy's layer
    }
    
    bool isVisible = !Linecast(localPlayerPos, enemyHeadPos, layerMask);
    
    // Update visibility color in CheatState
    CheatState::visibilityColor[0] = isVisible ? 0.0f : 1.0f; // R
    CheatState::visibilityColor[1] = isVisible ? 1.0f : 0.0f; // G
    CheatState::visibilityColor[2] = 0.0f; // B
    
    return isVisible;
}

#pragma mark - Projection Helpers

Vector4 GetViewCoords(Vector3 pos, Matrix4x4 modelViewMatrix) {
    Vector4 viewPos;
    viewPos.X = pos.x * modelViewMatrix[0][0] + pos.y * modelViewMatrix[1][0] + pos.z * modelViewMatrix[2][0] + modelViewMatrix[3][0];
    viewPos.Y = pos.x * modelViewMatrix[0][1] + pos.y * modelViewMatrix[1][1] + pos.z * modelViewMatrix[2][1] + modelViewMatrix[3][1];
    viewPos.Z = pos.x * modelViewMatrix[0][2] + pos.y * modelViewMatrix[1][2] + pos.z * modelViewMatrix[2][2] + modelViewMatrix[3][2];
    viewPos.W = pos.x * modelViewMatrix[0][3] + pos.y * modelViewMatrix[1][3] + pos.z * modelViewMatrix[2][3] + modelViewMatrix[3][3];
    return viewPos;
}

Vector4 GetClipCoords(Vector4 pos, Matrix4x4 projectionMatrix) {
    Vector4 clipPos;
    clipPos.X = pos.X * projectionMatrix[0][0] + pos.Y * projectionMatrix[1][0] + pos.Z * projectionMatrix[2][0] + pos.W * projectionMatrix[3][0];
    clipPos.Y = pos.X * projectionMatrix[0][1] + pos.Y * projectionMatrix[1][1] + pos.Z * projectionMatrix[2][1] + pos.W * projectionMatrix[3][1];
    clipPos.Z = pos.X * projectionMatrix[0][2] + pos.Y * projectionMatrix[1][2] + pos.Z * projectionMatrix[2][2] + pos.W * projectionMatrix[3][2];
    clipPos.W = pos.X * projectionMatrix[0][3] + pos.Y * projectionMatrix[1][3] + pos.Z * projectionMatrix[2][3] + pos.W * projectionMatrix[3][3];
    return clipPos;
}

Vector3 NormalizeCoords(Vector4 pos) {
    Vector3 normalized;
    normalized.x = pos.X / pos.W;
    normalized.y = pos.Y / pos.W;
    normalized.z = pos.Z / pos.W;
    return normalized;
}

Vector2 GetScreenCoords(Vector3 pos) {
    Vector2 screen;
    screen.X = (kWidth / 2.0 * pos.x) + (pos.x + kWidth / 2.0);
    screen.Y = -(kHeight / 2.0 * pos.y) + (pos.y + kHeight / 2.0);
    return screen;
}

NSString* GetEnemyName(float distance, void* enemyInfo) {
    NSString *dis = [NSString stringWithFormat:@"%d", (int)distance];
    _monoString *m_NickName = *(_monoString **)((uint64_t)enemyInfo + 0x148);
    NSString *nameEnemy = m_NickName->toNSString();
    bool isRobot = IsRobot ? IsRobot(enemyInfo) : false;
    
    if (isRobot || nameEnemy.length == 0) {
        nameEnemy = @"[AI]";
    }
    return [NSString stringWithFormat:@"[%@M] %@", dis, nameEnemy];
}

#pragma mark - UI Setup

static bool MenDeal = true;

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeRight;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)prefersHomeIndicatorAutoHidden {
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    _device = MTLCreateSystemDefaultDevice();
    _commandQueue = [_device newCommandQueue];
    
    if (!self.device) {
        NSLog(@"Metal is not supported");
        abort();
    }
    
    // Setup UI elements
    [self setupUIElements];
    
    // Setup ImGui
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    
    [self setupImGuiStyle];
    [self loadFonts];
    
    ImGui_ImplMetal_Init(_device);
    
    return self;
}

- (void)setupUIElements {
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    
    // Menu title
    menuTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    menuTitle.text = @"Luna Menu";
    menuTitle.textColor = UIColorFromHex(0x4A90E2);
    menuTitle.font = [UIFont fontWithName:@"AppleSDGothicNeo-Bold" size:18.0f];
    menuTitle.textAlignment = NSTextAlignmentCenter;
    [menuTitle sizeToFit];
    menuTitle.center = CGPointMake(CGRectGetMidX(mainWindow.bounds), 25);
    menuTitle.adjustsFontSizeToFitWidth = YES;
    [mainWindow addSubview:menuTitle];
    
    // Player count label
    _playerCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    _playerCountLabel.text = @"Players: 0 | Bots: 0";
    _playerCountLabel.textColor = UIColorFromHex(0xE74C3C);
    _playerCountLabel.font = [UIFont fontWithName:@"AppleSDGothicNeo-Regular" size:14.0f];
    _playerCountLabel.textAlignment = NSTextAlignmentCenter;
    [_playerCountLabel sizeToFit];
    _playerCountLabel.center = CGPointMake(CGRectGetMidX(mainWindow.bounds), 50);
    [mainWindow addSubview:_playerCountLabel];
    
    // Menu toggle button
    pulsatingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pulsatingButton.frame = CGRectMake((kWidth - 46) / 2, (kHeight - 46) / 2, 46, 46);
    pulsatingButton.layer.cornerRadius = 23;
    pulsatingButton.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.007];
    [pulsatingButton addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:pulsatingButton];
}

- (void)setupImGuiStyle {
    ImGuiStyle& style = ImGui::GetStyle();
    style.WindowPadding = ImVec2(8, 8);
    style.FramePadding = ImVec2(6, 4);
    style.CellPadding = ImVec2(6, 6);
    style.ItemSpacing = ImVec2(10, 8); // Increased spacing
    style.ItemInnerSpacing = ImVec2(6, 6);
    style.TouchExtraPadding = ImVec2(0, 0);
    style.IndentSpacing = 25;
    style.ScrollbarSize = 15;
    style.GrabMinSize = 10;
    
    style.WindowBorderSize = 1;
    style.ChildBorderSize = 1;
    style.PopupBorderSize = 1;
    style.FrameBorderSize = 1;
    style.TabBorderSize = 1;
    
    style.WindowRounding = 7;
    style.ChildRounding = 4;
    style.FrameRounding = 3;
    style.PopupRounding = 4;
    style.ScrollbarRounding = 9;
    style.GrabRounding = 3;
    style.TabRounding = 4;
    
    // Modern dark theme
    ImVec4* colors = style.Colors;
    colors[ImGuiCol_Text] = ImVec4(0.95f, 0.96f, 0.98f, 1.00f);
    colors[ImGuiCol_TextDisabled] = ImVec4(0.36f, 0.42f, 0.47f, 1.00f);
    colors[ImGuiCol_WindowBg] = ImVec4(0.11f, 0.15f, 0.17f, 0.94f);
    colors[ImGuiCol_ChildBg] = ImVec4(0.15f, 0.18f, 0.22f, 0.00f);
    colors[ImGuiCol_PopupBg] = ImVec4(0.08f, 0.08f, 0.08f, 0.94f);
    colors[ImGuiCol_Border] = ImVec4(0.08f, 0.10f, 0.12f, 1.00f);
    colors[ImGuiCol_BorderShadow] = ImVec4(0.00f, 0.00f, 0.00f, 0.00f);
    colors[ImGuiCol_FrameBg] = ImVec4(0.20f, 0.25f, 0.29f, 1.00f);
    colors[ImGuiCol_FrameBgHovered] = ImVec4(0.12f, 0.20f, 0.28f, 1.00f);
    colors[ImGuiCol_FrameBgActive] = ImVec4(0.09f, 0.12f, 0.14f, 1.00f);
    colors[ImGuiCol_TitleBg] = ImVec4(0.09f, 0.12f, 0.14f, 0.65f);
    colors[ImGuiCol_TitleBgActive] = ImVec4(0.08f, 0.10f, 0.12f, 1.00f);
    colors[ImGuiCol_TitleBgCollapsed] = ImVec4(0.00f, 0.00f, 0.00f, 0.51f);
    colors[ImGuiCol_MenuBarBg] = ImVec4(0.15f, 0.18f, 0.22f, 1.00f);
    colors[ImGuiCol_ScrollbarBg] = ImVec4(0.02f, 0.02f, 0.02f, 0.39f);
    colors[ImGuiCol_ScrollbarGrab] = ImVec4(0.20f, 0.25f, 0.29f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabHovered] = ImVec4(0.18f, 0.22f, 0.25f, 1.00f);
    colors[ImGuiCol_ScrollbarGrabActive] = ImVec4(0.09f, 0.21f, 0.31f, 1.00f);
    colors[ImGuiCol_CheckMark] = ImVec4(0.28f, 0.56f, 1.00f, 1.00f);
    colors[ImGuiCol_SliderGrab] = ImVec4(0.28f, 0.56f, 1.00f, 1.00f);
    colors[ImGuiCol_SliderGrabActive] = ImVec4(0.37f, 0.61f, 1.00f, 1.00f);
    colors[ImGuiCol_Button] = ImVec4(0.20f, 0.25f, 0.29f, 1.00f);
    colors[ImGuiCol_ButtonHovered] = ImVec4(0.28f, 0.56f, 1.00f, 1.00f);
    colors[ImGuiCol_ButtonActive] = ImVec4(0.06f, 0.53f, 0.98f, 1.00f);
    colors[ImGuiCol_Header] = ImVec4(0.20f, 0.25f, 0.29f, 0.55f);
    colors[ImGuiCol_HeaderHovered] = ImVec4(0.26f, 0.59f, 0.98f, 0.80f);
    colors[ImGuiCol_HeaderActive] = ImVec4(0.26f, 0.59f, 0.98f, 1.00f);
    colors[ImGuiCol_Separator] = ImVec4(0.20f, 0.25f, 0.29f, 1.00f);
    colors[ImGuiCol_SeparatorHovered] = ImVec4(0.10f, 0.40f, 0.75f, 0.78f);
    colors[ImGuiCol_SeparatorActive] = ImVec4(0.10f, 0.40f, 0.75f, 1.00f);
    colors[ImGuiCol_Tab] = ImVec4(0.11f, 0.15f, 0.17f, 1.00f);
    colors[ImGuiCol_TabHovered] = ImVec4(0.26f, 0.59f, 0.98f, 0.80f);
    colors[ImGuiCol_TabActive] = ImVec4(0.20f, 0.25f, 0.29f, 1.00f);
    colors[ImGuiCol_TabUnfocused] = ImVec4(0.11f, 0.15f, 0.17f, 1.00f);
    colors[ImGuiCol_TabUnfocusedActive] = ImVec4(0.11f, 0.15f, 0.17f, 1.00f);
}

- (void)loadFonts {
    ImGuiIO& io = ImGui::GetIO();
    
    // Load main font
    ImFontConfig fontConfig;
    fontConfig.FontDataOwnedByAtlas = false;
    _espFont = io.Fonts->AddFontFromMemoryTTF(const_cast<std::uint8_t*>(Custom), sizeof(Custom), 18.0f, &fontConfig);
    
    // Load title font (larger size)
    _titleFont = io.Fonts->AddFontFromMemoryTTF(const_cast<std::uint8_t*>(Custom), sizeof(Custom), 22.0f, &fontConfig);
    
    // Load icons
    static const ImWchar icons_ranges[] = { 0xf000, 0xf3ff, 0 };
    ImFontConfig icons_config;
    icons_config.MergeMode = true;
    icons_config.PixelSnapH = true;
    io.Fonts->AddFontFromMemoryCompressedTTF(font_awesome_data, font_awesome_size, 16.0f, &icons_config, icons_ranges);
    
    io.Fonts->AddFontDefault();
}

- (void)toggleMenu {
    MenDeal = !MenDeal;
    [UIView animateWithDuration:0.2 animations:^{
        self->pulsatingButton.transform = MenDeal ? CGAffineTransformMakeScale(1.15, 1.15) : CGAffineTransformIdentity;
        self->pulsatingButton.alpha = MenDeal ? 0.7 : 1.0;
    }];
}

#pragma mark - View Lifecycle

- (MTKView *)mtkView {
    return (MTKView *)self.view;
}

- (void)loadView {
    CGFloat w = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.width;
    CGFloat h = [UIApplication sharedApplication].windows[0].rootViewController.view.frame.size.height;
    self.view = [[MTKView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    
    noScreenShotView = [[HeeeNoScreenShotView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    noScreenShotView.backgroundColor = [UIColor clearColor];
    noScreenShotView.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:noScreenShotView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mtkView.device = self.device;
    self.mtkView.delegate = self;
    self.mtkView.clearColor = MTLClearColorMake(0, 0, 0, 0);
    self.mtkView.backgroundColor = [UIColor clearColor];
    self.mtkView.clipsToBounds = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.window.rootViewController = self;
    self.window.hidden = NO;
    self.view.hidden = NO;
    [noScreenShotView addSubview:self.window];
}

#pragma mark - Rendering

- (void)drawInMTKView:(MTKView*)view {
    // Update player count label
    [_playerCountLabel setText:[NSString stringWithFormat:@"Players: %d | Bots: %d", 
                              CheatState::player_count, CheatState::bot_count]];
    [_playerCountLabel sizeToFit];
    
    // Setup ImGui frame
    ImGuiIO& io = ImGui::GetIO();
    io.DisplaySize.x = view.bounds.size.width;
    io.DisplaySize.y = view.bounds.size.height;
    CGFloat framebufferScale = view.window.screen.scale ?: UIScreen.mainScreen.scale;
    io.DisplayFramebufferScale = ImVec2(framebufferScale, framebufferScale);
    io.DeltaTime = 1 / float(view.preferredFramesPerSecond ?: 60);
    
    id<MTLCommandBuffer> commandBuffer = [self.commandQueue commandBuffer];
    MTLRenderPassDescriptor* renderPassDescriptor = view.currentRenderPassDescriptor;
    if (renderPassDescriptor == nil) {
        [commandBuffer commit];
        return;
    }
    
    // Handle menu interaction
    if (MenDeal) {
        [self.view setUserInteractionEnabled:YES];
        [self.window setUserInteractionEnabled:YES];
    } else {
        [self.view setUserInteractionEnabled:NO];
        [self.window setUserInteractionEnabled:NO];
    }
    
    // Start new ImGui frame
    ImGui_ImplMetal_NewFrame(renderPassDescriptor);
    ImGui::NewFrame();
    
    // Render menu
    if (MenDeal) {
        [self renderMenu];
    }
    
    // Render ESP
    if (CheatState::show_esp) {
        [self renderESP];
    }
    
    // Render Aimbot visuals
    if (CheatState::enable_aimbot) {
        [self renderAimbotVisuals];
    }
    
    // Render FOV circle
    if (CheatState::enable_circleFov) {
        ImVec2 center = ImVec2(kWidth / 2, kHeight / 2);
        ImGui::GetBackgroundDrawList()->AddCircle(
            center, 
            CheatState::circleSizeValue, 
            IM_COL32(255, 255, 255, 255), 
            0, 
            1.0f
        );
    }
    
    // Render ImGui
    ImGui::Render();
    ImDrawData* drawData = ImGui::GetDrawData();
    id <MTLRenderCommandEncoder> renderEncoder = [commandBuffer renderCommandEncoderWithDescriptor:renderPassDescriptor];
    [renderEncoder pushDebugGroup:@"ImGui Rendering"];
    ImGui_ImplMetal_RenderDrawData(drawData, commandBuffer, renderEncoder);
    [renderEncoder popDebugGroup];
    [renderEncoder endEncoding];
    
    // Present and commit
    [commandBuffer presentDrawable:view.currentDrawable];
    [commandBuffer commit];
    
    // Update screenshot protection
    [noScreenShotView setSecure:CheatState::stream_mode];
    menuTitle.hidden = CheatState::hide_top_label;
    _playerCountLabel.hidden = CheatState::hide_top_NumPlayer;
}

- (void)renderMenu {
    ImGui::SetNextWindowSize(ImVec2(600, 450), ImGuiCond_FirstUseEver);
    ImGui::SetNextWindowPos(ImVec2((kWidth - 600) / 2, (kHeight - 450) / 2), ImGuiCond_FirstUseEver);
    
    if (ImGui::Begin("Luna Menu", &MenDeal, ImGuiWindowFlags_NoCollapse | ImGuiWindowFlags_NoResize)) {
        // Left sidebar with icons
        ImGui::BeginChild("Sidebar", ImVec2(80, 0), true);
        {
            ImGui::PushStyleVar(ImGuiStyleVar_ItemSpacing, ImVec2(0, 20));
            
            if (ImGui::Button(ICON_FA_CROSSHAIRS, ImVec2(60, 60))) { 
                CheatState::selectedTab = 0; 
            }
            if (ImGui::Button(ICON_FA_EYE, ImVec2(60, 60))) { 
                CheatState::selectedTab = 1; 
            }
            if (ImGui::Button(ICON_FA_COG, ImVec2(60, 60))) { 
                CheatState::selectedTab = 2; 
            }
            
            ImGui::PopStyleVar();
        }
        ImGui::EndChild();
        
        ImGui::SameLine();
        
        // Right content area
        ImGui::BeginChild("Content", ImVec2(0, 0), true);
        {
            switch (CheatState::selectedTab) {
                case 0: // Aimbot
                    [self renderAimbotTab];
                    break;
                case 1: // ESP
                    [self renderESPTab];
                    break;
                case 2: // Config
                    [self renderConfigTab];
                    break;
            }
        }
        ImGui::EndChild();
    }
    ImGui::End();
}

- (void)renderAimbotTab {
    ImGui::PushFont(_titleFont);
    ImGui::TextColored(ImVec4(0.28f, 0.56f, 1.00f, 1.00f), "Aimbot Settings");
    ImGui::PopFont();
    ImGui::Separator();
    
    ImGui::Checkbox("Enable Aimbot", &CheatState::enable_aimbot);
    if (CheatState::enable_aimbot) {
        ImGui::Spacing();
        ImGui::Text("Targeting");
        ImGui::Combo("Target Selection", &CheatState::aim_target, "Closest\0Inside FOV\0");
        ImGui::Combo("Aim Position", &CheatState::aim_location, "Head\0Chest\0Legs\0");
        ImGui::Combo("Activation", &CheatState::aim_trigger, "Always\0Firing\0Aiming\0");
        
        ImGui::Spacing();
        ImGui::Text("Adjustments");
        ImGui::SliderFloat("Aim Speed", &CheatState::aim_speed, 0.0f, 30.0f, "%.1f");
        ImGui::SliderFloat("Recoil Comp", &CheatState::recoil_amount, 0.0f, 5.0f, "%.2f");
        ImGui::SliderFloat("Max Distance", &CheatState::max_distance, 0.0f, 500.0f, "%.0f m");
        
        ImGui::Spacing();
        ImGui::Text("Visualization");
        ImGui::Combo("Visual Style", &CheatState::aim_visual_style, "Circle\0Line\0");
        ImGui::SliderInt("FOV Size", &CheatState::circleSizeValue, 0, 360, "%d px");
    }
}

- (void)renderESPTab {
    ImGui::PushFont(_titleFont);
    ImGui::TextColored(ImVec4(0.28f, 0.56f, 1.00f, 1.00f), "ESP Settings");
    ImGui::PopFont();
    ImGui::Separator();
    
    ImGui::Checkbox("Enable ESP", &CheatState::show_esp);
    if (CheatState::show_esp) {
        // Visibility check with color feedback
        ImGui::Text("Visibility Check:");
        ImGui::SameLine();
        ImGui::ColorButton("##vis_color", 
                          ImVec4(CheatState::visibilityColor[0], 
                                 CheatState::visibilityColor[1], 
                                 CheatState::visibilityColor[2], 
                                 1.0f), 
                          ImGuiColorEditFlags_NoTooltip, 
                          ImVec2(20,20));
        
        ImGui::Spacing();
        ImGui::Text("Visual Elements");
        ImGui::Checkbox("Show Lines", &CheatState::show_esplines);
        if (CheatState::show_esplines) {
            ImGui::SameLine();
            ImGui::ColorEdit3("Line Color", CheatState::colorLines, ImGuiColorEditFlags_NoInputs);
        }
        
        ImGui::Checkbox("Show Boxes", &CheatState::show_espboxes);
        if (CheatState::show_espboxes) {
            ImGui::SameLine();
            ImGui::ColorEdit3("Box Color", CheatState::colorBoxes, ImGuiColorEditFlags_NoInputs);
            ImGui::Combo("Style", &CheatState::box_style, "Rectangle\0Corners\0");
            
            if (CheatState::box_style == 1) {
                ImGui::Checkbox("Fill Box", &CheatState::filled_box);
                if (CheatState::filled_box) {
                    ImGui::SameLine();
                    ImGui::ColorEdit4("Fill Color", (float*)&CheatState::boxFillColor, 
                                    ImGuiColorEditFlags_NoInputs | ImGuiColorEditFlags_AlphaBar);
                }
            }
        }
        
        ImGui::Checkbox("Show Health", &CheatState::show_esp_health);
        
        ImGui::Spacing();
        ImGui::Text("Information");
        ImGui::Checkbox("Show Names", &CheatState::show_esp_name);
        if (CheatState::show_esp_name) {
            ImGui::SameLine();
            ImGui::ColorEdit3("Name Color", CheatState::colorName, ImGuiColorEditFlags_NoInputs);
        }
        
        ImGui::Checkbox("Show Distance", &CheatState::show_esp_distance);
        if (CheatState::show_esp_distance) {
            ImGui::SameLine();
            ImGui::ColorEdit3("Distance Color", CheatState::colorDistance, ImGuiColorEditFlags_NoInputs);
        }
        
        ImGui::Spacing();
        ImGui::Text("Range");
        ImGui::SliderInt("Max Distance", &CheatState::distanceValue, 0, 300, "%d m");
    }
}

- (void)renderConfigTab {
    ImGui::PushFont(_titleFont);
    ImGui::TextColored(ImVec4(0.28f, 0.56f, 1.00f, 1.00f), "Configuration");
    ImGui::PopFont();
    ImGui::Separator();
    
    ImGui::Text("Protection");
    ImGui::Checkbox("Stream Mode", &CheatState::stream_mode);
    ImGui::Checkbox("Hide Label", &CheatState::hide_top_label);
    ImGui::Checkbox("Hide Player Count", &CheatState::hide_top_NumPlayer);
    
    ImGui::Spacing();
    ImGui::Text("Visuals");
    ImGui::Checkbox("Show FOV Circle", &CheatState::enable_circleFov);
    
    ImGui::Spacing();
    ImGui::Separator();
    ImGui::Text("Device Info");
    ImGui::Text("iOS: %s | JB: %s", 
              [[[UIDevice currentDevice] systemVersion] UTF8String], 
              isJailbroken() ? "Yes" : "No");
}

- (void)renderESP {
    if (!GetGameplayInstance) return;
    
    auto gameInstance = GetGameplayInstance();
    if (!gameInstance) return;
    
    CheatState::player_count = 0;
    CheatState::bot_count = 0;
    
    void *localPawn = getLocalPawn();
    if (!localPawn) return;
    
    Matrix4x4 viewMatrix = GetWorldToCamera();
    Matrix4x4 projectionMatrix = GetProjectionMatrixInternal();
    Vector3 localPlayerPosition = GetPlayerPosition(localPawn);
    
    monoList<void **> *enemyList = *(monoList<void **>**)((uint64_t)gameInstance + 0x168); // private readonly PawnList EnemyPawns
    if (!enemyList) return;
    
    int enemyCount = enemyList->getSize();
    for (int i = 0; i < enemyCount; i++) {
        void* enemyPawn = enemyList->getItems()[i];
        if (!enemyPawn) continue;
        
        void* enemyInfo = *(void **)((uint64_t)enemyPawn + 0x590); // protected PlayerInfo m_PlayerInfo // 2 lista
        if (!enemyInfo) continue;
        
        bool isRobot = IsRobot ? IsRobot(enemyInfo) : false;
        if (isRobot) {
            CheatState::bot_count++;
        } else {
            CheatState::player_count++;
        }
        
        if (!IsAlive(enemyPawn)) continue;
        
        Vector3 enemyPositionWorld = GetPlayerPosition(enemyPawn);
        Vector4 enemyPositionView = GetViewCoords(enemyPositionWorld, viewMatrix);
        Vector4 enemyPositionClip = GetClipCoords(enemyPositionView, projectionMatrix);
        
        if (enemyPositionClip.Z < 0.1f) continue;
        
        Vector3 enemyPositionNormalized = NormalizeCoords(enemyPositionClip);
        Vector2 enemyPositionScreen = GetScreenCoords(enemyPositionNormalized);
        
        void* headBone = *(void **)((uint64_t)enemyPawn + 0x2E8); // protected Transform m_HeadBone 
        if (!headBone) continue;
        
        Vector3 enemyHeadPositionWorld = GetTransformPositionInternal(headBone);
        Vector4 enemyHeadPositionView = GetViewCoords(enemyHeadPositionWorld, viewMatrix);
        Vector4 enemyHeadPositionClip = GetClipCoords(enemyHeadPositionView, projectionMatrix);
        enemyHeadPositionClip.Y = enemyHeadPositionClip.Y + 0.5f;
        Vector3 enemyHeadPositionNormalized = NormalizeCoords(enemyHeadPositionClip);
        Vector2 enemyHeadPositionScreen = GetScreenCoords(enemyHeadPositionNormalized);
        
        bool isVisible = IsEnemyVisible(enemyPawn, localPlayerPosition);
        float distance = Vector3::Distance(localPlayerPosition, enemyPositionWorld);
        
        if (distance > CheatState::distanceValue) continue;
        
        // Calculate box dimensions
        float boxHeight = float(enemyPositionScreen.Y - enemyHeadPositionScreen.Y);
        Recto rect = Recto(
            (enemyHeadPositionScreen.X - (boxHeight * 0.45f / 2)), 
            enemyHeadPositionScreen.Y, 
            boxHeight * 0.45f, 
            boxHeight
        );
        
        // Adjust colors based on visibility
        ImColor visibleColor = ImColor(
            isVisible ? CheatState::colorLines[0] : CheatState::colorLines[0] * 0.5f,
            isVisible ? CheatState::colorLines[1] : CheatState::colorLines[1] * 0.5f,
            isVisible ? CheatState::colorLines[2] : CheatState::colorLines[2] * 0.5f
        );
        
        // Draw ESP elements
        if (CheatState::show_esplines) {
            if (CheatState::line_position == 0) {
                ImGui::GetForegroundDrawList()->AddLine(
                    ImVec2(kWidth / 2, 0), 
                    ImVec2(enemyHeadPositionScreen.X, enemyHeadPositionScreen.Y), 
                    visibleColor, 
                    1.5f
                );
            } else {
                ImGui::GetForegroundDrawList()->AddLine(
                    ImVec2(kWidth / 2, kHeight), 
                    ImVec2(enemyPositionScreen.X, enemyPositionScreen.Y), 
                    visibleColor, 
                    1.5f
                );
            }
        }
        
        if (CheatState::show_espboxes) {
            if (CheatState::box_style == 0) {
                // Rectangle box
                ImGui::GetBackgroundDrawList()->AddRect(
                    ImVec2(rect.x, rect.y),
                    ImVec2(rect.get_max_width(), rect.get_max_height()),
                    ImColor(CheatState::colorBoxes[0], CheatState::colorBoxes[1], CheatState::colorBoxes[2]),
                    0.0f,
                    0,
                    1.5f
                );
            } else {
                // Corner box
                float cornerSize = std::min(rect.w, rect.h) * 0.25f;
                float lineThickness = 2.0f;
                ImColor boxColor = ImColor(CheatState::colorBoxes[0], CheatState::colorBoxes[1], CheatState::colorBoxes[2]);
                
                // Top left
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.x, rect.y + cornerSize), 
                    ImVec2(rect.x, rect.y), 
                    boxColor, lineThickness);
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.x, rect.y), 
                    ImVec2(rect.x + cornerSize, rect.y), 
                    boxColor, lineThickness);
                
                // Top right
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.get_max_width() - cornerSize, rect.y), 
                    ImVec2(rect.get_max_width(), rect.y), 
                    boxColor, lineThickness);
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.get_max_width(), rect.y), 
                    ImVec2(rect.get_max_width(), rect.y + cornerSize), 
                    boxColor, lineThickness);
                
                // Bottom left
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.x, rect.get_max_height() - cornerSize), 
                    ImVec2(rect.x, rect.get_max_height()), 
                    boxColor, lineThickness);
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.x, rect.get_max_height()), 
                    ImVec2(rect.x + cornerSize, rect.get_max_height()), 
                    boxColor, lineThickness);
                
                // Bottom right
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.get_max_width() - cornerSize, rect.get_max_height()), 
                    ImVec2(rect.get_max_width(), rect.get_max_height()), 
                    boxColor, lineThickness);
                ImGui::GetBackgroundDrawList()->AddLine(
                    ImVec2(rect.get_max_width(), rect.get_max_height()), 
                    ImVec2(rect.get_max_width(), rect.get_max_height() - cornerSize), 
                    boxColor, lineThickness);
                
                if (CheatState::filled_box) {
                    ImGui::GetBackgroundDrawList()->AddRectFilled(
                        ImVec2(rect.x, rect.y), 
                        ImVec2(rect.get_max_width(), rect.get_max_height()),
                        ImColor(
                            CheatState::boxFillColor[0], 
                            CheatState::boxFillColor[1], 
                            CheatState::boxFillColor[2], 
                            CheatState::boxFillColor[3] * (isVisible ? 1.0f : 0.5f)
                        )
                    );
                }
            }
        }
        
        if (CheatState::show_esp_health) {
            float health = GetHealth(enemyPawn);
            float maxHealth = *(float *)((uint64_t)enemyPawn + 0x78 + 0x38); // private AttackableTargetInfo m_AttackableInfo->protected float m_MaxHealth
            
            drawHealth(rect, health, maxHealth);
        }
        
        if (CheatState::show_esp_name) {
            NSString *enemyName = GetEnemyName(distance, enemyInfo);
            ImVec2 textPos = ImVec2(
                rect.x + (rect.w / 2) - (ImGui::CalcTextSize(enemyName.UTF8String).x / 2), 
                rect.y - 20
            );
            ImGui::GetBackgroundDrawList()->AddText(
                textPos, 
                ImColor(CheatState::colorName[0], CheatState::colorName[1], CheatState::colorName[2]), 
                enemyName.UTF8String
            );
        }
        
        if (CheatState::show_esp_distance) {
            NSString *distanceText = [NSString stringWithFormat:@"%.1fm", distance];
            ImVec2 textPos = ImVec2(
                rect.x + (rect.w / 2) - (ImGui::CalcTextSize(distanceText.UTF8String).x / 2), 
                rect.y + rect.h + 5
            );
            ImGui::GetBackgroundDrawList()->AddText(
                textPos, 
                ImColor(CheatState::colorDistance[0], CheatState::colorDistance[1], CheatState::colorDistance[2]), 
                distanceText.UTF8String
            );
        }
    }
}

- (void)renderAimbotVisuals {
    if (!CheatState::enable_aimbot) return;
    
    void* localPawn = getLocalPawn();
    if (!localPawn) return;
    
    Matrix4x4 viewMatrix = GetWorldToCamera();
    Matrix4x4 projectionMatrix = GetProjectionMatrixInternal();
    Vector3 localPlayerPosition = GetPlayerPosition(localPawn);
    
    void* gameInstance = GetGameplayInstance();
    if (!gameInstance) return;
    
    monoList<void **> *enemyList = *(monoList<void **>**)((uint64_t)gameInstance + 0x168); // private readonly PawnList EnemyPawns
    if (!enemyList) return;
    
    float closestDistance = std::numeric_limits<float>::infinity();
    float closestFovDistance = std::numeric_limits<float>::infinity();
    void* bestTarget = nullptr;
    Vector3 bestTargetPosition;
    Vector2 bestScreenPos;
    
    int enemyCount = enemyList->getSize();
    for (int i = 0; i < enemyCount; i++) {
        void* enemyPawn = enemyList->getItems()[i];
        if (!enemyPawn) continue;
        
        if (!IsAlive(enemyPawn)) continue;
        
        float health = GetHealth(enemyPawn);
        if (health <= 0) continue;
        
        Vector3 enemyPosition = GetPlayerPosition(enemyPawn);
        float distance = Vector3::Distance(localPlayerPosition, enemyPosition);
        
        if (distance > CheatState::max_distance) continue;
        
        void* targetBone = *(void **)((uint64_t)enemyPawn + 0x2E8); // protected Transform m_HeadBone 
        if (!targetBone) continue;
        
        Vector3 bonePosition = GetTransformPositionInternal(targetBone);
        
        // Adjust aim position based on setting
        if (CheatState::aim_location == 1) {
            bonePosition.y -= 0.2f; // Chest
        } else if (CheatState::aim_location == 2) {
            bonePosition.y -= 0.4f; // Legs/waist
        }
        
        Vector4 targetPosView = GetViewCoords(bonePosition, viewMatrix);
        Vector4 targetPosClip = GetClipCoords(targetPosView, projectionMatrix);
        
        if (targetPosClip.Z < 0.1f) continue;
        
        Vector3 targetPosNorm = NormalizeCoords(targetPosClip);
        Vector2 targetScreenPos = GetScreenCoords(targetPosNorm);
        
        if (targetScreenPos.X < 0 || targetScreenPos.X > kWidth ||
            targetScreenPos.Y < 0 || targetScreenPos.Y > kHeight) {
            continue;
        }
        
        float centerX = kWidth / 2.0f;
        float centerY = kHeight / 2.0f;
        float dx = targetScreenPos.X - centerX;
        float dy = targetScreenPos.Y - centerY;
        float fovDistance = sqrt(dx * dx + dy * dy);
        
        bool selectTarget = false;
        
        if (CheatState::aim_target == 0) {
            if (distance < closestDistance) {
                closestDistance = distance;
                selectTarget = true;
            }
        } else if (CheatState::aim_target == 1) {
            if (fovDistance <= CheatState::circleSizeValue) {
                if (fovDistance < closestFovDistance) {
                    closestFovDistance = fovDistance;
                    selectTarget = true;
                }
            }
        }
        
        if (selectTarget) {
            bestTarget = enemyPawn;
            bestTargetPosition = bonePosition;
            closestDistance = distance;
            bestScreenPos = targetScreenPos;
        }
    }
    
    if (bestTarget) {
        if (CheatState::aim_visual_style == 0) {
            // Circle
            ImGui::GetForegroundDrawList()->AddCircle(
                ImVec2(bestScreenPos.X, bestScreenPos.Y), 
                5.0f,
                ImColor(255, 0, 0, 200), 
                12, 
                2.0f
            );
        } else {
            // Line
            ImGui::GetForegroundDrawList()->AddLine(
                ImVec2(kWidth / 2, kHeight / 2),
                ImVec2(bestScreenPos.X, bestScreenPos.Y),
                ImColor(255, 0, 0, 200),
                1.5f
            );
        }
        
        // Handle aiming logic
        [self handleAimingToTarget:bestTarget position:bestTargetPosition localPawn:localPawn distance:closestDistance];
    }
}

- (void)handleAimingToTarget:(void*)target position:(Vector3)targetPos localPawn:(void*)localPawn distance:(float)distance {
    bool shouldAim = true;
    
    // Check activation conditions
    if (CheatState::aim_trigger == 1) {
        shouldAim = GetIsFiring(localPawn);
    } else if (CheatState::aim_trigger == 2) {
        shouldAim = GetIsAiming(localPawn);
    }
    
    if (!shouldAim) return;
    
    static Vector3 lastTargetPosition = Vector3(0, 0, 0);
    static bool wasTargeting = false;
    static float lastShotTime = 0.0f;
    static int burstCounter = 0;
    
    float currentTime = ImGui::GetTime();
    bool isFiring = GetIsFiring(localPawn);
    
    // Update burst counter
    if (isFiring) {
        if (currentTime - lastShotTime > 0.1f) {
            burstCounter++;
            lastShotTime = currentTime;
        }
    } else {
        if (currentTime - lastShotTime > 0.5f) {
            burstCounter = 0;
        }
    }
    
    // Get camera position
    void* mainCamera = GetMainCamera();
    if (!mainCamera) return;
    void* mainView = GetComponentTransform(mainCamera);
    if (!mainView) return;
    Vector3 cameraPosition = GetTransformPositionInternal(mainView);
    
    // Predict target position
    Vector3 predictedPosition = targetPos;
    
    if (wasTargeting && Vector3::Distance(lastTargetPosition, Vector3(0,0,0)) > 0.1f) {
        Vector3 targetVelocity;
        targetVelocity.x = targetPos.x - lastTargetPosition.x;
        targetVelocity.y = targetPos.y - lastTargetPosition.y;
        targetVelocity.z = targetPos.z - lastTargetPosition.z;
        
        float predictionFactor = 0.02f * (distance / 10.0f);
        predictionFactor = std::min(predictionFactor, 0.10f);
        
        predictedPosition.x = targetPos.x + (targetVelocity.x * predictionFactor);
        predictedPosition.y = targetPos.y + (targetVelocity.y * predictionFactor);
        predictedPosition.z = targetPos.z + (targetVelocity.z * predictionFactor);
    }
    
    lastTargetPosition = targetPos;
    wasTargeting = true;
    
    // Calculate aim direction
    Vector3 aimDirection;
    aimDirection.x = predictedPosition.x - cameraPosition.x;
    aimDirection.y = predictedPosition.y - cameraPosition.y;
    aimDirection.z = predictedPosition.z - cameraPosition.z;
    
    // Apply recoil compensation
    float recoilCompensation = CheatState::recoil_amount * 0.01f;
    if (shouldAim) {
        float verticalRecoil = std::min(burstCounter * recoilCompensation, recoilCompensation * 10);
        aimDirection.y -= verticalRecoil;
        
        if (burstCounter > 5) {
            float horizontalCompensation = -0.01f * recoilCompensation;
            aimDirection.x += horizontalCompensation;
        }
    }
    
    // Calculate target rotation
    Quaternion targetAim = Quaternion::LookRotation(aimDirection, Vector3::Up());
    Quaternion currentAim = getAimRotation(localPawn);
    
    // Adjust aim speed based on distance and health
    float aimSpeed = CheatState::aim_speed * 0.01f;
    float distanceFactor = 1.0f - (distance / CheatState::max_distance * 0.5f);
    float health = GetHealth(target);
    float healthFactor = 1.0f - (health / 100.0f * 0.3f);
    
    aimSpeed *= (1.0f + (distanceFactor + healthFactor) * 0.4f);
    aimSpeed = std::min(std::max(aimSpeed, 0.01f), 0.9f);
    
    // Smoothly interpolate to target rotation
    Quaternion finalAim = Quaternion::Slerp(currentAim, targetAim, aimSpeed);
    
    // Apply additional recoil compensation for burst fire
    if (burstCounter > 3) {
        Vector3 forward = finalAim * Vector3::Forward();
        forward.x -= 0.005f * burstCounter * recoilCompensation;
        finalAim = Quaternion::LookRotation(forward, Vector3::Up());
    }
    
    // Set the final aim rotation
    setAimRotation(localPawn, finalAim);
}

#pragma mark - Utility Functions

bool isJailbroken() {
    NSArray *jailbreakIndicators = @[
        @"/Library/MobileSubstrate/MobileSubstrate.dylib",
        @"/bin/bash",
        @"/etc/apt",
        @"/usr/sbin/sshd",
        @"/var/jb/usr/sbin/sshd",
        @"/var/jb"
    ];
    
    for (NSString *path in jailbreakIndicators) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            return true;
        }
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"cydia://package/com.example.package"]]) {
        return true;
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sileo://source/example"]]) {
        return true;
    }
    
    return false;
}

#pragma mark - MTKViewDelegate

- (void)mtkView:(MTKView*)view drawableSizeWillChange:(CGSize)size {
    // Handle size changes if needed
}

#pragma mark - Touch Handling

- (void)updateIOWithTouchEvent:(UIEvent *)event {
    UITouch *anyTouch = event.allTouches.anyObject;
    CGPoint touchLocation = [anyTouch locationInView:self.view];
    ImGuiIO &io = ImGui::GetIO();
    io.AddMousePosEvent(touchLocation.x, touchLocation.y);
    
    BOOL hasActiveTouch = NO;
    for (UITouch *touch in event.allTouches) {
        if (touch.phase != UITouchPhaseEnded && touch.phase != UITouchPhaseCancelled) {
            hasActiveTouch = YES;
            break;
        }
    }
    io.AddMouseButtonEvent(0, hasActiveTouch);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateIOWithTouchEvent:event];
}

@end