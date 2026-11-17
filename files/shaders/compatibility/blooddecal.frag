#version 120
uniform sampler2D diffuseMap;
uniform vec2 screenRes;
uniform float near;
uniform float far;
varying vec2 bloodUV;
varying vec3 bloodViewPos;

#include "fog.glsl"

void main()
{
    vec4 stain = texture2D(diffuseMap, bloodUV);
    stain.a *= clamp(gl_FrontMaterial.diffuse.a,0.0,1.0);
    // Source DecalModulate uses DST_COLOR + SRC_COLOR. RGB128 is
    // the neutral value in the original 8-bit textures. Respect alpha even
    // when transparent edge pixels contain saturated blood colours.
    vec3 modulation = mix(vec3(0.5), stain.rgb + vec3(0.5 - 128.0/255.0), stain.a);
    float colorScale;
    vec3 colorOffset;
    computeFog(bloodViewPos, length(bloodViewPos), bloodViewPos.z, near, far, colorScale, colorOffset);
    // The already lit/fogged NPC supplies lighting. Distant decals approach
    // a neutral multiplier instead of painting the fog a second time.
    gl_FragData[0] = vec4(mix(vec3(0.5), modulation, colorScale),0.0);
}
