//! # Square Wave - The Digital Sound
//!
//! A square wave alternates between two values (high and low) with sharp transitions.
//! It produces a rich, buzzy sound with many odd harmonics, commonly used in retro video game music.
//!
//! ## What you'll learn:
//! - How to generate a square wave
//! - Understanding duty cycle (50% in this example)
//! - The characteristic "buzzy" sound of square waves
//!
//! ## Sound characteristics:
//! - Contains fundamental frequency + odd harmonics (3rd, 5th, 7th, etc.)
//! - Sharp, electronic, "8-bit" sound

const std = @import("std");
const lightmix = @import("lightmix");

pub fn gen(
    comptime T: type,
    allocator: std.mem.Allocator,
    length: usize,
    frequency: T,
    sample_rate: u32,
    channels: u16,
    volume: T,
) std.mem.Allocator.Error!lightmix.Wave(T) {
    var samples: []T = try allocator.alloc(T, length);
    for (0..samples.len) |i| {
        const t = @as(T, @floatFromInt(i)) / @as(T, @floatFromInt(sample_rate));
        const phase = t * frequency;

        // Square wave: +1 for first half of cycle, -1 for second half
        // We use @mod to get the fractional part of the phase
        samples[i] = if (@mod(phase, 1.0) < 0.5) volume else -volume;
    }

    return lightmix.Wave(T){
        .allocator = allocator,
        .samples = samples,
        .sample_rate = sample_rate,
        .channels = channels,
    };
}
