#import <Cocoa/Cocoa.h>
#include <mach/mach_time.h>

@interface SODWindow : NSWindow {
    
}
@end

@implementation SODWindow
-(id)init {
    // load the image and put it in a view
    NSImage * img = [[NSImage alloc] initWithContentsOfFile:IMAGE_FILE];
    NSImageView* imgView = [[NSImageView alloc] init];
    [imgView setImage:img];
    
    // select a random position for the window to appear
    srand(mach_absolute_time());
    float x, y;
    
    // choose a random side
    NSSize screenSize = [[NSScreen mainScreen] frame].size;
    int side = rand() % 4;
    switch (side) {
        case 0:
        x = rand() % (int)(screenSize.width - [img size].width);
        y = -[img size].height;
        break;
        
        case 1:
        x = rand() % (int)(screenSize.width - [img size].width);
        y = screenSize.height;
        break;
        
        case 2:
        x = -[img size].width;
        y = rand() % (int)(screenSize.height - [img size].height);
        break;
        
        default:
        x = screenSize.width + [img size].width;
        y = rand() % (int)(screenSize.height - [img size].height);
        break;
    }
    
    // create the window
    self = [super initWithContentRect:NSMakeRect(x, y,
                                                [img size].width,
                                                [img size].height)
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];
    
    // window setup
    [self setLevel:NSScreenSaverWindowLevel];
    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self setContentView:imgView];
    [self makeKeyAndOrderFront:nil];
    
    // animate the window
    NSRect frame = [self frame];
    float origX = frame.origin.x;
    float origY = frame.origin.y;
    
    switch (side) {
        case 0: frame.origin.y = 0; break;
        case 1: frame.origin.y = screenSize.height - [img size].height; break;
        case 2: frame.origin.x = 0; break;
        default: frame.origin.x = screenSize.width - [img size].width; break;
    }
    
    [self setFrame:frame display:YES animate:YES];
    sleep(1);
    frame.origin.x = origX;
    frame.origin.y = origY;
    [self setFrame:frame display:YES animate:YES];
    
    return self;
}

-(BOOL)hasShadow { return NO; }
-(BOOL)ignoresMouseEvent { return YES; }
@end

int main(int argc, char** argv) {
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSApplication* app = [NSApplication sharedApplication];
    
    [[SODWindow alloc] init];
    
    [pool drain];
    return 0;
}