# Complete Guide: Converting Solid 3D Head Model to Hollow Mask
## Front/Back Split for 3D Printing

**Author:** Professional Electrical Engineer & 3D Print Fabricator  
**Date:** December 15, 2025  
**Model Type:** Blender Head Mesh → Printable Mask with Registration Features

---

## Table of Contents
1. [Prerequisites & Preparation](#prerequisites)
2. [Option A: Blender Workflow](#option-a-blender)
3. [Option B: OpenSCAD Workflow](#option-b-openscad)
4. [Wall Thickness Guidelines](#wall-thickness)
5. [Registration Features](#registration-features)
6. [Troubleshooting](#troubleshooting)

---

## Prerequisites & Preparation {#prerequisites}

### Required Software
- **Blender Approach:** Blender 4.x or later (free)
- **OpenSCAD Approach:** OpenSCAD 2021.01+ (free)
- **Both:** Slicer software (Cura, PrusaSlicer, etc.)

### File Preparation Checklist
✓ Ensure model has correct scale (life-size or intended size)  
✓ Check for non-manifold geometry  
✓ Verify face normals point outward  
✓ Export/import as STL for compatibility  

### Critical Concepts
- **Manifold/Watertight:** Model must be closed with no holes
- **Wall Thickness:** Typically 2-4mm for masks (balance strength vs weight)
- **Registration Features:** Pins, keys, or dovetails for alignment
- **Split Plane:** Typically vertical through center, sometimes angled for aesthetics

---

## Option A: Blender Workflow {#option-a-blender}

### Phase 1: Model Preparation

#### Step 1.1: Import and Scale
```
1. File → Import → STL (or open your .blend file)
2. Select the head model
3. Press 'N' to open Transform panel
4. Under "Dimensions" verify scale is correct
   - Typical adult head: 180-220mm width
5. Press 'S' to scale if needed, type value, Enter
```

#### Step 1.2: Check Mesh Quality
```
1. Tab to Edit Mode
2. Select → All (A key)
3. Mesh → Normals → Recalculate Outside (Shift+N)
4. Check for non-manifold edges:
   - Select → All (A)
   - Select → Select All by Trait → Non-Manifold
   - If any highlighted, use: Mesh → Clean Up → Merge by Distance
```

#### Step 1.3: Ensure Solid Model
```
If your model has any openings (bottom of neck, etc.):
1. Tab to Edit Mode
2. Select boundary edges
3. F key to fill faces
4. Tab back to Object Mode
```

### Phase 2: Creating Hollow Shell

#### Step 2.1: Add Drainage/Vent Holes (IMPORTANT)
```
CRITICAL: 3D printers and slicers need to detect the model as hollow!

1. Add → Mesh → Cylinder
2. Scale and position cylinder through bottom of model
   - This creates a drainage hole for resin printers
   - Allows air escape for FDM
   - Marks model as hollow for slicer
3. Hide cylinder for now (H key) - we'll use it with Boolean
```

#### Step 2.2: Apply Solidify Modifier
```
1. Select head model
2. Properties Panel → Modifiers → Add Modifier → Solidify
3. Set Mode: "Complex" (handles complex geometry better)
4. Thickness: 0.003 (equals 3mm in Blender units = metric)
   - Recommended: 2-4mm (0.002-0.004 in Blender)
   - Thinner = lighter, cheaper, less strong
   - Thicker = stronger, heavier, more expensive
5. Offset: -1.0 (creates shell inward, maintaining outer dimensions)
6. Enable "Even Thickness" (better results on curved surfaces)
7. Enable "Rim" (creates edge between inner/outer surfaces)
```

**Visual Check:**
- Switch to Wireframe view (Z → Wireframe)
- Verify uniform wall thickness
- Note: Thin features (ears, nose) may not hollow properly - this is normal

#### Step 2.3: Boolean for Drainage Hole
```
1. Unhide cylinder (Alt+H)
2. Select head model
3. Add Modifier → Boolean
4. Operation: "Difference"
5. Object: Select cylinder
6. Solver: "Fast" (usually sufficient)
7. Apply Boolean modifier
8. Delete cylinder object
```

#### Step 2.4: Remesh for Clean Geometry (Optional but Recommended)
```
1. Add Modifier → Remesh
2. Mode: "Voxel"
3. Voxel Size: 0.001-0.002 (smaller = more detail but slower)
   - Balance detail vs file size
   - Too small = huge STL file
4. Enable "Smooth Shading"
5. Preview before applying - this takes time!
```

#### Step 2.5: Apply All Modifiers
```
Once satisfied with preview:
1. Apply Remesh modifier (if used)
2. Apply Solidify modifier
3. File → Export → STL
   - Save as "head_hollow_complete.stl" (backup)
```

### Phase 3: Splitting into Front and Back

#### Step 3.1: Determine Split Line
```
Consider aesthetics and function:
- Vertical center (sagittal plane): easiest, symmetrical
- Angled/curved: better hides seam, harder to align
- Around features: can follow jaw line, hairline, etc.

For this tutorial: vertical center split
```

#### Step 3.2: Using Bisect Tool
```
1. Ensure you're in Edit Mode (Tab)
2. Select → All (A key)
3. Tools Panel (T key) → Knife → Hold and select "Bisect"
   - Alternative: Mesh menu → Bisect
4. Click two points defining the cut plane:
   - Click top center of head
   - Click bottom center of head
5. A visual plane appears with manipulator handles
```

#### Step 3.3: Adjust Cut Plane
```
In bottom-left properties panel:
- "Plane Point" and "Plane Normal" can be fine-tuned
- Check "Fill" to automatically close cut surfaces
- Clear Outer/Clear Inner: choose based on which half to keep
```

#### Step 3.4: Separate Halves
```
For both halves:
1. With bisect line visible, press 'V' to split geometry
2. Hover over one half, press 'L' (selects linked geometry)
3. Press 'P' → "Selection" to separate into new object
4. Tab to Object Mode
5. You now have two objects in right panel

For one half only:
- In Bisect options, choose "Clear Inner" or "Clear Outer"
- This discards one half automatically
```

### Phase 4: Adding Registration Pins/Keys

#### Step 4.1: Create Alignment Pin (Male)
```
1. Add → Mesh → Cylinder
2. Rotate to perpendicular to split plane:
   - Press 'R' (rotate), 'Y' (Y-axis), '90' (degrees)
   - Adjust axis based on your split orientation
3. Scale to appropriate size:
   - Press 'S' (scale) then dimension key
   - Typical: 5-8mm diameter, 10-15mm length
4. Position halfway through split surface
   - Use move gizmo or 'G' key
   - Pin should protrude equally on both sides initially
```

#### Step 4.2: Boolean Add to One Half
```
1. Select front half of mask
2. Add Modifier → Boolean
3. Operation: "Union"
4. Object: Select pin cylinder
5. Apply modifier
6. Delete pin cylinder
Result: Pin is now part of front half
```

#### Step 4.3: Create Socket (Female)
```
1. Select the pin (now part of front half) in Edit Mode
2. Duplicate: Shift+D, press Enter to place at same location
3. Separate duplicate: 'P' → Selection
4. Return to Object Mode
5. Select the duplicate pin
6. Add Modifier → Solidify
   - Thickness: 0.0003 (0.3mm clearance total = 0.15mm per side)
   - Offset: 1.0 (expands outward)
   - This creates 0.15mm gap for easy fit
7. Apply Solidify
```

#### Step 4.4: Boolean Subtract from Other Half
```
1. Select back half of mask
2. Add Modifier → Boolean
3. Operation: "Difference"
4. Object: Select enlarged pin
5. Apply modifier
6. Delete enlarged pin object
Result: Socket cavity in back half
```

#### Step 4.5: Repeat for Multiple Pins
```
Add 3-4 pins total:
- Top of head
- Left temple area
- Right temple area  
- Jaw/bottom area (if applicable)

Distribution prevents rotation and ensures alignment
```

### Phase 5: Final Export

#### Step 5.1: Prepare for Export
```
1. Select each half separately
2. Tab to Edit Mode → Select All
3. Mesh → Normals → Recalculate Outside
4. Mesh → Clean Up → Merge by Distance
5. Tab to Object Mode
```

#### Step 5.2: Export Each Half
```
1. Select front half
2. File → Export → STL
3. Check "Selection Only"
4. Scale: 1.0
5. Save as "mask_front.stl"
6. Repeat for back half → "mask_back.stl"
```

---

## Option B: OpenSCAD Workflow {#option-b-openscad}

### Phase 1: Understanding OpenSCAD Approach

**Advantages:**
- Parametric: easy to adjust wall thickness
- Scriptable: reproducible, version-controllable
- Fast iteration on parameters
- Good for batch processing multiple models

**Limitations:**
- Slower rendering for high-poly meshes
- Less intuitive than visual tools
- Requires some programming knowledge

### Phase 2: Hollowing with Minkowski Method

#### Step 2.1: Basic Hollow Shell Script
```openscad
// ========================================
// CONFIGURATION PARAMETERS
// ========================================
stl_file = "head_model.stl";
wall_thickness = 2.5;  // mm
offset_resolution = 24;  // Higher = smoother but slower

// ========================================
// MAIN HOLLOWING MODULE
// ========================================
module hollow_shell() {
    difference() {
        // Outer shell - original model offset outward
        minkowski() {
            import(stl_file, convexity=10);
            sphere(r=wall_thickness, $fn=offset_resolution);
        }
        
        // Inner cavity - original model
        import(stl_file, convexity=10);
    }
}

// Render the hollow shell
hollow_shell();
```

**How it works:**
- `minkowski()` creates an offset by tracing a sphere around the surface
- `difference()` subtracts original model from offset model
- Result: uniform wall thickness shell

#### Step 2.2: Advanced Hollow with Drainage Hole
```openscad
// ========================================
// CONFIGURATION  
// ========================================
stl_file = "head_model.stl";
wall_thickness = 3.0;
offset_resolution = 32;
drainage_diameter = 20;  // mm
drainage_position = [0, 0, -100];  // Bottom center

// ========================================
// MODULES
// ========================================
module hollow_shell_with_vent() {
    difference() {
        // Hollow shell
        difference() {
            minkowski() {
                import(stl_file, convexity=10);
                sphere(r=wall_thickness, $fn=offset_resolution);
            }
            import(stl_file, convexity=10);
        }
        
        // Drainage hole
        translate(drainage_position)
            cylinder(h=50, d=drainage_diameter, center=true, $fn=32);
    }
}

// Render
hollow_shell_with_vent();
```

#### Step 2.3: Independent Resize Control (Advanced)
```openscad
// ========================================
// ADVANCED: Separate Inner/Outer Control
// ========================================
stl_file = "head_model.stl";
wall_thickness = 2.5;
outer_scale = 1.0;   // Multiplier for outer surface
inner_scale = 0.98;  // Multiplier for inner cavity
offset_resolution = 24;

module hollow_shell_advanced() {
    difference() {
        // Outer shell with offset
        minkowski() {
            scale([outer_scale, outer_scale, outer_scale])
                import(stl_file, convexity=10);
            sphere(r=wall_thickness, $fn=offset_resolution);
        }
        
        // Inner cavity (slightly scaled for thicker walls in tight areas)
        scale([inner_scale, inner_scale, inner_scale])
            import(stl_file, convexity=10);
    }
}

hollow_shell_advanced();
```

### Phase 3: Splitting into Front and Back

#### Step 3.1: Simple Vertical Split
```openscad
// ========================================
// SPLIT CONFIGURATION
// ========================================
stl_file = "head_model.stl";
wall_thickness = 3.0;
split_plane_x = 0;  // X-coordinate of split
extra_tolerance = 0.1;  // Gap between halves

// ========================================
// MODULES
// ========================================
module hollow_shell() {
    difference() {
        minkowski() {
            import(stl_file, convexity=10);
            sphere(r=wall_thickness, $fn=24);
        }
        import(stl_file, convexity=10);
    }
}

// FRONT HALF (positive X)
module front_half() {
    intersection() {
        hollow_shell();
        translate([split_plane_x - extra_tolerance, 0, 0])
            cube([1000, 2000, 2000], center=true);
    }
}

// BACK HALF (negative X)
module back_half() {
    intersection() {
        hollow_shell();
        translate([split_plane_x + extra_tolerance, 0, 0])
            cube([1000, 2000, 2000], center=true);
    }
}

// RENDER CONTROL
// Uncomment the half you want to render
front_half();
//back_half();
```

#### Step 3.2: Angled Split Plane
```openscad
module angled_split_cube(angle_degrees) {
    rotate([0, angle_degrees, 0])
        cube([1000, 2000, 2000], center=true);
}

module front_half_angled() {
    intersection() {
        hollow_shell();
        angled_split_cube(15);  // 15° angle
    }
}
```

### Phase 4: Adding Registration Pins

#### Step 4.1: Pin Generation Module
```openscad
// ========================================
// PIN CONFIGURATION
// ========================================
pin_diameter = 6;       // mm
pin_length = 12;        // mm  
pin_clearance = 0.15;   // mm per side (0.3mm total)
num_pins = 4;

// Pin positions [x, y, z, rotation_around_z]
pin_positions = [
    [0, 0, 80, 0],      // Top
    [0, 50, 30, 90],    // Right temple
    [0, -50, 30, 90],   // Left temple
    [0, 20, -40, 45]    // Jaw
];

// ========================================
// PIN MODULES
// ========================================
module alignment_pin() {
    rotate([0, 90, 0])  // Horizontal orientation
        cylinder(h=pin_length, d=pin_diameter, center=true, $fn=32);
}

module pin_socket() {
    // Oversized for clearance
    rotate([0, 90, 0])
        cylinder(
            h=pin_length + 2, 
            d=pin_diameter + 2*pin_clearance, 
            center=true, 
            $fn=32
        );
}

module all_pins() {
    for (pos = pin_positions) {
        translate([pos[0], pos[1], pos[2]])
            rotate([0, 0, pos[3]])
                alignment_pin();
    }
}

module all_sockets() {
    for (pos = pin_positions) {
        translate([pos[0], pos[1], pos[2]])
            rotate([0, 0, pos[3]])
                pin_socket();
    }
}
```

#### Step 4.2: Complete Split with Pins
```openscad
// ========================================
// COMPLETE MASK WITH REGISTRATION
// ========================================

// FRONT HALF with pins
module front_half_with_pins() {
    union() {
        // Base front half
        intersection() {
            hollow_shell();
            translate([0 - 0.1, 0, 0])
                cube([1000, 2000, 2000], center=true);
        }
        
        // Add pins (protruding into negative X)
        intersection() {
            all_pins();
            translate([0 - pin_length/2, 0, 0])
                cube([pin_length, 2000, 2000], center=true);
        }
    }
}

// BACK HALF with sockets
module back_half_with_sockets() {
    difference() {
        // Base back half
        intersection() {
            hollow_shell();
            translate([0 + 0.1, 0, 0])
                cube([1000, 2000, 2000], center=true);
        }
        
        // Subtract sockets
        all_sockets();
    }
}

// RENDER
front_half_with_pins();
//back_half_with_sockets();
```

### Phase 5: Rendering and Export

#### Step 5.1: Optimize for Rendering
```
IMPORTANT: High-poly STL files are SLOW in OpenSCAD

Tips for faster workflow:
1. Use low $fn values during development ($fn=12-16)
2. Increase only for final render ($fn=24-32)
3. Consider decimating STL in Blender first
4. Use small minkowski sphere radius if possible
5. Render overnight for complex models
```

#### Step 5.2: Export Process
```
1. Design → Compile (F5) for preview
2. Verify model looks correct
3. Design → Render (F6) - THIS MAY TAKE HOURS
   - Monitor progress in console
   - Large models: 15 minutes to 3+ hours
4. File → Export → Export as STL
5. Change code to render other half
6. Repeat render and export
```

#### Step 5.3: Full Working Script Template
See the separate mask_splitter.scad file for the complete, ready-to-use script with all parameters.

---

## Wall Thickness Guidelines {#wall-thickness}

### Material-Specific Recommendations

#### FDM/FFF Printing
| Material | Min Thickness | Recommended | Notes |
|----------|---------------|-------------|-------|
| PLA | 1.6mm | 2.5-3.5mm | Brittle, needs thickness for strength |
| PETG | 1.6mm | 2.0-3.0mm | More flexible than PLA |
| ABS | 2.0mm | 2.5-3.5mm | Warping considerations |
| TPU/Flex | 2.0mm | 2.5-4.0mm | Very forgiving, can go thinner |

#### Resin (SLA/DLP/MSLA)
| Resin Type | Min Thickness | Recommended | Notes |
|------------|---------------|-------------|-------|
| Standard | 1.2mm | 1.5-2.5mm | Strong when cured |
| Tough | 1.0mm | 1.5-2.0mm | High impact resistance |
| Flexible | 1.5mm | 2.0-3.0mm | Needs support for thin walls |

### Size-Based Guidelines
```
Small masks (< 150mm): 1.5-2.5mm
Medium masks (150-250mm): 2.0-3.5mm
Large masks (> 250mm): 2.5-4.5mm

Rule of thumb: 1.5-2% of largest dimension
```

### Feature-Specific Thickness
```
Flat areas: Can use minimum thickness
Curved features: Add 0.5mm for stress distribution
Attachment points: Add 1-2mm reinforcement
Edges/rims: Consider 1.5-2x normal thickness
```

---

## Registration Features {#registration-features}

### Types of Registration

#### 1. Cylindrical Pins (Easiest)
**Pros:** Simple to create, universal fit  
**Cons:** Can rotate if not positioned well  
**Best for:** Quick prototypes, simple splits

**Design specs:**
- Diameter: 5-8mm
- Length: 10-15mm (5-7mm per side)
- Clearance: 0.1-0.2mm per side (0.2-0.4mm total)
- Quantity: 3-4 pins minimum

**Spacing rules:**
- Spread around perimeter
- Avoid clustering
- Place near stress points

#### 2. Keyed/Shaped Pins (Better)
**Pros:** Prevents rotation, self-aligning  
**Cons:** More complex to design  
**Best for:** Final products, critical alignment

**Examples:**
- Rectangular cross-section
- D-shaped pins
- Star or cross patterns
- Custom shaped profiles

#### 3. Dovetail Joints (Advanced)
**Pros:** No adhesive needed, mechanical lock  
**Cons:** Difficult to print, requires precise tolerances  
**Best for:** Functional assemblies, display pieces

**Critical parameters:**
- Draft angle: 5-10°
- Clearance: 0.15-0.25mm
- Sliding distance: 10-30mm

#### 4. Magnetic Alignment (Premium)
**Pros:** Easy assembly, reusable  
**Cons:** Requires embedded magnets  
**Best for:** Cosplay, museum displays

**Implementation:**
- Create 10-12mm diameter cavities
- Embed 8-10mm neodymium magnets
- Use 3-4 pairs for alignment
- Secure with epoxy

### Tolerance Calculator

```
General formula:
Clearance = Printer_tolerance + Safety_margin

FDM printers:
- Good calibration: 0.1mm per side (0.2mm total)
- Average: 0.15mm per side (0.3mm total)  
- Loose calibration: 0.2mm per side (0.4mm total)

Resin printers:
- Well calibrated: 0.05mm per side (0.1mm total)
- Average: 0.075mm per side (0.15mm total)
- Loose: 0.1mm per side (0.2mm total)

ALWAYS test print a small sample first!
```

---

## Troubleshooting {#troubleshooting}

### Blender Issues

#### Problem: Solidify creates overlapping geometry
**Symptoms:** Self-intersecting surfaces, weird bumps  
**Solutions:**
1. Reduce Thickness value
2. Switch to "Complex" mode
3. Enable "Even Thickness"
4. Manually edit problem areas in Edit Mode
5. Use Remesh modifier to clean up

#### Problem: Bisect tool doesn't cut cleanly
**Symptoms:** Missing faces, incomplete split  
**Solutions:**
1. Ensure all geometry selected before bisecting
2. Enable "Fill" option in Bisect settings
3. Check for duplicate vertices (Merge by Distance)
4. Verify normals are consistent

#### Problem: Exported STL has errors
**Symptoms:** Slicer reports non-manifold  
**Solutions:**
1. Use 3D Print Toolbox addon
2. Mesh → Clean Up → Merge by Distance
3. Check for:
   - Loose vertices (Select → All by Trait → Loose Geometry)
   - Internal faces
   - Flipped normals

#### Problem: File size too large
**Symptoms:** >100MB STL files  
**Solutions:**
1. Reduce Remesh voxel size
2. Use Decimate modifier (careful with details)
3. Reduce Solidify edge resolution
4. Export with lower polygon count

### OpenSCAD Issues

#### Problem: Rendering takes forever
**Symptoms:** Hours of rendering, no progress  
**Solutions:**
1. Reduce $fn to 16-20 for testing
2. Decimate STL in Blender first
3. Use smaller minkowski sphere radius
4. Break into smaller operations
5. Upgrade RAM if possible

#### Problem: Minkowski creates odd bumps
**Symptoms:** Surface not smooth  
**Solutions:**
1. Increase sphere $fn value
2. Check original STL for issues
3. Reduce sphere radius
4. Pre-process STL (remesh in Blender)

#### Problem: Boolean operations fail
**Symptoms:** Warning messages, missing geometry  
**Solutions:**
1. Add convexity parameter (increase to 20-30)
2. Slightly offset objects (by 0.001mm)
3. Increase $fn values
4. Check for overlapping faces in STL

#### Problem: Pins don't fit
**Symptoms:** Too tight or too loose  
**Solutions:**
1. Adjust pin_clearance parameter
2. Test print just pins first
3. Account for printer tolerance
4. Scale pins independently if needed

### General 3D Printing Issues

#### Problem: Warping during print
**Solutions:**
- Increase wall thickness for rigidity
- Add brim or raft
- Reduce print temperature
- Improve bed adhesion
- Print with supports touching build plate

#### Problem: Poor surface finish
**Solutions:**
- Increase layer height
- Adjust print speed
- Fine-tune retraction settings
- Post-process with sanding/filler
- Use higher quality print profile

#### Problem: Halves don't align
**Solutions:**
- Test fit before gluing
- Add more pins (4-5 minimum)
- Increase pin clearance slightly
- Check for warping/shrinkage
- Use clamps during glue-up

---

## Workflow Comparison

### When to Use Blender
✓ Visual workflow preferred  
✓ Complex organic shapes  
✓ Need to see results immediately  
✓ Detailed manual control required  
✓ One-off custom models  
✓ Integration with sculpting/texturing  

### When to Use OpenSCAD
✓ Parametric design needed  
✓ Multiple iterations planned  
✓ Batch processing many models  
✓ Version control required  
✓ Precise mathematical control  
✓ Reproducible workflow important  
✓ Comfortable with coding  

### Hybrid Workflow (Recommended for Complex Projects)
1. Sculpt/refine in Blender
2. Export clean STL
3. Process in OpenSCAD for hollowing
4. Import back to Blender for split/pins
5. Export final STLs

---

## Next Steps

After completing this tutorial:

1. **Test Print:** Always print a small section first
2. **Tolerance Testing:** Print pin test pieces before full mask
3. **Post-Processing:**
   - Sanding seams
   - Gap filling
   - Painting preparation
4. **Assembly:**
   - Dry fit before gluing
   - Use appropriate adhesive (CA glue, epoxy, plastic cement)
   - Clamp or rubber band while curing
5. **Finishing:**
   - Primer/filler
   - Sand smooth
   - Paint and detail

---

## Additional Resources

### Recommended Addons (Blender)
- 3D Print Toolbox (built-in)
- Mesh Healing Tools
- Bool Tool

### Useful Software
- Meshmixer (free) - mesh repair
- Microsoft 3D Builder (free) - simple splits
- Fusion 360 (free for hobbyists) - parametric design

### Learning Resources
- Blender Docs: https://docs.blender.org
- OpenSCAD Docs: https://openscad.org/documentation.html
- 3D Printing Discord communities
- r/3Dprinting on Reddit

---

## Conclusion

Both Blender and OpenSCAD are excellent tools for this workflow. Choose based on your comfort level and project requirements. For your specific head model:

- **Blender:** Best for visual control and one-off custom mask
- **OpenSCAD:** Best if you plan to create variations or multiple sizes

The registration features are critical - don't skip them! Proper alignment makes assembly infinitely easier.

Good luck with your mask project!

---

**Document Version:** 1.0  
**Last Updated:** December 15, 2025  
**Contact:** Available for questions and troubleshooting
