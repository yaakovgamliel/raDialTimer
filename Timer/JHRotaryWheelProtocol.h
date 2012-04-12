//
//  JHRotaryWheelProtocol.h
//  Timer
//
//  Created by Jonathan Hirz on 3/19/12.
//  Copyright (c) 2012 SuaveApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JHRotaryWheelProtocol <NSObject>

- (void) wheelDidChangeValue:(NSString *)newValue;

@end
