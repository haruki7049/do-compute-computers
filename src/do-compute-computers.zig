const std = @import("std");
const lightmix = @import("lightmix");

const Sawtooth = @import("./sawtooth.zig");
const PinkNoise = @import("./pink-noise.zig");
const Scale = @import("./scale.zig");
const Splitter = @import("./splitter.zig");
const Filters = @import("./filters.zig");

pub fn gen(allocator: std.mem.Allocator) !lightmix.Wave(f64) {
    const bpm = 180;
    const sample_rate = 44100;
    const channels = 1;
    const volume: f64 = 1.0;

    var c2_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        spb(bpm, sample_rate) / 6,
        Scale.gen(.{ .code = .c, .octave = 2 }),
        sample_rate,
        channels,
        volume * 0.25,
    );
    try c2_sawtooth.filter(Filters.decay);
    defer c2_sawtooth.deinit();

    var pinkNoise = try PinkNoise.gen(
        f64,
        allocator,
        spb(bpm, sample_rate),
        sample_rate,
        channels,
        volume * 0.125,
    );
    try pinkNoise.filter(Filters.decay);
    try pinkNoise.filter(Filters.decay);
    defer pinkNoise.deinit();

    const a2_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .a, .octave = 2 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer a2_major.deinit();

    const b2_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .b, .octave = 2 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer b2_major.deinit();

    const c3_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .c, .octave = 3 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer c3_major.deinit();

    const d3_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .d, .octave = 3 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer d3_major.deinit();

    const e3_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .e, .octave = 3 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer e3_major.deinit();

    const g3_major = try gen_major(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .g, .octave = 3 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer g3_major.deinit();

    const ds3_minor = try gen_minor(
        f64,
        allocator,
        spb(bpm, sample_rate) * 2,
        .{ .code = .ds, .octave = 3 },
        sample_rate,
        channels,
        volume * 0.125,
    );
    defer ds3_minor.deinit();

    const drums = try Splitter.gen(
        f64,
        allocator,
        spb(bpm, sample_rate) * 16,
        &.{
            c2_sawtooth,
            null,
            pinkNoise,
            null,
            c2_sawtooth,
            null,
            pinkNoise,
            null,
            c2_sawtooth,
            null,
            pinkNoise,
            null,
            c2_sawtooth,
            c2_sawtooth,
            pinkNoise,
            null,

            c2_sawtooth,
            null,
            pinkNoise,
            null,
            c2_sawtooth,
            null,
            pinkNoise,
            null,
            c2_sawtooth,
            c2_sawtooth,
            pinkNoise,
            c2_sawtooth,
            c2_sawtooth,
            c2_sawtooth,
            pinkNoise,
            null,
        },
        sample_rate,
        channels,
    );
    defer drums.deinit();

    var composer = lightmix.Composer(f64).init(allocator, .{ .channels = channels, .sample_rate = sample_rate });
    defer composer.deinit();

    for (0..4) |i| {
        try composer.append(.{ .wave = drums, .start_point = spb(bpm, sample_rate) * i * 16 });
    }
    for (0..2) |i| {
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (0 + i * 32) });
        try composer.append(.{ .wave = e3_major, .start_point = spb(bpm, sample_rate) * (2 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (4 + i * 32) });
        try composer.append(.{ .wave = d3_major, .start_point = spb(bpm, sample_rate) * (6 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (8 + i * 32) });
        try composer.append(.{ .wave = e3_major, .start_point = spb(bpm, sample_rate) * (10 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (12 + i * 32) });
        try composer.append(.{ .wave = d3_major, .start_point = spb(bpm, sample_rate) * (14 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (16 + i * 32) });
        try composer.append(.{ .wave = e3_major, .start_point = spb(bpm, sample_rate) * (18 + i * 32) });
        try composer.append(.{ .wave = g3_major, .start_point = spb(bpm, sample_rate) * (20 + i * 32) });
        try composer.append(.{ .wave = d3_major, .start_point = spb(bpm, sample_rate) * (22 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (24 + i * 32) });
        try composer.append(.{ .wave = b2_major, .start_point = spb(bpm, sample_rate) * (26 + i * 32) });
        try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * (28 + i * 32) });
        try composer.append(.{ .wave = a2_major, .start_point = spb(bpm, sample_rate) * (30 + i * 32) });
    }
    try composer.append(.{ .wave = c3_major, .start_point = spb(bpm, sample_rate) * 64 });

    var result = try composer.finalize(.{});
    try result.filter(Filters.normalize);
    return result;
}

fn gen_minor(
    comptime T: type,
    allocator: std.mem.Allocator,
    length: usize,
    master_scale: Scale,
    sample_rate: u32,
    channels: u16,
    volume: T,
) !lightmix.Wave(T) {
    const master_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer master_sawtooth.deinit();

    const minor_third_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.add(3).gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer minor_third_sawtooth.deinit();

    const perfect_fifth_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.add(7).gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer perfect_fifth_sawtooth.deinit();

    const res1 = try master_sawtooth.mix(minor_third_sawtooth, .{});
    defer res1.deinit();
    const res2 = try res1.mix(perfect_fifth_sawtooth, .{});

    return res2;
}

fn gen_major(
    comptime T: type,
    allocator: std.mem.Allocator,
    length: usize,
    master_scale: Scale,
    sample_rate: u32,
    channels: u16,
    volume: T,
) !lightmix.Wave(T) {
    const master_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer master_sawtooth.deinit();

    const major_third_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.add(4).gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer major_third_sawtooth.deinit();

    const perfect_fifth_sawtooth = try Sawtooth.gen(
        f64,
        allocator,
        length,
        master_scale.add(7).gen(),
        sample_rate,
        channels,
        volume * 0.25,
    );
    defer perfect_fifth_sawtooth.deinit();

    const res1 = try master_sawtooth.mix(major_third_sawtooth, .{});
    defer res1.deinit();
    const res2 = try res1.mix(perfect_fifth_sawtooth, .{});

    return res2;
}

fn spb(bpm: usize, sample_rate: u32) usize {
    const samples_per_beat: usize = @intFromFloat(@as(f32, @floatFromInt(60)) / @as(f32, @floatFromInt(bpm)) * @as(f32, @floatFromInt(sample_rate)));
    return samples_per_beat;
}
