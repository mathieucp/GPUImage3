#include <metal_stdlib>
#include "TexelSamplingTypes.h"

using namespace metal;

fragment half4 colorLocalBinaryPatternFragment(NearbyTexelVertexIO fragmentInput [[stage_in]],
                              texture2d<half> inputTexture [[texture(0)]])
{
    constexpr sampler quadSampler(coord::pixel);
    half3 bottomColor = inputTexture.sample(quadSampler, fragmentInput.bottomTextureCoordinate).rgb;
    half3 bottomLeftColor = inputTexture.sample(quadSampler, fragmentInput.bottomLeftTextureCoordinate).rgb;
    half3 bottomRightColor = inputTexture.sample(quadSampler, fragmentInput.bottomRightTextureCoordinate).rgb;
    half4 centerColor = inputTexture.sample(quadSampler, fragmentInput.textureCoordinate);
    half3 leftColor = inputTexture.sample(quadSampler, fragmentInput.leftTextureCoordinate).rgb;
    half3 rightColor = inputTexture.sample(quadSampler, fragmentInput.rightTextureCoordinate).rgb;
    half3 topColor = inputTexture.sample(quadSampler, fragmentInput.topTextureCoordinate).rgb;
    half3 topRightColor = inputTexture.sample(quadSampler, fragmentInput.topRightTextureCoordinate).rgb;
    half3 topLeftColor = inputTexture.sample(quadSampler, fragmentInput.topLeftTextureCoordinate).rgb;
    
    half redByteTally = 1.0h / 255.0h * step(centerColor.r, topRightColor.r);
    redByteTally += 2.0h / 255.0h * step(centerColor.r, topColor.r);
    redByteTally += 4.0h / 255.0h * step(centerColor.r, topLeftColor.r);
    redByteTally += 8.0h / 255.0h * step(centerColor.r, leftColor.r);
    redByteTally += 16.0h / 255.0h * step(centerColor.r, bottomLeftColor.r);
    redByteTally += 32.0h / 255.0h * step(centerColor.r, bottomColor.r);
    redByteTally += 64.0h / 255.0h * step(centerColor.r, bottomRightColor.r);
    redByteTally += 128.0h / 255.0h * step(centerColor.r, rightColor.r);
    
    half blueByteTally = 1.0h / 255.0h * step(centerColor.b, topRightColor.b);
    blueByteTally += 2.0h / 255.0h * step(centerColor.b, topColor.b);
    blueByteTally += 4.0h / 255.0h * step(centerColor.b, topLeftColor.b);
    blueByteTally += 8.0h / 255.0h * step(centerColor.b, leftColor.b);
    blueByteTally += 16.0h / 255.0h * step(centerColor.b, bottomLeftColor.b);
    blueByteTally += 32.0h / 255.0h * step(centerColor.b, bottomColor.b);
    blueByteTally += 64.0h / 255.0h * step(centerColor.b, bottomRightColor.b);
    blueByteTally += 128.0h / 255.0h * step(centerColor.b, rightColor.b);
    
    half greenByteTally = 1.0h / 255.0h * step(centerColor.g, topRightColor.g);
    greenByteTally += 2.0h / 255.0h * step(centerColor.g, topColor.g);
    greenByteTally += 4.0h / 255.0h * step(centerColor.g, topLeftColor.g);
    greenByteTally += 8.0h / 255.0h * step(centerColor.g, leftColor.g);
    greenByteTally += 16.0h / 255.0h * step(centerColor.g, bottomLeftColor.g);
    greenByteTally += 32.0h / 255.0h * step(centerColor.g, bottomColor.g);
    greenByteTally += 64.0h / 255.0h * step(centerColor.g, bottomRightColor.g);
    greenByteTally += 128.0h / 255.0h * step(centerColor.g, rightColor.g);
    
    // TODO: Replace the above with a dot product and two vec4s
    // TODO: Apply step to a matrix, rather than individually
    
    return half4(redByteTally, blueByteTally, greenByteTally, 1.0h);
}

