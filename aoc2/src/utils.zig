const std = @import("std");

// accumulates into a fixed length array a new value if it is a new maximum.
pub fn accumulateMax(array: []u64, value: u64) void {
    // get the mimimum value and index in the array
    var minima: u64 = std.math.maxInt(u64);
    var minima_index: u64 = 0;

    const l = array.len;

    for (array, 0..l) |x, y| {
        if (x > minima) continue;
        minima = x;
        minima_index = y;
    }

    // replace the global minimam
    array[minima_index] = @max(value, minima);
}
