// Pi5 Dual IMX219 NDVI Case V1
// Units: mm

$fn = 48;

////////////////////
// Parameters
////////////////////
case_wall = 3;
base_len = 115;
base_w = 85;
base_h = 8;
corner_r = 6;

// Pi5 mounting (approx 58x49 hole pattern)
pi_hole_dx = 58;
pi_hole_dy = 49;
pi_hole_d = 2.8;      // M2.5 clearance
standoff_h = 6;
standoff_od = 6.5;

// Camera rig
camera_baseline = 40; // center-center distance
camera_board_w = 25;
camera_board_h = 24;
camera_hole_pitch_x = 21;
camera_hole_pitch_y = 12.5;
camera_hole_d = 2.2;      // M2 clearance
camera_insert_d = 3.4;   // M2 heat-set insert pocket (adjust for your insert)
camera_insert_h = 4.0;
camera_clamp_w = 32;
camera_clamp_t = 12;
camera_clamp_h = 32;
camera_pocket_depth = 4.2;
cam_bar_w = 18;
cam_bar_t = 6;
cam_bar_h = 36;
cam_rise = 34;        // rise above base

// Tripod mount
tripod_insert_d = 9.2;   // pocket for 1/4" brass insert
tripod_insert_h = 7;

// CSI cable guides
slot_w = 14;
slot_h = 3;

////////////////////
// Helpers
////////////////////
module rounded_rect_2d(l, w, r){
  hull(){
    for(x=[-l/2+r, l/2-r])
      for(y=[-w/2+r, w/2-r])
        translate([x,y]) circle(r=r);
  }
}

module base_plate(){
  difference(){
    linear_extrude(base_h)
      rounded_rect_2d(base_len, base_w, corner_r);

    // Pi mounting holes (centered)
    for (x=[-pi_hole_dx/2, pi_hole_dx/2])
      for (y=[-pi_hole_dy/2, pi_hole_dy/2])
        translate([x,y,-0.1]) cylinder(d=pi_hole_d, h=base_h+1);

    // tripod insert pocket (underside center)
    translate([0,0,-0.1]) cylinder(d=tripod_insert_d, h=tripod_insert_h);

    // CSI cable slots near camera bar
    for (x=[-camera_baseline/2, camera_baseline/2])
      translate([x, base_w/2-8, base_h/2])
        rotate([90,0,0])
          cube([slot_w, slot_h, 8], center=true);
  }

  // Pi standoffs
  for (x=[-pi_hole_dx/2, pi_hole_dx/2])
    for (y=[-pi_hole_dy/2, pi_hole_dy/2])
      translate([x,y,base_h])
        difference(){
          cylinder(d=standoff_od, h=standoff_h);
          translate([0,0,-0.1]) cylinder(d=pi_hole_d, h=standoff_h+0.2);
        }
}

module camera_bar(){
  // Main bar
  translate([0, base_w/2 - cam_bar_w/2 - 2, base_h + cam_rise])
    difference(){
      cube([camera_baseline + 40, cam_bar_w, cam_bar_t], center=true);
      // pass-through holes to bolt camera clamps
      for (x=[-camera_baseline/2, camera_baseline/2])
        translate([x,0,0]) rotate([90,0,0]) cylinder(d=3.2, h=cam_bar_w+1, center=true);
    }

  // Triangular gussets
  for (x=[-30,30])
    translate([x, base_w/2-12, base_h])
      linear_extrude(height=cam_rise+4)
        polygon([[0,0],[0,8],[8,0]]);
}

module camera_clamp(sign=1){
  xoff = sign * camera_baseline/2;
  translate([xoff, base_w/2 - cam_bar_w/2 - 2, base_h + cam_rise + cam_bar_t/2 + camera_board_h/2 + 2])
  difference(){
    // clamp body (front face is +Y)
    cube([camera_clamp_w, camera_clamp_t, camera_clamp_h], center=true);

    // front alignment pocket for IMX219 board (leaves solid back wall)
    translate([0, (camera_clamp_t - camera_pocket_depth)/2, 0])
      cube([camera_board_w + 0.6, camera_pocket_depth, camera_board_h + 0.6], center=true);

    // lens aperture window
    translate([0, (camera_clamp_t - camera_pocket_depth)/2, 0])
      cube([9, camera_pocket_depth + 0.2, 9], center=true);

    // camera mounting holes:
    // - front M2 clearance
    // - rear heat-set insert pockets (thread-in target)
    for(x=[-camera_hole_pitch_x/2, camera_hole_pitch_x/2])
      for(z=[-camera_hole_pitch_y/2, camera_hole_pitch_y/2]){
        // clearance from front toward middle
        translate([x, +1.5, z])
          rotate([90,0,0]) cylinder(d=camera_hole_d, h=9.0, center=true);
        // insert pocket near rear face
        translate([x, -4.0, z])
          rotate([90,0,0]) cylinder(d=camera_insert_d, h=camera_insert_h, center=true);
      }

    // through-bolt to camera bar (M3)
    translate([0,-4,0]) rotate([90,0,0]) cylinder(d=3.2, h=20, center=true);

    // CSI ribbon relief notch
    translate([0, +5.0, -camera_board_h/2 + 2.5])
      cube([12, 4.0, 4.0], center=true);
  }
}

////////////////////
// Layout for preview
////////////////////
base_plate();
camera_bar();
camera_clamp(-1);
camera_clamp(1);
