//--------------------------------------------------------------------------------------
// Constant Buffer Variables
//--------------------------------------------------------------------------------------

cbuffer cbShaderParameters : register( b0 )
{
    int Iterations;
	float2 Pan;
	float Zoom;
	float Aspect;
	float3 Color;
	float dummy1;
	int dummy2;
};

//--------------------------------------------------------------------------------------
// Input structures
//--------------------------------------------------------------------------------------
struct VS_INPUT
{
    float4 C : POSITION;
    float2 Tex : TEXCOORD0;
};

struct PS_INPUT
{
    float4 C : SV_POSITION;
    float2 Tex : TEXCOORD0;
};

//--------------------------------------------------------------------------------------
// Vertex Shader
//--------------------------------------------------------------------------------------
PS_INPUT VS( VS_INPUT input )
{
    PS_INPUT output = (PS_INPUT)0;
    output.C = input.C;
    output.Tex = input.Tex;
    
    return output;
}


//--------------------------------------------------------------------------------------
// Pixel Shader
//--------------------------------------------------------------------------------------
float4 PS_Mandelbrot( PS_INPUT input) : SV_Target
{
	float2 C = (input.Tex - 0.5) * Zoom * float2(1, Aspect) - Pan;
	float2 v = C;

	int prevIteration = Iterations;
	int i = 0;


	do
	{
		v = float2((v.x * v.x) - (v.y * v.y), v.x * v.y * 2) + C;

		i++;

		if ((prevIteration == Iterations) && ((v.x * v.x) + (v.y * v.y)) > 4.0)
		{
			prevIteration = i + 1;
		}
	}
	while (i < prevIteration);


	float NIC = (float(i) - (log(log(sqrt((v.x * v.x) + (v.y * v.y)))) / log(2.0))) / float(Iterations);
	return float4(sin(NIC * Color.x), sin(NIC * Color.y), sin(NIC * Color.z), 1);
}