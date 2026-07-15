package test

import rl "vendor:raylib"
import math "core:math"

//------------------------------
//region CONSTANTS

//endregion
//------------------------------
//region STRUCTS
Chunk :: struct {
    x1: i32,
    y1: i32,
    cells: [64][64]f32,
    load: bool,
}
//endregion
//------------------------------
//region PROCEDURES


GenerateChunk :: proc(seed: i64 = 0, xTL: i32 = 0, yTL: i32 = 0) -> Chunk {
    // Generate 64 by 64 chunk based on world position and seed
    out_chunk: Chunk
    out_chunk.x1 = xTL
    out_chunk.y1 = yTL
    for i in 0..<i32(64) {
        for j in 0..<i32(64) {
            out_chunk.cells[i][j] = GetCompositeSimplexValues(seed, (xTL*64)+i, (yTL*64)+j)
        }
    }
    return out_chunk
}


//endregion
