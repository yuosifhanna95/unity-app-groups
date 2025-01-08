#import <Foundation/Foundation.h>

char* MakeCStringCopy(const char* cString) {
  if (cString == NULL) {
    return NULL;
  }
  size_t length = strlen(cString);
  char* copy = (char*)malloc(length + 1);
  if (copy != NULL) {
    strcpy(copy, cString);
  }
  return copy;
}

NSString* _GetAppGroupPathInternal(NSString* groupIdentifier) {
  NSURL* containerURL = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:groupIdentifier];
  if (containerURL == nil) {
    NSLog(@"Failed to get container URL for group identifier: %@", groupIdentifier);
    return nil;
  }
  return [containerURL path];
}

const char* _GetAppGroupPath(const char* groupIdentifierCString) {
  NSString* groupIdentifier = [NSString stringWithUTF8String:groupIdentifierCString];
  NSString* appGroupPath = _GetAppGroupPathInternal(groupIdentifier);
  return MakeCStringCopy([appGroupPath UTF8String]);
}

const char* _SetString(const char* filePathCString, const char* keyNameCString, const char* textContentCString) {
    
    NSString* filePath = [NSString stringWithUTF8String:filePathCString];
    NSString* keyName = [NSString stringWithUTF8String:keyNameCString];
    NSString* textContent = [NSString stringWithUTF8String:textContentCString];
    
    NSString *myFile=[[NSBundle mainBundle] pathForResource:@"group.com.companyYH.WheelOfCoins.on.plist" ofType:@"plist"];
    NSArray*docDir=NSSearchPathForDirectoriesInDomains(filePath, NSUserDomainMask, YES);
    //NSString*filePath=[docDir objectAtIndex:0];
    NSString*plistPath=[filePath stringByAppendingPathComponent:@"group.com.companyYH.WheelOfCoins.on.plist"];

    //Check plist's existance using FileManager
    NSError*err=nil;
    NSFileManager*fManager=[NSFileManager defaultManager];

    if(![fManager fileExistsAtPath:plistPath])
    {
        //file doesn't exist, copy file from bundle to documents directory

        NSString*bundlePath=[[NSBundle mainBundle] pathForResource:@"group.com.companyYH.WheelOfCoins.on" ofType:@"plist"];
        [fManager copyItemAtPath:bundlePath toPath:plistPath error:&err];
    }

    //Get the dictionary from the plist's path
    NSMutableDictionary*plistDict=[[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
     //Manipulate the dictionary
     [plistDict setObject:textContent forKey:keyName];
     //Again save in doc directory.
     [plistDict writeToFile:myFile atomically:YES];
}
