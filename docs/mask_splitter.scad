// ============================================================================
// MASK SPLITTER v1.0
// Complete Parametric Mask Hollowing and Splitting Script
// ============================================================================
// 
// INSTRUCTIONS:
// 1. Save this file as "mask_splitter.scad"
// 2. Place your STL file in the same directory
// 3. Adjust parameters in the "Customizer" tab (right panel)
// 4. F5 to preview, F6 to render (BE PATIENT - can take hours!)
// 5. Export as STL when complete
//
// WORKFLOW:
// - Set render_part = "front", render (F6), export
// - Change to render_part = "back", render (F6), export
// - Print both halves
// - Test fit before gluing
//
// ============================================================================

/* [Model Settings] */
// Path to your STL file (relative to this .scad file)
stl_file = "head_model.stl";

// Wall thickness in millimeters (2-4mm recommended)
wall_thickness = 3.0;

// Resolution for curves (12=draft, 24=normal, 32=high quality)
render_quality = 24; // [12:4:64]

/* [Split Configuration] */
// Which part to render
render_part = "front"; // [front, back, both_preview, both_export]

// Position of split plane on X-axis (0 = center)
split_plane_x = 0;

// Gap between halves in mm (creates slight separation)
split_gap = 0.1;

// Angle of split plane in degrees (0 = vertical)
split_angle = 0; // [-45:5:45]

/* [Registration Pins] */
// Enable alignment pins
enable_pins = true;

// Pin diameter in mm
pin_diameter = 6.0;

// Pin length in mm (half on each side)
pin_length = 12.0;

// Clearance for pin fit (0.15mm per side = 0.3mm total gap)
pin_clearance = 0.15;

// Number of pins (evenly distributed)
number_of_pins = 4; // [2:1:8]

/* [Pin Positions - Manual Override] */
// Use manual pin positions instead of auto-distribution
use_manual_pins = false;

// Manual pin positions (only used if use_manual_pins = true)
// Format: [x, y, z, rotation_around_x_axis]
manual_pin_1 = [0, 0, 80, 0];
manual_pin_2 = [0, 50, 30, 90];
manual_pin_3 = [0, -50, 30, 90];
manual_pin_4 = [0, 20, -40, 45];

/* [Drainage Hole] */
// Add drainage/vent hole (recommended for 3D printing)
enable_drainage = true;

// Drainage hole diameter in mm
drainage_diameter = 15.0;

// Drainage hole position [x, y, z]
drainage_position = [0, 0, -100];

/* [Advanced Options] */
// Scale entire model (1.0 = original size)
model_scale = 1.0;

// Minkowski resolution (affects offset quality)
minkowski_resolution = 24; // [12:4:64]

// Show original model for reference (preview only)
show_original = false;

// Convexity parameter for complex models (increase if errors occur)
convexity_value = 10; // [10:5:50]

/* [Development/Debug] */
// Show split plane (helps visualize cut location)
show_split_plane = false;

// Show pin locations as spheres (preview only)
show_pin_markers = false;

// Transparency for preview (0=solid, 1=invisible)
preview_alpha = 1.0; // [0.1:0.1:1.0]

// ============================================================================
// DO NOT EDIT BELOW THIS LINE (unless you know what you're doing!)
// ============================================================================

// Set preview vs render quality
$fn = $preview ? max(12, render_quality/2) : render_quality;

// ============================================================================
// CORE GEOMETRY MODULES
// ============================================================================

// Import and scale the original model
module original_model() {
    scale([model_scale, model_scale, model_scale])
        import(stl_file, convexity=convexity_value);
}

// Create hollow shell using minkowski offset method
module hollow_shell() {
    difference() {
        // Outer surface - original model offset by wall thickness
        minkowski() {
            original_model();
            sphere(r=wall_thickness, $fn=minkowski_resolution);
        }
        
        // Inner cavity - original model
        original_model();
        
        // Optional drainage hole
        if (enable_drainage) {
            translate(drainage_position)
                cylinder(
                    h=200, 
                    d=drainage_diameter, 
                    center=true, 
                    $fn=render_quality
                );
        }
    }
}

// ============================================================================
// PIN GENERATION
// ============================================================================

// Single alignment pin (male part)
module alignment_pin() {
    rotate([0, 90, 0])
        cylinder(
            h=pin_length, 
            d=pin_diameter, 
            center=true, 
            $fn=render_quality
        );
}

