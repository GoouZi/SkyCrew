shader_type sky;

#include "res://assets/shaders/environment/daylight_palette.gdshaderinc"

uniform float sun_radius : hint_range(0.5, 4.0, 0.05) = 1.65;
uniform float halo_strength : hint_range(0.0, 0.75, 0.01) = 0.34;

float star_field(vec3 direction) {
	vec3 coordinates = direction * 160.0 + vec3(11.2, 5.5, 3.1);
	vec3 cell = floor(coordinates);
	vec3 center = 0.2 + 0.6 * fract(sin(vec3(
		dot(cell, vec3(27.1, 113.3, 39.7)),
		dot(cell, vec3(51.9, 29.8, 80.4)),
		dot(cell, vec3(68.3, 61.2, 89.5))
	)) * 437.58);
	float brightness = fract(dot(center, vec3(131.7, 59.4, 73.6)));
	float point = 1.0 - smoothstep(0.055, 0.155, length(fract(coordinates) - center));
	return point * smoothstep(0.985, 1.0, brightness);
}

void sky() {
	if (AT_CUBEMAP_PASS) {
		COLOR = vec3(0.18, 0.25, 0.31);
	} else {
		vec3 sun_direction = skycrew_sun_direction;
		COLOR = sky_gradient(EYEDIR, sun_direction);

		float separation = length(EYEDIR - sun_direction);
		float radius = 2.0 * sin(radians(sun_radius) * 0.5);
		float sun_visibility = smoothstep(-0.16, 0.02, sun_direction.y);
		float sun_warmth = 1.0 - smoothstep(0.0, 0.40, sun_direction.y);
		vec3 halo_color = mix(vec3(1.0, 0.73, 0.38), vec3(1.0, 0.39, 0.15), sun_warmth);
		float aureole = exp(-pow(separation * 8.0, 1.45));
		float scatter = exp(-pow(separation * 2.8, 1.8));
		COLOR += halo_color * halo_strength * (0.65 * aureole + 0.35 * scatter) * sun_visibility;

		float disc_mask = 1.0 - smoothstep(radius * 0.91, radius * 1.06, separation);
		float limb = smoothstep(radius * 0.14, radius, separation);
		vec3 disc_edge = mix(vec3(1.0, 0.81, 0.47), vec3(1.0, 0.47, 0.20), sun_warmth);
		vec3 disc_core = mix(vec3(1.0, 0.975, 0.86), vec3(1.0, 0.86, 0.57), sun_warmth);
		COLOR = mix(COLOR, mix(disc_core, disc_edge, limb * 0.74), disc_mask * sun_visibility);

		float night = smoothstep(0.08, 0.32, -sun_direction.y);
		if (night > 0.0) {
			float stars = star_field(EYEDIR) * smoothstep(0.01, 0.29, EYEDIR.y);
			float moon_alignment = dot(EYEDIR, -sun_direction);
			float moon = smoothstep(0.99945, 0.99955, moon_alignment);
			COLOR += (vec3(0.70, 0.79, 1.0) * stars * 0.7
				+ vec3(0.33, 0.47, 0.70) * (moon + 0.16 * pow(max(moon_alignment, 0.0), 85.0))) * night;
		}
	}
}
