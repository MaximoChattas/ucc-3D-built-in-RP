#ifndef PERLIN_NOISE
#define PERLIN_NOISE

float2 rand2dTo2d(float2 value)
{
    float2 smallValue = sin(value);
    float randomX = frac(sin(dot(smallValue, float2(12.9898, 78.233))) * 143758.5453);
    float randomY = frac(sin(dot(smallValue, float2(39.346, 11.135))) * 143758.5453);
    return float2(randomX, randomY) * 2.0 - 1.0; 
}

float easeInOut(float interpolator)
{
    float easeInValue = interpolator * interpolator * interpolator;
    float easeOutValue = 1 - pow(1 - interpolator, 3);
    return lerp(easeInValue, easeOutValue, interpolator);
}

float perlinNoise2D(float2 value)
{
    // Obtener la parte fraccionaria para interpolación
    float2 fraction = frac(value);
    float interpolatorX = easeInOut(fraction.x);
    float interpolatorY = easeInOut(fraction.y);

    // Direcciones aleatorias en las celdas vecinas
    float2 lowerLeftDir = rand2dTo2d(floor(value)) * 2 - 1;
    float2 lowerRightDir = rand2dTo2d(float2(ceil(value.x), floor(value.y))) * 2 - 1;
    float2 upperLeftDir = rand2dTo2d(float2(floor(value.x), ceil(value.y))) * 2 - 1;
    float2 upperRightDir = rand2dTo2d(ceil(value)) * 2 - 1;

    // Cálculo del valor del ruido
    float lowerLeft = dot(lowerLeftDir, fraction);
    float lowerRight = dot(lowerRightDir, fraction - float2(1, 0));
    float upperLeft = dot(upperLeftDir, fraction - float2(0, 1));
    float upperRight = dot(upperRightDir, fraction - float2(1, 1));

    // Interpolación de los valores en las celdas
    float lowerCells = lerp(lowerLeft, lowerRight, interpolatorX);
    float upperCells = lerp(upperLeft, upperRight, interpolatorX);
    return lerp(lowerCells, upperCells, interpolatorY);
}

#endif