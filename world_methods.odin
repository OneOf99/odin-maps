package test

import rl "vendor:raylib"
import math "core:math"
import noise "core:math/noise"

//------------------------------

//region CONSTANTS

//endregion

//------------------------------

//region STRUCTS

//endregion
//------------------------------

//region PROCEDURES
GetSimplexValue :: proc(seed: i64 = 0, x: i32 = 0, y: i32 = 0, depth: f64 = 1, weight: f32 = 1) -> f32 {
    return (noise.noise_2d(seed, {f64(x)*depth*0.01, f64(y)*depth*0.01})*weight)
}

GetCompositeSimplexValues :: proc(seed: i64 = 0, x: i32 = 0, y: i32 = 0) -> f32{
    values: [dynamic]f32
    upper: f32 = 4
    for i in 0..<upper {
        depth: f64 = math.pow(2,f64(i))
        append(&values, GetSimplexValue(seed, x, y, depth, math.pow(2, upper-f32(i)-1)))
    }
    return math.sum(values[:])/15
}


GetChunkRegionTL :: proc(x: i32, y: i32) -> [2]i32 {
    res: [2]i32 = {x,y}
    if x < 0 do res.x -= 64
    if y < 0 do res.y -= 64
    res.x = i32(int(res.x)/64)
    res.y = i32(int(res.y)/64)
    return res
}
//endregion
