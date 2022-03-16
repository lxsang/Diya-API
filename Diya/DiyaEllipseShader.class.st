Class {
	#name : #DiyaEllipseShader,
	#superclass : #Diya2DShader,
	#category : #'Diya-Shaders'
}

{ #category : #accessing }
DiyaEllipseShader class >> fragmentShader [ 
	^'
#ifdef GL_ES
  precision highp float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;
// 2D uniforms
uniform int u_texture_type;
uniform vec4 u_color;
uniform vec4 u_border_color;
uniform sampler2D u_texture;
uniform float u_border;
uniform float u_rx;
uniform float u_ry;
varying float rotation;
varying vec2 middle;
varying vec2 texcoord;
struct Ellipse
{
    vec2 c;
    float minor;
    float major;
    float f;
};
float get_foci(float major, float minor)
{
    return sqrt((major*major)-(minor*minor));
}
Ellipse create_ellipse(vec2 c, float mi, float ma)
{
    Ellipse e;
    e.c = c;
    e.major = max(mi,ma);
    e.minor = min(mi,ma);
    e.f = get_foci(e.major, e.minor);
    return e;
}
bool is_inside_ellipse(vec2 p, Ellipse e)
{
    float first = ((p.x-e.c.x)*(p.x-e.c.x)) / (e.major*e.major);
    float second = ((p.y-e.c.y)*(p.y-e.c.y)) / (e.minor*e.minor);
    return first+second <= 1.0;
}

bool is_inside_border(vec2 p, Ellipse e, float w)
{
    float first = ((p.x-e.c.x)*(p.x-e.c.x)) / ((e.major-w)*(e.major-w));
    float second = ((p.y-e.c.y)*(p.y-e.c.y)) / ((e.minor-w)*(e.minor-w));
    float sum = first + second;
    return sum<= 1.0;
}

void draw_ellipse(inout vec4 c, vec2 p, Ellipse e, float border)
{
    c = vec4(0);
    if (is_inside_border(p,e, border))
    {
		  vec4 texcolor = vec4(1);
		  // vec2 uv = (p - (e.c - vec2(e.major , e.minor))) / vec2(e.major*2.0, e.minor*2.0); 
		  // alpha
	     if(u_texture_type == 0x1906) { 
		    texcolor = vec4(1, 1, 1, texture2D(u_texture, texcoord).a);
	     }
	     // rgba
	     else if (u_texture_type == 0x1908){ 
		    texcolor =  texture2D(u_texture, texcoord);
	     }
        c = texcolor * u_color;
    }
    else
    {
        if (is_inside_ellipse(p, e))
        {
            c = u_border_color;
        }
    }
    
}

vec2 rotate_point(vec2 center, vec2 p,float angle)
{
  float s = sin(angle);
  float c = cos(angle);

  // translate point back to origin:
  p.x -= center.x;
  p.y -= center.y;

  // rotate point
  float xnew = p.x * c - p.y * s;
  float ynew = p.x * s + p.y * c;

  // translate point back:
  p.x = xnew + center.x;
  p.y = ynew + center.y;
  return p;
}

void main() {
    vec4 color = vec4(0);
    //defining ellipse
    Ellipse e = create_ellipse(middle, u_ry, u_rx);
    draw_ellipse(color, rotate_point(middle, gl_FragCoord.xy, rotation), e, u_border);
    // Output to screen
    gl_FragColor = color;
}
'
]

{ #category : #accessing }
DiyaEllipseShader class >> vertexShader [
	^'
#ifdef GL_ES
precision mediump float;
#endif
uniform mat4 u_projection;
uniform mat3 u_transform;
varying float rotation;
varying vec2 middle;
varying vec2 texcoord;
void main()
{
	vec3 coord_global = u_transform * vec3(gl_Vertex.xy, 1.0);
	gl_Position = u_projection * vec4(coord_global.xy, 0, 1.0);
	rotation = atan(u_transform[1][0], u_transform[0][0]);
	middle = (u_transform * vec3(0.0,0.0,1.0)).xy;
	texcoord = gl_Vertex.zw;
}'
]

{ #category : #initialization }
DiyaEllipseShader >> setUpUniforms [
	super setUpUniforms.
	self addUniform: #u_rx of: Uniform1F.
	self addUniform: #u_ry of: Uniform1F.
]
