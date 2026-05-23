const std = @import("std");
const lightmix = @import("lightmix");

pub fn inner(comptime T: type, original: lightmix.Wave(T)) !lightmix.Wave(T) {
    var result_samples: []T = try original.allocator.alloc(T, original.samples.len);

    // Process each sample, applying a decay factor
    for (original.samples, 0..original.samples.len) |sample, i| {
        // Calculate how far from the end we are
        const remaining_samples = original.samples.len - i;

        // Decay factor: 1.0 at start, 0.0 at end
        const decay_factor = @as(T, @floatFromInt(remaining_samples)) /
            @as(T, @floatFromInt(original.samples.len));

        // Apply the decay to the sample
        const decayed_sample = sample * decay_factor;
        result_samples[i] = decayed_sample;
    }

    // Return a new Wave with the filtered samples
    return lightmix.Wave(T){
        .samples = result_samples,
        .allocator = original.allocator,
        .sample_rate = original.sample_rate,
        .channels = original.channels,
    };
}
