const std = @import("std");
const lightmix = @import("lightmix");

pub fn inner(comptime T: type, original: lightmix.Wave(T)) std.mem.Allocator.Error!lightmix.Wave(T) {
    var result: []T = try original.allocator.alloc(T, original.samples.len);

    var max_volume: T = 0.0;
    for (original.samples) |sample| {
        if (@abs(sample) > max_volume)
            max_volume = @abs(sample);
    }

    for (original.samples, 0..) |sample, i| {
        const volume: T = 1.0 / max_volume;

        const new_sample: T = sample * volume;
        result[i] = new_sample;
    }

    return lightmix.Wave(T){
        .samples = result,
        .allocator = original.allocator,

        .sample_rate = original.sample_rate,
        .channels = original.channels,
    };
}
