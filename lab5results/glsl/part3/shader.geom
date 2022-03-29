#version 150 core
//
// Geometry shader for Lab 5.
//
// @author  RIT CS Department
// @author  Chengyi Ma
//

// INCOMING DATA

// Layout specifications


layout(points) in;
layout(triangle_strip, max_vertices=128) out;

// Data from the vertex shader

in vec4 color[];
// COMMENTED OUT because the original framework doesn't use these
 in float factor[];
 in float radius[];

// OUTGOING DATA

// Color for this primitive set
out vec4 fColor;

// useful for doing position calculations
const float PI = 3.1415926;

vec4 SphericalCoordinateToCartesian(float azimuth, float elevation, float r){
	float x = r * sin(elevation) * cos(azimuth);
	float y = r * cos(elevation);
	float z = r * sin(elevation) * sin(azimuth);
	return vec4(x, y, z, 1);
}

void GenerateAzimuthCircle(float factor, float azimuth_step, float elevation, float r ){
	for (int i=0; i<(factor-1); i++){
		vec4 v_coord = SphericalCoordinateToCartesian(i*azimuth_step, elevation, r);
		gl_Position = gl_in[0].gl_Position + v_coord;
		EmitVertex();
		gl_Position = gl_in[0].gl_Position;
		EmitVertex();

		EndPrimitive();
	}
}

void GenerateTriangleLoops(float factor, float azimuth_step, float elevation, float elevation_step, float r){
	for (int i=0;i<(factor-1);i++){
		vec4 v1 = SphericalCoordinateToCartesian(i * azimuth_step, elevation, r);
		vec4 v2 = SphericalCoordinateToCartesian(i * azimuth_step, elevation+elevation_step, r);
		vec4 v3 = SphericalCoordinateToCartesian((i+1) * azimuth_step, elevation+elevation_step, r);
		vec4 v4 = SphericalCoordinateToCartesian((i+1) * azimuth_step, elevation, r);

		// Emit triangle 1
		gl_Position = gl_in[0].gl_Position + v1;
		EmitVertex();
		gl_Position = gl_in[0].gl_Position + v2;
		EmitVertex();
		gl_Position = gl_in[0].gl_Position + v3;
		EmitVertex();
		EndPrimitive();

		// Emit Triangle 2
		gl_Position = gl_in[0].gl_Position + v1;
		EmitVertex();
		gl_Position = gl_in[0].gl_Position + v3;
		EmitVertex();
		gl_Position = gl_in[0].gl_Position + v4;
		EmitVertex();
		EndPrimitive();
	}
}

void main()
{
    fColor = color[0];

    // just emit the single point
    //gl_Position = gl_in[0].gl_Position + vec4(radius[0] , 0.0, 0.0, 1.0);
    //EmitVertex();

	float azimuth_step = 2* PI / factor[0];
	float elevation_step = PI / factor[0];

	// First creat top and bottom vertices (only one each)
	// gl_Position = gl_in[0].gl_Position + vec4(0, radius[0], 0, 1);
	// EmitVertex();
	// gl_Position = gl_in[0].gl_Position;
	// EmitVertex();
	// EndPrimitive();

	// gl_Position = gl_in[0].gl_Position + vec4(0, -radius[0], 0, 1);
	// EmitVertex();
	// gl_Position = gl_in[0].gl_Position;
	// EmitVertex();
	// EndPrimitive();

	for(int i=0; i<(factor[0]); i++){
		GenerateTriangleLoops(factor[0], azimuth_step, i*elevation_step, elevation_step, radius[0]);
	}






    EndPrimitive();
}
