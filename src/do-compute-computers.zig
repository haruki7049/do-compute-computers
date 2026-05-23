const std = @import("std");
const lightmix = @import("lightmix");

const Sawtooth = @import("./sawtooth.zig");
const Scale = @import("./scale.zig");
const Splitter = @import("./splitter.zig");
const Filters = @import("./filters.zig");

pub fn gen(allocator: std.mem.Allocator) !lightmix.Wave(f64) {
    const sample_rate = 44100;
    const channels = 1;
    const volume: f64 = 0.25;

    var _4_4_c3_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        sample_rate / 9,
        Scale.gen(.{ .code = .c, .octave = 3 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_c3_sawtooth.filter(Filters.decay);
    defer _4_4_c3_sawtooth.deinit();

    return try Splitter.gen(
        f64,
        allocator,
        sample_rate * 4,
        &.{
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
            _4_4_c3_sawtooth,
        },
        sample_rate,
        channels,
    );
}