// Single pin socket (female part)
module pin_socket() {
    rotate([0, 90, 0])
        cylinder(
            h=pin_length + 4,  // Extra length for clearance
            d=pin_diameter + 2*pin_clearance, 
            center=true, 
            $fn=render_quality
        );
}

// Calculate automatic pin positions
function auto_pin_positions(n) = 
    use_manual_pins ? 
    [manual_pin_1, manual_pin_2, manual_pin_3, manual_pin_4] :
    [for (i = [0:n-1]) 
        [
            0,  // X position (on split plane)
            50 * cos(360 * i / n),  // Y position (circular distribution)
            60 * sin(360 * i / n),  // Z position (circular distribution)
            90 - 360 * i / n  // Rotation to point inward
        ]
    ];

// All pins at once
module all_pins() {
    positions = auto_pin_positions(number_of_pins);
    for (pos = positions) {
        if (pos != undef) {  // Skip undefined positions
            translate([pos[0], pos[1], pos[2]])
                rotate([pos[3], 0, 0])
                    alignment_pin();
        }
    }
}

// All sockets at once
module all_sockets() {
    positions = auto_pin_positions(number_of_pins);
    for (pos = positions) {
        if (pos != undef) {
            translate([pos[0], pos[1], pos[2]])
                rotate([pos[3], 0, 0])
                    pin_socket();
        }
    }
}

// Visual markers for pin locations (preview only)
module pin_markers() {
    if ($preview && show_pin_markers) {
        positions = auto_pin_positions(number_of_pins);
        for (pos = positions) {
            if (pos != undef) {
                color("red", 0.5)
                    translate([pos[0], pos[1], pos[2]])
                        sphere(d=pin_diameter+2, $fn=16);
            }
        }
    }
}

// ============================================================================
// SPLITTING MODULES
// ============================================================================

// Cutting cube (large enough to encompass model)
module split_cube(side_offset) {
    rotate([0, split_angle, 0])
        translate([split_plane_x + side_offset, 0, 0])
            cube([1000, 2000, 2000], center=true);
}

// Visual split plane (preview only)
module split_plane_visual() {
    if ($preview && show_split_plane) {
        color("yellow", 0.3)
            rotate([0, split_angle, 0])
                translate([split_plane_x, 0, 0])
                    cube([2, 400, 400], center=true);
    }
}

// Front half (positive X side) with pins
module front_half() {
    union() {
        // Main body
        intersection() {
            hollow_shell();
            split_cube(-split_gap);
        }
        
        // Add pins if enabled
        if (enable_pins) {
            intersection() {
                all_pins();
                // Keep only the protruding portion
                translate([-(pin_length/2 + 2), 0, 0])
                    cube([pin_length + 4, 2000, 2000], center=true);
            }
        }
    }
}

// Back half (negative X side) with sockets
module back_half() {
    difference() {
        // Main body
        intersection() {
            hollow_shell();
            split_cube(split_gap);
        }
        
        // Subtract sockets if enabled
        if (enable_pins) {
            all_sockets();
        }
    }
}

// ============================================================================
// ASSEMBLY AND DISPLAY
// ============================================================================

// Show original model for reference
module show_reference() {
    if ($preview && show_original) {
        color("white", 0.3)
            original_model();
    }
}

// Both halves separated for preview
module both_halves_preview() {
    front_half();
    translate([0, 200, 0])  // Separate for viewing
        back_half();
}

// Both halves in assembly position
module both_halves_assembled() {
    front_half();
    back_half();
}

// ============================================================================
// MAIN RENDER LOGIC
// ============================================================================

// Set transparency for preview
if ($preview) {
    color([0.5, 0.7, 1.0], preview_alpha) {
        main_render();
    }
} else {
    main_render();
}

// Main rendering module
module main_render() {
    if (render_part == "front") {
        front_half();
    } else if (render_part == "back") {
        back_half();
    } else if (render_part == "both_preview") {
        both_halves_preview();
    } else if (render_part == "both_export") {
        both_halves_assembled();
    } else {
        // Default to front if invalid option
        front_half();
    }
}

// Visual aids (preview only)
show_reference();
split_plane_visual();
pin_markers();

// ============================================================================
// USAGE NOTES
// ============================================================================
//
// PARAMETER GUIDE:
//
// wall_thickness:
//   - 2mm: Lightweight, minimum strength
//   - 3mm: Good balance (RECOMMENDED)
//   - 4mm: Heavy duty, more expensive
