//
//  KSMacro.h
//  KSPersonalFinance
//
//  Created by Serg Bla on 21.05.16.
//  Copyright © 2016 Serg Kostiuk. All rights reserved.
//

#ifndef KSMacro_h
#define KSMacro_h

#define KSConstString(name, string) static NSString * const name   = string

#define KSConstNSInteger(name, value) static const NSInteger  name = value;

#define KSBlockCall(block, ...)\
do { \
typeof(block) var = block; \
if(var) { \
var(__VA_ARGS__); \
} \
} while(0);

#define KSReturnValueIfNil(obj, value) \
if(!(obj)) { \
return value; \
}

#define KSEmpty

#define KSRerurnIfNil(obj)\
KSReturnValueIfNil(obj, KSEmpty)

#define KSRerurnNilIfNil(obj)\
KSReturnValueIfNil(obj, 0)

#endif /* KSMacro_h */
