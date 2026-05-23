const std = @import("std");
const lightmix = @import("lightmix");

const Sawtooth = @import("./sawtooth.zig");
const Scale = @import("./scale.zig");
const Splitter = @import("./splitter.zig");
const Filters = @import("./filters.zig");

pub fn gen(allocator: std.mem.Allocator) !lightmix.Wave(f64) {
    const bpm = 120;
    const sample_rate = 44100;
    const channels = 1;
    const volume: f64 = 0.25;

    var _4_4_c2_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        spb(bpm, sample_rate) / 6,
        Scale.gen(.{ .code = .c, .octave = 2 }),
        sample_rate,
        channels,
        volume,
    );
    try _4_4_c2_sawtooth.filter(Filters.decay);
    defer _4_4_c2_sawtooth.deinit();

    return try Splitter.gen(
        f64,
        allocator,
        spb(bpm, sample_rate) * 8,
        &.{
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
            _4_4_c2_sawtooth,
        },
        sample_rate,
        channels,
    );
}

fn spb(bpm: usize, sample_rate: u32) usize {
    const samples_per_beat: usize = @intFromFloat(@as(f32, @floatFromInt(60)) / @as(f32, @floatFromInt(bpm)) * @as(f32, @floatFromInt(sample_rate)));
    return samples_per_beat;
}
