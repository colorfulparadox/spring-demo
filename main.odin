package main

import rl "vendor:raylib"
import fmt "core:fmt"
import "core:strings"

Value :: struct {
    name: string,
    value: f32,
    amount: f32
}

main :: proc() {
    rl.InitWindow(1080, 920, "Spring Test")
    defer rl.CloseWindow()

    /*
    esp: f32 = 0.001
    grav: f32 = 1000.0//1250.0
    mass: f32 = 5.0
    k: f32 = 100 // Spring Constant N/M Sitffness
    rest_length: f32 = 30.0//100.0
    damping: f32 = 10.0
    velocity: Vec2 = {}

    head := Point {
        pos = Vec2 {} 
    }
    tail := Point {
        pos = Vec2 {}
    }
    */
    def_s := Spring {
        pos = {},
        stiffness = 250.0,
        damping = 15.0,
        rest_len = 30.0,
        mass = 1.0,
        grav = 0//1200.0
    }
    springs: [5]Spring = {}

    selected: i32 = 0
    values: [5]Value = {
        Value {name = "stiffness", value = 150.0, amount = 5.0},
        Value {name = "damping", value = 20.0, amount = 0.5},
        Value {name = "rest_len", value = 20.0, amount = 1.0},
        Value {name = "mass", value = 1.0, amount = 0.5},
        Value {name = "grav", value = 1600.0, amount = 100.0}
    }

    for !rl.WindowShouldClose() {

        mouse_pos := rl.GetMousePosition()
        dt := rl.GetFrameTime()
        pos := mouse_pos
        for &spring in springs {
            spring_update(&spring, pos, dt)
            pos = spring.pos
        }



        if rl.IsKeyPressed(rl.KeyboardKey.S) {
            selected += 1
        }
        if rl.IsKeyPressed(rl.KeyboardKey.W) {
            selected -= 1
            if selected < 0 {
                selected = len(values) - 1
            }
        }
        selected %= len(values)

        if rl.IsKeyPressed(rl.KeyboardKey.D) {
            value: ^Value = &values[selected]
            value.value += value.amount
        }
        if rl.IsKeyPressed(rl.KeyboardKey.A) {
            value: ^Value = &values[selected]
            value.value -= value.amount
        }

        for &spring in springs {
            spring.stiffness = values[0].value
            spring.damping = values[1].value
            spring.rest_len = values[2].value
            spring.mass = values[3].value
            spring.grav = values[4].value
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        
        pos = mouse_pos
        for spring in springs {
            //spring_debug_draw(spring, pos)
            //rl.DrawLineBezier(pos, spring.pos, 10.0, rl.GREEN)
            //rl.DrawCircle(i32(pos.x), i32(pos.y), 10.0, rl.RED)
            spring_debug_draw(spring, pos)
            pos = spring.pos
        }
        rl.DrawCircle(i32(pos.x), i32(pos.y), 10.0, rl.RED)

        y_pos: i32 = 20
        index: i32 = 0
        for value in values {
            color := rl.WHITE
            name := ""
            if selected == index {
                color = rl.RED
                name = fmt.tprintf(">%s: %f", value.name, value.value)
            }
            else {
                name = fmt.tprintf("%s: %f", value.name, value.value)
            }
            c_str := strings.clone_to_cstring(name)
            rl.DrawText(c_str, 10, y_pos, 20, color)

            y_pos += 25
            index += 1
        }


        rl.EndDrawing()
    }
}