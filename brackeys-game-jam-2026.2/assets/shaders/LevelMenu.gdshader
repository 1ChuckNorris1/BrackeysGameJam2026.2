shader_type canvas_item;

// Textur für den Blur (Godot 4)
uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;

// Regler für Unschärfe und Farbe
uniform float lod: hint_range(0.0, 5.0) = 2.5;
uniform vec4 modulate: source_color = vec4(0.0, 0.0, 0.0, 0.3);

// --- REGELN FÜR DIE RUNDUNG ---
// Wie stark die Ecken abgerundet sind (0.0 bis 0.5)
uniform float corner_radius : hint_range(0.0, 0.5) = 0.1;

// Das Seitenverhältnis deines ColorRects (Breite geteilt durch Höhe!)
// Beispiel: Wenn das Rect 400x200 Pixel groß ist -> 400 / 200 = 2.0
uniform float aspect_ratio = 1.0;

// Hilfsfunktion für perfekt proportionierte abgerundete Ecken (SDF)
float rounded_box(vec2 center_pos, vec2 box_size, float radius) {
    return length(max(abs(center_pos) - box_size + radius, 0.0)) - radius;
}

void fragment() {
    // Korrigiert die X-Achse anhand des Seitenverhältnisses, damit die Ecken rund bleiben
    vec2 center_pos = (UV - 0.5) * vec2(aspect_ratio, 1.0);
    vec2 half_size = vec2(aspect_ratio, 1.0) * 0.5;

    // Berechnet den Abstand zur Kante
    float distance = rounded_box(center_pos, half_size, corner_radius);
    
    // Erzeugt eine scharfe Kante mit weichem Anti-Aliasing (verhindert Pixellook)
    float alpha_mask = 1.0 - smoothstep(-0.005, 0.005, distance);

    // Hintergrund auslesen und verwischen
    vec4 color = textureLod(screen_texture, SCREEN_UV, lod);
    
    // Farbe mischen
    vec4 final_color = vec4(mix(color.rgb, modulate.rgb, modulate.a), 1.0);
    
    // Maske anwenden
    COLOR = vec4(final_color.rgb, final_color.a * alpha_mask);
}
