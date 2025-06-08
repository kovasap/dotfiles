#version 330

// Changes brightness of windows
float brightness_level = 0.70; // Value between 0.0 and 1.0. Change to your liking

// Changes color of windows
float temperature_kelvin = 5000.0;

in vec2 texcoord;             // texture coordinate of the fragment

uniform sampler2D tex;        // texture of the window

float saturate(float v) { return clamp(v, 0.0,       1.0);       }
vec2  saturate(vec2  v) { return clamp(v, vec2(0.0), vec2(1.0)); }
vec3  saturate(vec3  v) { return clamp(v, vec3(0.0), vec3(1.0)); }
vec4  saturate(vec4  v) { return clamp(v, vec4(0.0), vec4(1.0)); }

// From https://www.shadertoy.com/view/lsSXW1
vec3 ColorTemperatureToRGB(float tempKelvins) {
    vec3 retColor;
    
    tempKelvins = clamp(tempKelvins, 1000.0, 40000.0) / 100.0;
    
    if (tempKelvins <= 66.0) {
        retColor.r = 1.0;
        retColor.g = saturate(0.39008157876901960784 * log(tempKelvins) - 0.63184144378862745098);
    } else {
        float t = tempKelvins - 60.0;
        retColor.r = saturate(1.29293618606274509804 * pow(t, -0.1332047592));
        retColor.g = saturate(1.12989086089529411765 * pow(t, -0.0755148492));
    }
    
    if (tempKelvins >= 66.0)
        retColor.b = 1.0;
    else if(tempKelvins <= 19.0)
        retColor.b = 0.0;
    else
        retColor.b = saturate(0.54320678911019607843 * log(tempKelvins - 10.0) - 1.19625408914);

    return retColor;
}

// Default window post-processing:
// 1) invert color
// 2) opacity / transparency
// 3) max-brightness clamping
// 4) rounded corners
vec4 default_post_processing(vec4 c);

vec4 window_shader() {
    vec4 c = texelFetch(tex, ivec2(texcoord), 0);

    c = default_post_processing(c);

    // Multiply all color values with brightness_level
    c.x *= brightness_level;
    c.y *= brightness_level;
    c.z *= brightness_level;

    // Set color temperature
    vec3 temp = ColorTemperatureToRGB(temperature_kelvin);
    c = vec4(vec3(c) * temp, c.a);

    return c;
}
