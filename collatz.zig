const std = @import("std");
const Arr = std.ArrayList;
const page_alloc = std.heap.page_allocator;

fn collatz(start: u32, steps: *Arr(u32)) !void {
    var num = start;
    while (num != 1) {
        if (num % 2 == 0) {
            num = num / 2;
        } else {
            num = 3 * num + 1;
        }
        try steps.append(num);
    }
}

pub fn main() !void {
    var start: u32 = 2;
    var steps = Arr(u32).init(page_alloc);
    defer steps.deinit();

    const writer = std.io.getStdOut().writer();

    while (start <= std.math.maxInt(u32)) {
        try collatz(start, &steps);
        try writer.print("Start: {d} | Steps: {any}\n", .{ start, steps.items });

        steps.shrinkAndFree(0);
        std.time.sleep(1 * std.time.ns_per_ms);
        start += 1;
    }
}
