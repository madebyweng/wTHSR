//
//  MMProperty.m
//
//  This is the source code of wTHSR for iOS
//  It is licensed under GNU GPL v. 3.
//
//  Created by Harry Weng.
//  Copyright © 2015 MadebyWeng. All rights reserved.
//

#import "MMProperty.h"

@interface NSString (Capitalized)

- (NSString *)sentenceCapitalizedString; // sentence == entire string
- (NSString *)realSentenceCapitalizedString; // sentence == real sentences
- (NSString *)safelyPropertyString;
@end

@implementation NSString (Capitalized)

- (NSString *)sentenceCapitalizedString {
    if (![self length]) {
        return [NSString string];
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    return [uppercase stringByAppendingString:lowercase];
}

- (NSString *)realSentenceCapitalizedString {
    __block NSMutableString *mutableSelf = [NSMutableString stringWithString:self];
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationBySentences
                          usingBlock:^(NSString *sentence, NSRange sentenceRange, NSRange enclosingRange, BOOL *stop) {
                              [mutableSelf replaceCharactersInRange:sentenceRange withString:[sentence sentenceCapitalizedString]];
                          }];
    return [NSString stringWithString:mutableSelf]; // or just return mutableSelf.
}

- (NSString *)uncapitalizedString {
    NSMutableArray *items = [NSMutableArray new];
    NSString *word = @"";
    __block NSString *ww = word;
    [self enumerateSubstringsInRange:NSMakeRange(0, [self length])
                             options:NSStringEnumerationByComposedCharacterSequences
                          usingBlock:^(NSString *character, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                              
                              BOOL isUppercase  = [character isEqualToString:[character uppercaseString]];
                              if (isUppercase) {
                                  
                                  [items addObject:ww];
                                  ww = @"";
                              }
                              
                              ww = [ww stringByAppendingString:character.lowercaseString];
                              
                              if (substringRange.location == self.length-1) {
                                  [items addObject:ww];
                              }
                              
                          }];
    
    return [items componentsJoinedByString:@"_"];
}

+ (NSDictionary *)systemProperty {
    return @{@"uid": @"id",
             @"description_": @"description"};

}

- (NSString *)safelyPropertyString {
    NSString *newKey = [NSString systemProperty][self];
    if (newKey) return newKey;
    
    return nil;
}

@end




@class MMProperty;

@implementation NSObject (Property)


+ (id)instanceWithDictionary:(NSDictionary *)dictionary {
    return [[[self class] alloc] initWithPropertyDictionary:dictionary];
}




- (id)initWithPropertyDictionary:(NSDictionary*)dictionary {
    
    self = [self init];
    if (self) {
        
        NSMutableArray *properties = [NSMutableArray new];
        
        Class topclass = [NSObject class];
        Class parsingClass= self.class;
        while(parsingClass!=topclass)
        {
            [self parsePropertiesForClass:parsingClass withProperties:properties];
            parsingClass=[parsingClass superclass];
            if (parsingClass==nil)
                break;
        }
        
        
        id val = nil;
        for(MMProperty *p in properties)
        {
            //NSLog(@"name %@", p.name);
            val=[dictionary objectForKey:p.key];
            NSString *name = p.name;
            //            if (p.name.safelyPropertyString) {
            //                name = p.name.safelyPropertyString;
            //            }
            
            
            if (val==nil)
                val=[dictionary objectForKey:p.name];
            
            if (val==nil)
                val=[dictionary objectForKey:[p.name safelyPropertyString]];
            
            if (val==nil)
                continue;
            
            if (val==[NSNull null])
                val=nil;
            
            switch(p.type)
            {
                case classTypeId:
                case classTypeClass:
                    if ((val!=nil) && ([p.typeClass isSubclassOfClass:[MMModel class]]))
                    {
                        if ([[val class] isSubclassOfClass:[NSDictionary class]])
                        {
                            [self setValue:val forKey:name];
                        }
                        else if ([[val class] isSubclassOfClass:[MMModel class]])
                        {
                            [self setValue:val forKey:name];
                        }
                        else
                            [self setValue:nil forKey:name];
                        
                    }
                    else
                    {
                        [self setValue:val forKey:name];
                    }
                    break;
                case classTypeChar:
                    if ([val isKindOfClass:[NSNumber class]]) {
                        if ([val charValue]<=1)
                            val=[NSNumber numberWithBool:[val boolValue]];
                    } else if ([val isKindOfClass:[NSString class]]) {
                        if ([val boolValue])
                            val=[NSNumber numberWithBool:[val boolValue]];
                    }
                    
                    [self setValue:val forKey:name];
                    break;
                case classTypeString:
                    [self setValue:val forKey:name];
                    break;
                case classTypeNumber:
                case classTypeShort:
                case classTypeInteger:
                case classTypeLong:
                case classTypeFloat:
                case classTypeDouble:
                    if ([val isKindOfClass:[NSString class]]) {
                        val = [NSNumber numberWithUnsignedLongLong:[val longLongValue]];
                    }
                    [self setValue:val forKey:name];
                    break;
                case classTypeArray:
                    if (val) {
                        [self setValue:val forKey:name];
                    }
                    break;
                case classTypeDictionary:
                    [self setValue:val forKey:name];
                    break;
                case classTypeData:
                    [self setValue:val forKey:name];
                    break;
                case classTypeDate:
                    if (val) {
                        [self setValue:val forKey:name];
                        //[self setValue:[self getDateFromId:val] forKey:p.name];
                    }
                    else
                    {
                        [self setValue:nil forKey:name];
                    }
                    break;
                default:
                    break;
            }

        }
        
    }
    return self;
    
}


