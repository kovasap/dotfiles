uniform float opacity;
uniform bool invert_color;
uniform sampler2D tex;

/**
 * Adjusts the saturation of a color.
 *
 * From: https://github.com/AnalyticalGraphicsInc/cesium/blob/master/Source/Shaders/Builtin/Functions/saturation.glsl
 *
 * @param {vec3} rgb The color.
 * @param {float} adjustment The amount to adjust the saturation of the color.
 *
 * @returns {float} The color with the saturation adjusted.
 *
 * @example
 * vec3 greyScale = chg_saturation(color, 0.0);
 * vec3 doubleSaturation = chg_saturation(color, 2.0);
 */
vec3 chg_saturation(vec3 rgb, float adjustment) {
    // Algorithm from Chapter 16 of OpenGL Shading Language
    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
    vec3 intensity = vec3(dot(rgb, W));
    return mix(intensity, rgb, adjustment);
}

/**
 * Adjusts the contrast of a color.
 *
 * @param adjustment the adjustment value, 0.0 - 1.0 reduces the contrast, &gt;
 *                   1.0 increases it
 */
vec3 chg_contrast(vec3 rgb, float adjustment) {
    return (rgb - 0.5) * adjustment + 0.5;
}

/**
 * Adjusts the brightness of a color.
 *
 * @param adjustment the adjustment value, 0.0 - 1.0 reduces the brightness,
 *                   &gt; 1.0 increases it
 */
vec3 chg_brightness(vec3 rgb, float adjustment) {
    return rgb * adjustment;
}

// These two functions assume input and output are in the range [0..1]
// See http://lolengine.net/blog/2013/07/27/rgb-to-hsv-in-glsl
vec3 rgb2hsv(vec3 c) {
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

/**
 * Selectively dims brighter colors more than darker ones.
 * Use https://alloyui.com/examples/color-picker/hsv.html to play with.
 */
vec3 chg_bright_brightness(vec3 rgb) {
    vec3 hsv = rgb2hsv(rgb);
    float curviness = 0.8;
    float os = 0.80;  // offset
    float curved_v = os + (hsv.z - os) * (1.0 - curviness * (hsv.z - os));
    float line_v = 0.3 * (hsv.z - os) + os;
    // use this to detect what pixel will be "nonlinearized"
    float flat_v = 0.0;
    float new_v = (hsv.z > os && hsv.y < 0.2 ? line_v : hsv.z);
    vec3 dim_hsv = vec3(hsv.x, hsv.y, new_v);
    return hsv2rgb(dim_hsv);
}

float saturate(float v) { return clamp(v, 0.0,       1.0);       }
vec2  saturate(vec2  v) { return clamp(v, vec2(0.0), vec2(1.0)); }
vec3  saturate(vec3  v) { return clamp(v, vec3(0.0), vec3(1.0)); }
vec4  saturate(vec4  v) { return clamp(v, vec4(0.0), vec4(1.0)); }

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

void main() {
    vec4 c = texture2D(tex, gl_TexCoord[0].st);
    // c = vec4(chg_saturation(vec3(c), 0.5), c.a);
    // c = vec4(chg_contrast(vec3(c), 0.5), c.a);
    c = vec4(chg_brightness(vec3(c), 0.45), c.a);
    // c = vec4(chg_bright_brightness(vec3(c)), c.a);
    vec3 temp = ColorTemperatureToRGB(5000.0);
    c = vec4(vec3(c) * temp, c.a);
    if (invert_color)
        c = vec4(vec3(c.a, c.a, c.a) - vec3(c), c.a);
    c *= opacity;
    gl_FragColor = c;
}
