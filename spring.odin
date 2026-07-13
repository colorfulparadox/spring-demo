package main


@(private)
ESP :: 0.001


Spring :: struct {
    pos: [2]f32,
    velo: [2]f32,
    stiffness: f32, //k
    damping: f32,
    rest_len: f32,
    mass: f32,
    grav: f32,
}

spring_init :: proc(pos: [2]f32, stiffness: f32, damping: f32, rest_len: f32, mass: f32, grav: f32) -> Spring {
    return Spring {
        pos = pos,
        stiffness = stiffness,
        damping = damping,
        rest_len = rest_len,
        mass = mass,
        grav = grav
    }
}

spring_update :: proc(s: ^Spring, target: [2]f32, dt: f32) {
    mass := s.mass
    offset := s.pos - target
    length := rl.Vector2Length(offset)
    if length >= ESP {
        spring_force := -s.stiffness * (length - s.rest_len)
        vec_to_target := offset / length
        grav_force := [2]f32{0, s.grav * mass}
        force := (spring_force * vec_to_target) - (s.damping * s.velo) + grav_force
        accel := force / mass

        s.velo += accel * dt
        s.pos += s.velo * dt
    }
}

spring_debug_draw :: proc(s: Spring, target: [2]f32) {
    rl.DrawLineEx(s.pos, target, 5.0, rl.GREEN)
    draw_point(s.pos)
    draw_point(target)
}

import rl "vendor:raylib"

@(private)
draw_point :: proc(p: [2]f32) {
    rl.DrawCircle(i32(p.x), i32(p.y), 10.0, rl.RED)
}
