const std = @import("std");
const test_allocator = std.testing.allocator;

pub fn main() !void {
    try load_input();
}

pub fn load_input() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var sum: u64 = 0;

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        try parse_numeric_words(line);
        var digits = try extract_digits(line);

        std.debug.print("{d} = {s}\n", .{ digits, line });
        sum = sum + digits;
    }
    std.debug.print("{d}\n", .{sum});
}

pub fn extract_digits(line: []u8) !u8 {
    var start: u8 = 0;
    var end: u8 = 0;
    var digits: u8 = 0;

    for (line) |char| {
        if (char >= 48 and char <= 57) {
            // character is a digit
            var digit = char - 48;
            if (start == 0) {
                start = digit;
                digits = 1;
            } else {
                end = digit;
                digits = 2;
            }
        }
    }
    if (digits == 0) return 0;
    // example shows that the result is always a 2 digit number, even if it only has one number.
    if (digits == 1) end = start;
    // must be a 2 digit number line
    var two_digit = start * 10 + end;
    return two_digit;
}

pub fn parse_numeric_words(line: []u8) !void {
    var words = [_][]const u8{ "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine" };
    for (line, 0..) |char, j| {
        for (words, 0..) |word, i| {
            var seek_char = word[0];
            var word_length = word.len;

            if (char != seek_char) continue;
            if (j + word_length > line.len) break;

            var slice0 = line[j .. j + word_length];
            var slice1 = word[0..word.len];
            if (std.mem.eql(u8, slice0, slice1)) {
                //std.debug.print("Matched {s} = {d}: {s}\n", .{ word, i, line });
                // replace first letter of word with number... slight hack to avoid reallocating memory for now.
                var offset: u8 = @truncate(i);
                line[j] = 48 + offset;
            }
        }
    }
    return;
}
