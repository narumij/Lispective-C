//
//  Procedure.h
//  Lispective_c
//
//  Created by narumij on 11/01/01.
//  Copyright 2011 narumij. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Env;

typedef id (^ProcedureBlock)(NSArray *);
ProcedureBlock Lambda(id exp, Env *env, NSArray* vars );
id Eval( id tokens, Env *env );


