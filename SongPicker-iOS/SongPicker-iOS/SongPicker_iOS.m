//
//  SongPicker_iOS.m
//  libSongPicker-iOS
//
//  Created by Richard Lovejoy (rich@newpixel.com) on 1/16/13.
//  Copyright (c) 2013 Richard Lovejoy. All rights reserved.
//
/*
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "FlashRuntimeExtensions.h"
#import "SongPickerHelper.h"

#define N_FUNCTIONS (5)

SongPickerHelper *songPickerHelper;

//------------------------------------
//
// Public Methods.
//
//------------------------------------
FREObject pickSong(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    [songPickerHelper pickSongFromMediaLibrary];
    
    return NULL;
}

FREObject playSong(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    // get the string value out of the element
    const uint8_t *idCString;
    uint32_t strLen;
    FREGetObjectAsUTF8(argv[0], &strLen, &idCString);

    // get the double value out of the element
    double newPosition;
    FREGetObjectAsDouble(argv[1], &newPosition);
    
    NSString *idString = [NSString stringWithUTF8String:(char *)idCString];
    NSNumber *pid = ([idString length] == 0) ? nil : [NSNumber numberWithUnsignedLongLong:[idString longLongValue]];
    [songPickerHelper playSong:pid playheadPosition:newPosition];
    
    return NULL;
    
}

FREObject pauseSong(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    [songPickerHelper pauseSong];
    
    return NULL;
    
}

FREObject stopSong(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    
    [songPickerHelper stopSong];
    
    return NULL;
    
}

//------------------------------------
//
// Required Methods.
//
//------------------------------------

// initStub()
//
// An init function is necessary in the Android implementation of this extension.
// Therefore, an analogous function is necessary in the iOS implementation to make
// the ActionScript interface identical for all implementations.
// We'll use this to create the helper.

FREObject SNG_PKR_initStub(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[]) {
    
	NSLog(@"init Stub Called");
    if (!songPickerHelper)
    {
        songPickerHelper = [[SongPickerHelper alloc] init];
        [songPickerHelper setContext:ctx];
    }
    
	return nil;
}

// ContextInitializer()
//
// The context initializer is called when the runtime creates the extension context instance.
void SNG_PKR_ContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx,
                                uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    //we expose two methods to ActionScript
	*numFunctionsToTest = N_FUNCTIONS ;
    
	FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * N_FUNCTIONS);
	func[0].name = (const uint8_t*) "pickSong";
	func[0].functionData = NULL;
    func[0].function = &pickSong;
    
	func[1].name = (const uint8_t*) "playSong";
	func[1].functionData = NULL;
	func[1].function = &playSong;

	func[2].name = (const uint8_t*) "pauseSong";
	func[2].functionData = NULL;
	func[2].function = &pauseSong;

	func[3].name = (const uint8_t*) "stopSong";
	func[3].functionData = NULL;
	func[3].function = &stopSong;
	
    func[4].name = (const uint8_t*) "init";
	func[4].functionData = NULL;
	func[4].function = &SNG_PKR_initStub;
    
	*functionsToSet = func;
	
}

// ContextFinalizer()
//
// The context finalizer is called when the extension's ActionScript code
// calls the ExtensionContext instance's dispose() method.
// If the AIR runtime garbage collector disposes of the ExtensionContext instance, the runtime also calls
// ContextFinalizer().

void SNG_PKR_ContextFinalizer(FREContext ctx) {
    
    NSLog(@"Entering ContextFinalizer()");
    
    if (songPickerHelper)
    {
        [songPickerHelper release];
    }
    
    NSLog(@"Exiting ContextFinalizer()");
    
}

// ExtInitializer()
//
// The extension initializer is called the first time the ActionScript side of the extension
// calls ExtensionContext.createExtensionContext() for any context.

void SPExtInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet,
                       FREContextFinalizer* ctxFinalizerToSet) {
    
    NSLog(@"Entering ExtInitializer()");
    
	*extDataToSet = NULL;
	*ctxInitializerToSet = &SNG_PKR_ContextInitializer;
	*ctxFinalizerToSet = &SNG_PKR_ContextFinalizer;
    
    NSLog(@"Exiting ExtInitializer()");
}



// ExtFinalizer()
//
// The extension finalizer is called when the runtime unloads the extension.
// However, it is not always called.

void SPExtFinalizer(void* extData) {
    
    NSLog(@"Entering ExtFinalizer()");
	return;
}
