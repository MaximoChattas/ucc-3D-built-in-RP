#ifndef VORONOI_NOISE
#define VORONOI_NOISE

float3 rand1dTo3d(float value)
{
    return float3(
        frac(sin(value + 3.9812) * 143758.5453),
        frac(sin(value + 7.1536) * 143758.5453),
        frac(sin(value + 5.7241) * 143758.5453)
    );
}

float rand2dTo1d(float2 value)
{
    float2 smallValue = sin(value);
    float random = frac(sin(dot(smallValue, float2(12.9898, 78.233))) * 143758.5453);
    return random;
}


float2 rand2dTo2d(float2 value)
{
    float2 smallValue = sin(value);
    float randomX = frac(sin(dot(smallValue, float2(12.9898, 78.233))) * 143758.5453);
    float randomY = frac(sin(dot(smallValue, float2(39.346, 11.135))) * 143758.5453);
    return float2(randomX, randomY);
}

float voronoiNoise2D(float2 value)
{
    float2 baseCell = floor(value);

    float minDistToCell = 10.0;
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            float2 cell = baseCell + float2(x, y);
            float2 cellPosition = cell + rand2dTo2d(cell);
            float2 toCell = cellPosition - value;
            float distToCell = length(toCell);
            minDistToCell = min(minDistToCell, distToCell);
        }
    }
    return minDistToCell;
}

float3 voronoiNoiseWithEdge2D(float2 value)
{
    float2 baseCell = floor(value);

    // Primer paso para encontrar la celda más cercana
    float minDistToCell = 10.0;
    float2 toClosestCell;
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            float2 cell = baseCell + float2(x, y);
            float2 cellPosition = cell + rand2dTo2d(cell);
            float2 toCell = cellPosition - value;
            float distToCell = length(toCell);
            if (distToCell < minDistToCell)
            {
                minDistToCell = distToCell;
                toClosestCell = toCell;
            }
        }
    }

    // Segundo paso para encontrar la distancia al borde más cercano
    float minEdgeDistance = 10.0;
    [unroll]
    for (int x = -1; x <= 1; x++)
    {
        [unroll]
        for (int y = -1; y <= 1; y++)
        {
            float2 cell = baseCell + float2(x, y);
            float2 cellPosition = cell + rand2dTo2d(cell);
            float2 toCell = cellPosition - value;

            // Si no estamos en la celda más cercana, calcula el borde
            float2 toCenter = (toClosestCell + toCell) * 0.5;
            float2 cellDifference = normalize(toCell - toClosestCell);
            float edgeDistance = dot(toCenter, cellDifference);
            minEdgeDistance = min(minEdgeDistance, edgeDistance);
        }
    }

    float random = rand2dTo1d(baseCell);
    return float3(minDistToCell, random, minEdgeDistance);
}


#endif