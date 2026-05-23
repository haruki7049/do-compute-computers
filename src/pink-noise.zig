const std = @import("std");
const lightmix = @import("lightmix");

var prng = std.Random.DefaultPrng.init(0);

pub fn gen(
    comptime T: type,
    allocator: std.mem.Allocator,
    length: usize,
    sample_rate: u32,
    channels: u16,
    volume: T,
) std.mem.Allocator.Error!lightmix.Wave(T) {
    const rand = prng.random();

    // Paul Kellett's refined method for pink noise
    var b0: f64 = 0.0;
    var b1: f64 = 0.0;
    var b2: f64 = 0.0;

    var samples: []T = try allocator.alloc(T, length);
    for (0..samples.len) |i| {
        const white = rand.float(f64) * 2.0 - 1.0;

        b0 = 0.99765 * b0 + white * 0.0990460;
        b1 = 0.96300 * b1 + white * 0.2965164;
        b2 = 0.57000 * b2 + white * 1.0526913;

        samples[i] = (b0 + b1 + b2 + white * 0.1848) * volume;
    }

    return lightmix.Wave(T){
        .allocator = allocator,
        .samples = samples,
        .sample_rate = sample_rate,
        .channels = channels,
    };
}
