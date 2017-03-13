$fa=.01;
$fs=.01;

module build_plate(size, hole_offset) {
  difference() {
    cube(size=[size, size, .25]);
    translate([hole_offset, hole_offset, -1]) {
      cylinder(r=.25, h=10, center=true);
    }
    translate([size - hole_offset, hole_offset, -1]) {
      cylinder(r=.25, h=10, center=true);
    }
    translate([size / 2, size - hole_offset, -1]) {
      cylinder(r=.25, h=10, center=true);
    }
  }
}

module bed_frame(x, y, build_plate_size, build_plate_screw_offset, x_lead_screw_hole_offset, y_lead_screw_hole_offset) {
  difference() {
    union() {
      // frame body
      cube(size=[x, 1.5, 1.5]);
      translate([x / 2 - .75, 0, 0]) {
        cube(size=[1.5, y, 1.5]);
      }
      // screws for leveling
      color([0/255, 255/255, 0/255]) {
        translate([0, 0, 2.75 / 2]) {
          // x
          r = .15;
          translate([x / 2 - build_plate_size / 2 + build_plate_screw_offset, 1.5 - build_plate_screw_offset, 0]) {
            cylinder(r=r, h=2.75, center=true);
          }
          translate([x / 2 + build_plate_size / 2 - build_plate_screw_offset, 1.5 - build_plate_screw_offset, 0]) {
            cylinder(r=r, h=2.75, center=true);
          }
          // y
          translate([x / 2, build_plate_size - build_plate_screw_offset + .5, 0]) {
            cylinder(r=r, h=2.75, center=true);
          }
        }
      }
    }
    r = 12 * 0.0393701 / 2; // 12mm diameter
    translate([x_lead_screw_hole_offset, .75, -1]) {
      cylinder(r=r, h=10, center=true);
    }
    translate([x - x_lead_screw_hole_offset, .75, -1]) {
      cylinder(r=r, h=10, center=true);
    }
    translate([x / 2, y - y_lead_screw_hole_offset, -1]) {
      cylinder(r=r, h=10, center=true);
    }
  }
}

module lead_screw() {
  translate([0, 0, 1]) {
    cube(size=[3, 3, .25]);
  }
  h = 500 * 0.0393701; // 500mm high
  translate([1.5, 2, h / 2]) {
    r = 4 * 0.0393701; // 8mm diameter
    cylinder(r=r, h=h, center=true);
  }
}

module frame(x, y, z) {
  // columns
  for (i=[[0, 0], [x - 1.5, y - 1.5], [0, y - 1.5], [x - 1.5, 0]]) {
    translate([i[0], i[1], 0]) {
      cube(size=[1.5, 1.5, z]);
    }
  }

  // members at 3" and along the top
  for (i=[3, z - 1.5]) {
    translate([0, 0, i]) {
      cube(size=[1.5, y, 1.5]);
      cube(size=[x, 1.5, 1.5]);
    }
    translate([0, y - 1.5, i]) {
      cube(size=[x, 1.5, 1.5]);
    }
    translate([x - 1.5, 0, i]) {
      cube(size=[1.5, y, 1.5]);
    }
  }

  // member for pulleys that drive Z-axis
  translate([0, y /2 - .75, 3]) {
    cube(size=[x, 1.5, 1.5]);
  }

  // members to mount CoreXY
  core_xy_z_offset = 5;
  translate([0, 0, z - core_xy_z_offset]) {
    cube(size=[1.5, y, 1.5]);
  }
  translate([x - 1.5, 0, z - core_xy_z_offset]) {
    cube(size=[1.5, y, 1.5]);
  }
}

build_plate_size = 12;
bed_frame_x = 20; // make wider if print head can't print edge to edge
bed_frame_y = 14.5;
build_plate_screw_offset = 0.5;
y_lead_screw_hole_offset = 0.75;
x_lead_screw_hole_offset = 2;
rail_and_block_height = 1.73228;

frame_y = 1.5 + rail_and_block_height + bed_frame_y + 1.25;
//        ^bar                                        ^ room for lead screw

frame(bed_frame_x, frame_y, 26);

translate([0, 1.5, 3.5]) {

  // room for the rails and blocks
  translate([0, rail_and_block_height, 2]) {
    translate([(bed_frame_x - build_plate_size) / 2, .5, 2.5]) {
      color([255/255, 0/255, 0/255]) {
        build_plate(build_plate_size, 0.5);
      }
    }
    bed_frame(bed_frame_x, bed_frame_y, build_plate_size, build_plate_screw_offset, x_lead_screw_hole_offset, y_lead_screw_hole_offset);
  }

  color([0/255, 191/255, 255/255]) {
    translate([0, 4, 0]) {
      rotate([0, 0, -90]) {
        lead_screw();
      }
    }
    translate([bed_frame_x,  1, 0]) {
      rotate([0, 0, 90]) {
        lead_screw();
      }
    }
    translate([bed_frame_x / 2 + 1.5, frame_y - 1.5, 0]) {
      rotate([0, 0, 180]) {
        lead_screw();
      }
    }
  }
}


// NEXT:
// BOTTOM BAR FOR PULLEYS
// RAILS AND BLOCKS
// PRINT HEAD RAILS/BLOCKS, BEAM
