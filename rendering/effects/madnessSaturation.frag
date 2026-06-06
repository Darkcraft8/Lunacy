#version 140
      
uniform sampler2D mainFB;
uniform vec2 screenSize;
uniform float satMult;
uniform float madnessStrength;

out vec4 outColor;

vec4 toHSV(vec4 c) {
  float Cma = max(max(c.r,c.g),c.b);
  float Cmi = min(min(c.r,c.g),c.b);
  float delta = Cma-Cmi;
  float Hu = 0;
  if (delta == 0) {
  } else if (Cma == c.r) {
      Hu = mod((c.g-c.b)/delta,6);
  } else if (Cma == c.g) {
      Hu = (c.b-c.r)/delta+2;
  } else if (Cma == c.b) {
      Hu = (c.r-c.g)/delta+4;
  }
  float Sa = 0;
  if (Cma != 0) {
      Sa = delta/Cma;
  }
  return vec4(Hu,Sa,Cma,c.a);
}
vec4 fromHSV(vec4 hsv) {
  float C = hsv.z*hsv.y;
  float X = C*(1-abs(mod(hsv.x,2)-1));
  float m = hsv.z-C;
  vec3 RGBd;
  switch(int(hsv.x)%6) {
    case 0:
      RGBd = vec3(C,X,0);
      break;
    case 1:
      RGBd = vec3(X,C,0);
      break;
    case 2:
      RGBd = vec3(0,C,X);
      break;
    case 3:
      RGBd = vec3(0,X,C);
      break;
    case 4:
      RGBd = vec3(X,0,C);
      break;
    case 5:
      RGBd = vec3(C,0,X);
      break;
  }
  return vec4(RGBd.r+m,RGBd.g+m,RGBd.b+m,hsv.a);
}

void main() {
  vec2 texCoords = gl_FragCoord.xy/screenSize;
  
  vec4 hsv = toHSV(texture(mainFB, texCoords));
  hsv.x += 0/60;
  hsv.y = (hsv.y)*(1 - (satMult * madnessStrength));
  hsv.z = (hsv.z);
  vec4 c = fromHSV(hsv);
  outColor = vec4(
    (c.r),
    (c.g),
    (c.b),
  c.a);
}
