package test

import "core:strconv"
import "core:log"
import rl "vendor:raylib"
import la "core:math/linalg"


//------------------------------

//region CONSTANTS
/*
WINDOW_TITLE :: "01 Open Window"
SCREEN_WIDTH :: 320
SCREEN_HEIGHT :: 320
*/
//endregion

//------------------------------

//region STRUCTS
Entity :: struct {
    default_image: rl.Texture2D,
    pos, vel: [2]f32,
    grounded: bool,
}

//endregion
//------------------------------

//region PROCEDURES
CreateEntity :: proc(_default_image_string: cstring = "sprites/cow.png", _pos: [2]f32 = {0,0}, _vel: [2]f32 = {0,0}, _grounded: bool = false) -> Entity{
    loaded_texture := rl.LoadTexture(_default_image_string)
    entity := Entity{loaded_texture, _pos, _vel, _grounded}
    return entity
}



ProgramA :: proc() {
    man := CreateEntity("sprites/man.png")

    for !rl.WindowShouldClose() {

        if rl.IsKeyDown(.A) {
            man.vel.x = -1
        } else if rl.IsKeyDown(.D) {
            man.vel.x = 1
        } else {
            man.vel.x = 0
        }

        if man.grounded && rl.IsKeyPressed(.J) {
            man.vel.y = (-480)
            man.grounded = false;
        } else {
            man.vel.y += (1280 * rl.GetFrameTime())
        }

        man.vel.x *= 96
        man.pos += man.vel * rl.GetFrameTime()

        if (man.pos.y > f32(rl.GetScreenHeight() -64)) {
                man.pos.y = f32(rl.GetScreenHeight() -64)
                man.grounded = true;
        }

        log.info("-")
        log.info(man.pos)
        log.info(man.vel)

        rl.BeginDrawing()
        rl.ClearBackground({160,200,255,255})
        rl.DrawTextureEx(man.default_image, man.pos, 0, 2, rl.WHITE)
        rl.DrawText("TEST", 4, 4, 8, {200,0,0,255})
        rl.EndDrawing()
    }
}

//endregion

//------------------------------
//-           MAIN             -
//------------------------------

//region MAIN
main :: proc() {


    mappy()
    
    /*
    context.logger = log.create_console_logger()
    log.info("PROGRAM START | TEST LOG")

    rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, WINDOW_TITLE)
    //rl.SetTargetFPS(60)
    
    //ProgramA()
    ProgramB()

    rl.CloseWindow()
    */
}
//endregion
