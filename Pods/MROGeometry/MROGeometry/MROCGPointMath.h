/*
 * MROCGPointMath.h
 *
 * Created by Marcus Rohrmoser on 21.09.10.
 *
 * Copyright (c) 2010-2014, Marcus Rohrmoser mobile Software
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted
 * provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice, this list of conditions
 * and the following disclaimer.
 *
 * 2. The software must not be used for military or intelligence or related purposes nor
 * anything that's in conflict with human rights as declared in http://www.un.org/en/documents/udhr/ .
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 * IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
 * THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include <CoreGraphics/CGGeometry.h>

/** Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vsadd */
CGPoint CGPointAdd(const CGPoint a, const CGPoint b);

CGPoint CGPointSub(const CGPoint a, const CGPoint b);

/** Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vsmul */
CGPoint CGPointMul(const CGPoint a, const CGFloat f);

/** Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_dotpr */
CGFloat CGPointDotPr(const CGPoint a, const CGPoint b);

CGFloat CGPointAbsSqr(const CGPoint a);

/** Similar to http://developer.apple.com/library/ios/documentation/Accelerate/Reference/vDSPRef/Reference/reference.html#//apple_ref/c/func/vDSP_vabs */
CGFloat CGPointAbs(const CGPoint a);

bool CGPointDistanceSmallerThan(const CGPoint a, const CGPoint b, const CGFloat radius);
