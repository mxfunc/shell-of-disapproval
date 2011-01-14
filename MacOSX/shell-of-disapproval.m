#import <Cocoa/Cocoa.h>
#include <mach/mach_time.h>

@interface SODWindow : NSWindow {
    
}
@end

@implementation SODWindow
-(id)init {
    // load the image and put it in a view
    NSImage * sod = [[NSImage alloc] initWithContentsOfFile:IMAGE_FILE];
    NSImageView* sodView = [[NSImageView alloc] init];
    [sodView setImage:sod];
    
    // select a random position for the window to appear
    srand(mach_absolute_time());
    int x = rand() % (int)([[NSScreen mainScreen] frame].size.width -
                           [sod size].width);
    float y = -[sod size].height;
    
    // create the window
    self = [super initWithContentRect:NSMakeRect(x, y, [sod size].width, -y)
                            styleMask:NSBorderlessWindowMask
                              backing:NSBackingStoreBuffered
                                defer:NO];
    
    // window setup
    [self setLevel:NSScreenSaverWindowLevel];
    [self setContentView:sodView];
    [self setOpaque:NO];
    [self setBackgroundColor:[NSColor clearColor]];
    [self makeKeyAndOrderFront:nil];
    
    // animate the window
    NSRect frame = [self frame];
    frame.origin.y = 0;
    [self setFrame:frame display:YES animate:YES];
    sleep(1);
    frame.origin.y = y;
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