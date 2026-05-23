const std = @import("std");
const l = @import("lightmix");

pub fn build(b: *std.Build) anyerror!void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Dependencies
    const lightmix = b.dependency("lightmix", .{});

    // Modules
    const mod = b.createModule(.{
        .root_source_file = b.path("src/do-compute-computers.zig"),
        .target = target,
        .optimize = optimize,
        .imports = &.{
            .{ .name = "lightmix", .module = lightmix.module("lightmix") },
        },
    });

    // Library linking on Linux
    if (target.result.os.tag == .linux) {
        mod.linkSystemLibrary("alsa", .{});
        mod.linkSystemLibrary("libpulse", .{});
        mod.linkSystemLibrary("libpipewire-0.3", .{});
    }

    // Static Library Install
    const lib = b.addLibrary(.{
        .linkage = .static,
        .name = "do-compute-computers",
        .root_module = mod,
    });
    b.installArtifact(lib);

    // Wave Install
    const wave = try l.addWave(b, mod, .{
        .format = .{ .wav = .{
            .bits = 16,
            .format_code = .pcm,
        } },
    });
    l.installWave(b, wave);

    // Play step
    const play_step = b.step("play", "Play the produced .wav");
    const play = try l.addPlay(b, wave, .{});
    play_step.dependOn(&play.step);

    // Unit tests
    const unit_tests = b.addTest(.{ .root_module = mod });
    const run_unit_tests = b.addRunArtifact(unit_tests);

    // Test step
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
