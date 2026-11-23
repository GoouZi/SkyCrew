vec3 mod289_3(vec3 x) {
	return x - floor(x / 289.0) * 289.0;
}


vec4 mod289_4(vec4 x) {
	return x - floor(x / 289.0) * 289.0;
}


vec4 permute_4(vec4 x) {
	return mod289_4((x * 34.0 + 1.0) * x);
}


vec4 taylor_inv_sqrt(vec4 r) {
	return 1.79284291400159 - r * 0.85373472095314;
}


float simplex_noise_3d(vec3 v) {
	const vec2 c = vec2(1.0 / 6.0, 1.0 / 3.0);
	vec3 i = floor(v + dot(v, c.yyy));
	vec3 x0 = v - i + dot(i, c.xxx);
	vec3 g = step(x0.yzx, x0.xyz);
	vec3 l = 1.0 - g;
	vec3 i1 = min(g.xyz, l.zxy);
	vec3 i2 = max(g.xyz, l.zxy);
	vec3 x1 = x0 - i1 + c.xxx;
	vec3 x2 = x0 - i2 + c.yyy;
	vec3 x3 = x0 - 0.5;
	i = mod289_3(i);
	vec4 p = permute_4(
		permute_4(
			permute_4(i.z + vec4(0.0, i1.z, i2.z, 1.0))
			+ i.y + vec4(0.0, i1.y, i2.y, 1.0)
		) + i.x + vec4(0.0, i1.x, i2.x, 1.0)
	);
	vec4 j = p - 49.0 * floor(p / 49.0);
	vec4 x_ = floor(j / 7.0);
	vec4 y_ = floor(j - 7.0 * x_);
	vec4 x = (x_ * 2.0 + 0.5) / 7.0 - 1.0;
	vec4 y = (y_ * 2.0 + 0.5) / 7.0 - 1.0;
	vec4 h = 1.0 - abs(x) - abs(y);
	vec4 b0 = vec4(x.xy, y.xy);
	vec4 b1 = vec4(x.zw, y.zw);
	vec4 s0 = floor(b0) * 2.0 + 1.0;
	vec4 s1 = floor(b1) * 2.0 + 1.0;
	vec4 sh = -step(h, vec4(0.0));
	vec4 a0 = b0.xzyw + s0.xzyw * sh.xxyy;
	vec4 a1 = b1.xzyw + s1.xzyw * sh.zzww;
	vec3 g0 = vec3(a0.xy, h.x);
	vec3 g1 = vec3(a0.zw, h.y);
	vec3 g2 = vec3(a1.xy, h.z);
	vec3 g3 = vec3(a1.zw, h.w);
	vec4 norm = taylor_inv_sqrt(vec4(dot(g0, g0), dot(g1, g1), dot(g2, g2), dot(g3, g3)));
	g0 *= norm.x;
	g1 *= norm.y;
	g2 *= norm.z;
	g3 *= norm.w;
	vec4 m = max(0.6 - vec4(dot(x0, x0), dot(x1, x1), dot(x2, x2), dot(x3, x3)), vec4(0.0));
	m *= m;
	m *= m;
	vec4 px = vec4(dot(x0, g0), dot(x1, g1), dot(x2, g2), dot(x3, g3));
	return 42.0 * dot(m, px);
}
