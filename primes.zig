const std = @import("std");
const arr = std.ArrayList;
const page_alloc = std.heap.page_allocator;

const prime_limit = u8;
const maxInt = std.math.maxInt(prime_limit);

fn prime_prover(num: prime_limit, cur_primes: *arr(prime_limit)) !bool {
    for (cur_primes.items) |prime| {
        if (num % prime == 0) {
            return false;
        } else if (prime > std.math.sqrt(num)) {
            break;
        }
    }
    return true;
}

pub fn main() !void {
    var prime_list = arr(prime_limit).init(page_alloc);
    defer prime_list.deinit();

    var start: prime_limit = 2;
    while (start <= maxInt) {
        var isPrime = try prime_prover(start, &prime_list);

        if (isPrime) {
            try prime_list.append(start);
        }

        if (start != maxInt) {
            start += 1;
        } else {
            break;
        }
    }
    try std.io.getStdOut().writer().print("Prime list up to {d}: {any}\n", .{ maxInt, prime_list.items });
}
