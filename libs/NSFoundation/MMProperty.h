//
//  MMProperty.h
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#define __ENABLE_MODEL_NOSQL__      0
#define __ENABLE_MODEL_MODELKIT__   0
#define __ENABLE_MODEL_NSOJECT__    1

#if     __ENABLE_MODEL_NOSQL__
#import "MMNoSQLModel.h"
#undef  MMModel
#define MMModel     MMNoSQLModel

#elif   __ENABLE_MODEL_MODELKIT__
#import "MKitModel.h"
#undef  MMModel
#define MMModel     MKitModel

#elif   __ENABLE_MODEL_NSOJECT__
#undef  MMModel
#define MMModel     NSObject
#endif

@interface NSObject (Property)

+ (id)instanceWithDictionary:(NSDictionary *)dictionary;
- (id)initWithPropertyDictionary:(NSDictionary *)dictionary;
- (NSDictionary*)properties;

@end


/** Property type enumeration */
typedef enum
{
    // class types
    classTypeId           =-1,        /**< id type */
    classTypeClass        =0,         /**< Class type that isn't id, nsarray, nsdictionary, etc. */
    classTypeArray        =2,         /**< NSArray/NSMutableArray */
    classTypeDictionary   =3,         /**< NSDictionary/NSMutableDictionary */
    classTypeString       =4,         /**< NSString/NSMutableString */
    classTypeNumber       =5,         /**< NSNumber */
    classTypeData         =6,         /**< NSData/NSMutableData */
    classTypeDate         =7,         /**< NSDate */
    
    // primitive types
    classTypeChar         =100,       /**< Char or BOOL type */
    classTypeShort        =101,       /**< Short type */
    classTypeInteger      =102,       /**< Integer type */
    classTypeLong         =103,       /**< Long type */
    classTypeFloat        =104,       /**< Float type */
    classTypeDouble       =105,       /**< Double type */
    
    // unknown
    classTypeUnknown      =666        /**< Unknown type */
} MMPropertyType;

/**
 * Wraps an object property reflection info
 */
@interface MMProperty : NSObject

/**
 * Initializes a new instance
 * @param propName Name of the property
 * @param property The run time objc_property_t type
 * @result New instance.
 */
-(id)initWithName:(NSString *)propName forProperty:(objc_property_t)property;

@property (readonly) NSString *name;                /**< Name of the property */
@property (readonly) NSString *key;                 /**< Key of dictionary */
@property (readonly) MMPropertyType type;           /**< Type of property */
@property (readonly) Class typeClass;               /**< Class type, if any */

@end
