//
//  BezelWindow.m
//  Jumpcut
//
//  Created by Steve Cook on 4/3/06.
//  Copyright 2006 Steve Cook. All rights reserved.
//
//  This code is open-source software subject to the MIT License; see the homepage
//  at <http://jumpcut.sourceforge.net/> for details.

#import "BezelWindow.h"

@implementation BezelWindow

- (id)initWithContentRect:(NSRect)contentRect
				styleMask:(unsigned int)aStyle
  				backing:(NSBackingStoreType)bufferingType
					defer:(BOOL)flag
{
	self = [super initWithContentRect:contentRect
							styleMask:NSBorderlessWindowMask
							backing:NSBackingStoreBuffered
							defer:NO];
	if ( self )
	{
		[self setOpaque:NO];
		[self setAlphaValue:1.0];
		[self setOpaque:NO];
		[self setHasShadow:NO];
		[self setMovableByWindowBackground:NO];
		[self setBackgroundColor:[self sizedBezelBackgroundWithRadius:25.0 withAlpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"bezelAlpha"]]];
		float lineHeight = 16;
		NSRect textFrame = NSMakeRect(12, 12, [self frame].size.width - 24, 8 * lineHeight);
		textField = [[RoundRecTextField alloc] initWithFrame:textFrame];
		[[self contentView] addSubview:textField];
		[textField setEditable:NO];
		[textField setTextColor:[NSColor whiteColor]];
		[textField setBackgroundColor:[NSColor colorWithCalibratedWhite:0.1 alpha:.45]];
		[textField setDrawsBackground:YES];
		[textField setBordered:NO];
		[textField setAlignment:NSCenterTextAlignment];
		NSRect charFrame = NSMakeRect(([self frame].size.width - (2 * lineHeight)) / 2, 150, 1.75 * lineHeight, 1.75 * lineHeight);
		charField = [[RoundRecTextField alloc] initWithFrame:charFrame];
		[[self contentView] addSubview:charField];
		[charField setEditable:NO];
		[charField setTextColor:[NSColor whiteColor]];
		[charField setBackgroundColor:[NSColor colorWithCalibratedWhite:0.1 alpha:.45]];
		[charField setDrawsBackground:YES];
		[charField setBordered:NO];
		[charField setAlignment:NSCenterTextAlignment];
		[self setInitialFirstResponder:textField];
		icon = [NSImage imageNamed:@"net.sf.jumpcut.ghost_scissors_small.png"];
		if ( [icon isValid] ) {
			NSRect iconFrame = NSMakeRect( ([self frame].size.width - [icon size].width) / 2, [self frame].size.height - [icon size].height - 24, [icon size].width, [icon size].height);
			iconView = [[NSImageView alloc] initWithFrame:iconFrame];
			[iconView setImage:icon];
			[[self contentView] addSubview:iconView];
		}
		return self;
	}
	return nil;
}

- (void) setAlpha:(float)newValue
{
	[self setBackgroundColor:[self sizedBezelBackgroundWithRadius:25.0 withAlpha:[[NSUserDefaults standardUserDefaults] floatForKey:@"bezelAlpha"]]];
	[[self contentView] setNeedsDisplay:YES];
}

- (NSString *)title
{
	return title;
}

- (void)setTitle:(NSString *)newTitle
{
	[newTitle retain];
	[title release];
	title = newTitle;
}

- (NSString *)text
{
	return bezelText;
}

- (void)setCharString:(NSString *)newChar
{
	[newChar retain];
	[charString release];
	charString = newChar;
	[charField setStringValue:charString];
}

- (void)setText:(NSString *)newText
{
	[newText retain];
	[bezelText release];
	bezelText = newText;
	[textField setStringValue:bezelText];
}

- (void)setFrame:(NSRect)frameRect display:(BOOL)displayFlag animate:(BOOL)animationFlag
{
	[super setFrame:frameRect display:displayFlag animate:animationFlag];
}

- (NSColor *)roundedBackgroundWithRect:(NSRect)bgRect withRadius:(float)radius withAlpha:(float)alpha
{
	NSImage *bg = [[NSImage alloc] initWithSize:bgRect.size];
	[bg lockFocus];
	// I'm not at all clear why this seems to work
	NSRect dummyRect = NSMakeRect(0, 0, [bg size].width, [bg size].height);
	NSBezierPath *roundedRec = [NSBezierPath bezierPathWithRoundRectInRect:dummyRect radius:radius];
	[[NSColor colorWithCalibratedWhite:0.1 alpha:alpha] set];
    [roundedRec fill];
	[bg unlockFocus];
	return [NSColor colorWithPatternImage:[bg autorelease]];
}

- (NSColor *)sizedBezelBackgroundWithRadius:(float)radius withAlpha:(float)alpha
{
	return [self roundedBackgroundWithRect:[self frame] withRadius:radius withAlpha:alpha];
}

-(BOOL)canBecomeKeyWindow
{
	return YES;
}

- (void)dealloc
{
	[textField release];
	[charField release];
	[iconView release];
	[super dealloc];
}

- (BOOL)performKeyEquivalent:(NSEvent*) theEvent
{
	if ( [self delegate] )
	{
		[delegate performSelector:@selector(processBezelKeyDown:) withObject:theEvent];
		return YES;
	}
	return NO;
}

- (void)keyDown:(NSEvent *)theEvent {
	if ( [self delegate] )
	{
		[delegate performSelector:@selector(processBezelKeyDown:) withObject:theEvent];
	}
}

- (void)flagsChanged:(NSEvent *)theEvent {
	if ( !    ( [theEvent modifierFlags] & NSCommandKeyMask )
		 && ! ( [theEvent modifierFlags] & NSAlternateKeyMask )
		 && ! ( [theEvent modifierFlags] & NSControlKeyMask )
		 && ! ( [theEvent modifierFlags] & NSShiftKeyMask )
		 && [ self delegate ]
		 )
	{
		[delegate performSelector:@selector(metaKeysReleased)];
	}
}
		
- (id)delegate {
    return delegate;
}

- (void)setDelegate:(id)newDelegate {
    delegate = newDelegate;
}


@end
