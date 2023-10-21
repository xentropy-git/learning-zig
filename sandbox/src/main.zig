const std = @import("std");

pub fn main() !void {
    const c = @as(i32, 128);
    const out = std.io.getStdOut().writer();

    try out.print("The const is {d}", .{c});
}
