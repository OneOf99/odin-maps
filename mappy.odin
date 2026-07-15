package test

import "core:strconv"
import "core:log"
import rl "vendor:raylib"
import la "core:math/linalg"
import noise "core:math/noise"
import math "core:math"

//------------------------------

//region CONSTANTS
WINDOW_TITLE :: "01 Open Window"
SCREEN_WIDTH :: 320
SCREEN_HEIGHT :: 320

//endregion

//------------------------------

//region STRUCTS

Cell :: struct {
    width:  f32,
    height: f32,
}
//endregion
//------------------------------

//region PROCEDURES

HSVtoRGBA :: proc(hue: f32, saturation: f32, value: f32, alpha: u8 = 255) -> rl.Color {
    // Hue is from 0 to 360
    // Saturation is 0.0 to 1.0
    // Value is 0.0 to 1.0
    // Alpha is 0 to 255

    tempH := hue
    tempH /= 60
    hp := i32(math.floor(tempH))

    f := f32(tempH - f32(hp))
    p := f32(value * (1 - saturation))
    q := f32(value * (1 - saturation * f))
    t := f32(value * (1 - saturation * (1 - f))) 


    rgb_calc:= [4]f32{0,0,0,255}
    switch (hp) {
        case 0:
            rgb_calc = {value, t, p, 255}
        case 1:
            rgb_calc = {q, value, p, 255}
        case 2:
            rgb_calc = {p, value, t, 255}
        case 3:
            rgb_calc = {p, q, value, 255}
        case 4:
            rgb_calc = {t, p, value, 255}
        case 5:
            rgb_calc = {value, p, q, 255}
    }

    rgb_calc.r *= 255
    rgb_calc.g *= 255
    rgb_calc.b *= 255

    return rl.Color({u8(rgb_calc.r), u8(rgb_calc.g), u8(rgb_calc.b), alpha})

}

// Draw single pixel cell to screen as rectangle
DrawCell :: proc(x: i32, y: i32, pass_val: f32) {
    val := (pass_val+1)/2

    cell_color: rl.Color

    if (val < 0.45) {
        cell_color = HSVtoRGBA(250, 1, val+0.4)
    } else if (val < 0.5) {
        cell_color = HSVtoRGBA(50, 1, val+0.4)
    } else if (val < 0.7) {
        cell_color = HSVtoRGBA(100, 1, val)
    } else if (val < 0.8) {
        cell_color = HSVtoRGBA(100, 1, val)
    } else {
        cell_color = HSVtoRGBA(0, 0, val)
    }
    rl.DrawRectangle(x, y, 1, 1, cell_color)
}

// Draw all cells within a chunk
DrawChunk :: proc(chunk: Chunk, home: [2]i32) {
    for i in 0..<i32(64) {
        for j in 0..<i32(64) {
            x_pos := i32(chunk.x1*64) + i
            y_pos := i32(chunk.y1*64) + j
            //log.infof("%d\t%d",x_pos, y_pos)
            DrawCell(x_pos-home.x, y_pos-home.y, chunk.cells[i][j])
        }
    }
}

//endregion

//------------------------------
//-           MAIN             -
//------------------------------

//region MAIN
mappy :: proc() {

    context.logger = log.create_console_logger()
    log.info("PROGRAM START | TEST LOG")

    //log.infof("%f",GetChunkRegionTL(90, 90))
    //log.infof("%f",GetChunkRegionTL(-60, -100))

    flags: rl.ConfigFlags = {.WINDOW_RESIZABLE}
    rl.SetConfigFlags( flags )
    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)
    defer rl.CloseWindow()


    //rl.SetTargetFPS(60)
    //voronoiMap: matrix[10,10][2]int

    value: f32
    seeds := [4]i64{67, 69, 42, 420}
    screen_width: i32
    screen_height: i32
    home_pos := [2]i32{0,0}
    end_pos := [2]i32{SCREEN_WIDTH, SCREEN_HEIGHT}

    chunk_map: map[[2]i32]Chunk

    // Initial chunk generation
    home_reg := GetChunkRegionTL(home_pos.x, home_pos.y)
    end_reg := GetChunkRegionTL(SCREEN_WIDTH, SCREEN_HEIGHT)
    log.infof("%d %d",home_reg.x, home_reg.y)
    log.infof("%d %d",end_reg.x, end_reg.y)

    for i in home_reg.x..=end_reg.x {
        for j in home_reg.y..=end_reg.y {
            //log.infof("%d",[2]i32{i, j})
            chunk_map[{i, j}] = GenerateChunk(seeds[0], i, j)
        }
    }

    for !rl.WindowShouldClose() {

        // Get screen and mouse data
        screen_width = rl.GetScreenWidth()
        screen_height = rl.GetScreenHeight()
        mouse_pos := rl.GetMousePosition()

        // Move "camera"
        if rl.IsKeyDown(.A) {
            home_pos.x -= 10
        } else if rl.IsKeyDown(.D) {
            home_pos.x += 10
        }

        if rl.IsKeyDown(.W) {
            home_pos.y -= 10
        } else if rl.IsKeyDown(.S) {
            home_pos.y += 10
        }

        // Draw cycle
        rl.BeginDrawing()
        {
            rl.ClearBackground({255,255,255,255})

            
            home_reg = GetChunkRegionTL(home_pos.x, home_pos.y)
            end_reg = GetChunkRegionTL(home_pos.x+screen_width, home_pos.y+screen_height)

            for i in home_reg.x..=end_reg.x {
                for j in home_reg.y..=end_reg.y {
                    //log.infof("%d",[2]i32{i, j})
                    chunk, ok := chunk_map[{i,j}]
                    if !ok {
                        log.info("%d %d",i, j)
                        chunk_map[{i, j}] = GenerateChunk(seeds[0], i, j)
                        chunk = chunk_map[{i, j}]
                    }
                    DrawChunk(chunk, home_pos)
                }
            }
            /*
            for chunk_reg, chunk in chunk_map {
                if !chunk.load {
                    delete_key(&chunk_map, chunk_reg)
                } else {
                    chunk_map[chunk_reg].load = false
                }
            }
                */
            
        }
        rl.EndDrawing()
    }

    log.infof("END PROGRAM")
    
}
//endregion
