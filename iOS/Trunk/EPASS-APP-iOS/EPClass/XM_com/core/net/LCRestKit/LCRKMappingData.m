#import "LCRKMappingData.h"


NSDictionary *LCRKModuleListMappingConfigurationForKey(NSString *mappingKey)
{
    Class aClass = nil;
    
    if (mappingKey.length > 0) {
        aClass = NSClassFromString(mappingKey);
    }
    
    if (aClass) {
        return @{@"data.modelList":aClass};
    }
    
    return nil;
}

NSDictionary *LCRKXMShoppingCartModelListMappingConfigurationForKey(NSString *mappingKey)
{
    Class aClass = nil;
    
    if (mappingKey.length > 0) {
        aClass = NSClassFromString(mappingKey);
    }
    
    if (aClass) {
        return @{@"data":aClass};
    }
    
    return nil;
}