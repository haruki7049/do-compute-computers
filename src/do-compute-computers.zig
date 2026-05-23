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

    var _4_4_c4_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .c, .octave = 4 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_c4_sawtooth.filter(Filters.decay);
    defer _4_4_c4_sawtooth.deinit();

    var _4_4_e4_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .e, .octave = 4 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_e4_sawtooth.filter(Filters.decay);
    defer _4_4_e4_sawtooth.deinit();

    var _4_4_g4_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .g, .octave = 4 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_g4_sawtooth.filter(Filters.decay);
    defer _4_4_g4_sawtooth.deinit();

    var _4_4_gs4_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .gs, .octave = 4 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_gs4_sawtooth.filter(Filters.decay);
    defer _4_4_gs4_sawtooth.deinit();

    var _4_4_c5_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .c, .octave = 5 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_c5_sawtooth.filter(Filters.decay);
    defer _4_4_c5_sawtooth.deinit();

    var _4_4_ds5_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .ds, .octave = 5 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_ds5_sawtooth.filter(Filters.decay);
    defer _4_4_ds5_sawtooth.deinit();

    var _4_4_as5_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .as, .octave = 5 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_as5_sawtooth.filter(Filters.decay);
    defer _4_4_as5_sawtooth.deinit();

    var _4_4_d6_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .d, .octave = 6 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_d6_sawtooth.filter(Filters.decay);
    defer _4_4_d6_sawtooth.deinit();

    var _4_4_f6_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        44100 / 9,
        Scale.gen(.{ .code = .f, .octave = 6 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_f6_sawtooth.filter(Filters.decay);
    defer _4_4_f6_sawtooth.deinit();

    return try Splitter.gen(
        f64,
        allocator,
        30000,
        &.{
            _4_4_c4_sawtooth,
            _4_4_e4_sawtooth,
            _4_4_g4_sawtooth,
            _4_4_c4_sawtooth,
            _4_4_e4_sawtooth,
            _4_4_g4_sawtooth,

            _4_4_gs4_sawtooth,
            _4_4_c5_sawtooth,
            _4_4_ds5_sawtooth,
            _4_4_gs4_sawtooth,
            _4_4_c5_sawtooth,
            _4_4_ds5_sawtooth,

            _4_4_as5_sawtooth,
            _4_4_d6_sawtooth,
            _4_4_f6_sawtooth,
            _4_4_as5_sawtooth,
            _4_4_d6_sawtooth,
            _4_4_f6_sawtooth,
        },
        sample_rate,
        channels,
    );
}