/*
 varying vec2 textureCoordinate;
 varying vec2 leftTextureCoordinate;
 varying vec2 rightTextureCoordinate;
 
 varying vec2 topTextureCoordinate;
 varying vec2 topLeftTextureCoordinate;
 varying vec2 topRightTextureCoordinate;
 
 varying vec2 bottomTextureCoordinate;
 varying vec2 bottomLeftTextureCoordinate;
 varying vec2 bottomRightTextureCoordinate;
 
 uniform sampler2D inputImageTexture;
 
 void main()
 {
 vec3 centerColor = texture2D(inputImageTexture, textureCoordinate).rgb;
 vec3 bottomLeftColor = texture2D(inputImageTexture, bottomLeftTextureCoordinate).rgb;
 vec3 topRightColor = texture2D(inputImageTexture, topRightTextureCoordinate).rgb;
 vec3 topLeftColor = texture2D(inputImageTexture, topLeftTextureCoordinate).rgb;
 vec3 bottomRightColor = texture2D(inputImageTexture, bottomRightTextureCoordinate).rgb;
 vec3 leftColor = texture2D(inputImageTexture, leftTextureCoordinate).rgb;
 vec3 rightColor = texture2D(inputImageTexture, rightTextureCoordinate).rgb;
 vec3 bottomColor = texture2D(inputImageTexture, bottomTextureCoordinate).rgb;
 vec3 topColor = texture2D(inputImageTexture, topTextureCoordinate).rgb;
 
 float redByteTally = 1.0 / 255.0 * step(centerColor.r, topRightColor.r);
 redByteTally += 2.0 / 255.0 * step(centerColor.r, topColor.r);
 redByteTally += 4.0 / 255.0 * step(centerColor.r, topLeftColor.r);
 redByteTally += 8.0 / 255.0 * step(centerColor.r, leftColor.r);
 redByteTally += 16.0 / 255.0 * step(centerColor.r, bottomLeftColor.r);
 redByteTally += 32.0 / 255.0 * step(centerColor.r, bottomColor.r);
 redByteTally += 64.0 / 255.0 * step(centerColor.r, bottomRightColor.r);
 redByteTally += 128.0 / 255.0 * step(centerColor.r, rightColor.r);
 
 float blueByteTally = 1.0 / 255.0 * step(centerColor.b, topRightColor.b);
 blueByteTally += 2.0 / 255.0 * step(centerColor.b, topColor.b);
 blueByteTally += 4.0 / 255.0 * step(centerColor.b, topLeftColor.b);
 blueByteTally += 8.0 / 255.0 * step(centerColor.b, leftColor.b);
 blueByteTally += 16.0 / 255.0 * step(centerColor.b, bottomLeftColor.b);
 blueByteTally += 32.0 / 255.0 * step(centerColor.b, bottomColor.b);
 blueByteTally += 64.0 / 255.0 * step(centerColor.b, bottomRightColor.b);
 blueByteTally += 128.0 / 255.0 * step(centerColor.b, rightColor.b);
 
 float greenByteTally = 1.0 / 255.0 * step(centerColor.g, topRightColor.g);
 greenByteTally += 2.0 / 255.0 * step(centerColor.g, topColor.g);
 greenByteTally += 4.0 / 255.0 * step(centerColor.g, topLeftColor.g);
 greenByteTally += 8.0 / 255.0 * step(centerColor.g, leftColor.g);
 greenByteTally += 16.0 / 255.0 * step(centerColor.g, bottomLeftColor.g);
 greenByteTally += 32.0 / 255.0 * step(centerColor.g, bottomColor.g);
 greenByteTally += 64.0 / 255.0 * step(centerColor.g, bottomRightColor.g);
 greenByteTally += 128.0 / 255.0 * step(centerColor.g, rightColor.g);
 
 // TODO: Replace the above with a dot product and two vec4s
 // TODO: Apply step to a matrix, rather than individually
 
 gl_FragColor = vec4(redByteTally, blueByteTally, greenByteTally, 1.0);
 }

 */
