global uniform vec3 skycrew_sun_direction;

float daylight(float sun_height) {
	return smoothstep(-0.12, 0.22, sun_height);
}

float twilight(float sun_height) {
	return smoothstep(-0.23, -0.065, sun_height) * (1.0 - smoothstep(0.04, 0.36, sun_height));
}

vec3 sky_gradient(vec3 direction, vec3 sun_direction) {
	float day = daylight(sun_direction.y);
	float dusk = twilight(sun_direction.y);
	float up = smoothstep(-0.03, 0.83, direction.y);
	float down = smoothstep(0.02, 0.84, -direction.y);
	float toward_sun = smoothstep(-0.35, 0.85, dot(direction, sun_direction));

	// Colors are linear. The lower hemisphere stays softly blue below the horizon.
	vec3 zenith = mix(vec3(0.007, 0.012, 0.041), vec3(0.095, 0.36, 0.68), day);
	zenith = mix(zenith, vec3(0.16, 0.15, 0.34), dusk * 0.52);
	vec3 horizon = mix(vec3(0.032, 0.050, 0.105), vec3(0.62, 0.80, 0.86), day);
	vec3 dusk_horizon = mix(vec3(0.32, 0.25, 0.40), vec3(0.98, 0.53, 0.36), toward_sun);
	horizon = mix(horizon, dusk_horizon, dusk * mix(0.45, 0.98, toward_sun));
	vec3 nadir = mix(vec3(0.016, 0.027, 0.066), vec3(0.33, 0.57, 0.72), day);
	return mix(mix(horizon, zenith, up), nadir, down);
}