- (void)parsePropertiesForClass:(Class)class withProperties:(NSMutableArray *)properties {
    
    
    unsigned int outCount, i;
    objc_property_t *props = class_copyPropertyList(class, &outCount);
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = props[i];
        const char *propName = property_getName(property);
        if(propName)
        {
            NSString *propertyName = [NSString stringWithCString:propName encoding:NSASCIIStringEncoding];
            
            [properties addObject:[[MMProperty alloc] initWithName:propertyName forProperty:property]];
        }
        
    }
    
    free(props);
    
    
}

- (NSDictionary *)properties
{
	
    NSMutableArray *propertyLists = [NSMutableArray new];
    
    Class topclass = [NSObject class];
    Class parsingClass= self.class;
    while(parsingClass!=topclass)
    {
        [self parsePropertiesForClass:parsingClass withProperties:propertyLists];
        parsingClass=[parsingClass superclass];
        if (parsingClass==nil)
            break;
    }
    
	// Extract the data into a dictionary.
	NSMutableDictionary * temp = [NSMutableDictionary new];
	
	// Re-set it back to the dictionary.
    for (MMProperty *property in propertyLists) {
        
        id value = [self valueForKey:property.name];
        
        // If we have a value, save it to the dictionary
        if (value)
            [temp setObject:value forKey:property.name];
        
    }
    
    return temp;
}



@end



@implementation MMProperty

- (id)initWithName:(NSString *)propName forProperty:(objc_property_t)property
{
    if ((self=[super init]))
    {
        _name=[propName copy];
        _key=[_name uncapitalizedString];
//        if (_name.safelyPropertyString) {
//            _key = _name.safelyPropertyString;
//        }
        
        const char *attributes = property_getAttributes(property);
        NSString *typeStr=[NSString stringWithCString:attributes encoding:NSASCIIStringEncoding];
        NSString *type=[[typeStr componentsSeparatedByString:@","] objectAtIndex:0];
        
        if ([type hasPrefix:@"T@"])
        {
            if ([type isEqualToString:@"T@"])
            {
                _type=classTypeId;
            }
            else
            {
                NSString *actualType=[type substringWithRange:NSMakeRange(3, type.length-4)];
                
                _typeClass=NSClassFromString(actualType);
                if (_typeClass==nil)
                    @throw [NSException exceptionWithName:@"Missing Reflection Class" reason:[NSString stringWithFormat:@"Can not find class '%@'.",actualType] userInfo:nil];
                
                if ([_typeClass isSubclassOfClass:[NSString class]])
                    _type=classTypeString;
                else if ([_typeClass isSubclassOfClass:[NSNumber class]])
                    _type=classTypeNumber;
                else if ([_typeClass isSubclassOfClass:[NSDate class]])
                    _type=classTypeDate;
                else if ([_typeClass isSubclassOfClass:[NSData class]])
                    _type=classTypeData;
                else if ([_typeClass isSubclassOfClass:[NSDictionary class]])
                    _type=classTypeDictionary;
                else if ([_typeClass isSubclassOfClass:[NSArray class]])
                {
                    _typeClass=NSClassFromString(actualType);
                    if (_typeClass==nil)
                        _typeClass=[NSMutableArray class];
                    
                    _type=classTypeArray;
                }
                else
                    _type=classTypeClass;
            }
        }
        else
        {
            if ([type isEqualToString:@"Tc"])
                _type=classTypeChar;
            else if ([type isEqualToString:@"Ts"])
                _type=classTypeShort;
            else if (([type isEqualToString:@"Ti"]) || ([type isEqualToString:@"Tq"]))
                _type=classTypeInteger;
            else if ([type isEqualToString:@"Tl"])
                _type=classTypeLong;
            else if ([type isEqualToString:@"Tf"])
                _type=classTypeFloat;
            else if ([type isEqualToString:@"Td"])
                _type=classTypeDouble;
            else
                _type=classTypeUnknown;
        }
    }
    
    return self;
}

@end
