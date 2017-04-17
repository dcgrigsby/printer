$fa=.01;
$fs=.01;

module print_head_beam(size) {
  cube(size=[size, 1.5, 1.5]);
}

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

module bed_frame(x, y, build_plate_size, build_plate_screw_offset, lead_screw_hole_offset) {
  difference() {
    union() {
      // frame body
      color([119/255, 136/255, 153/255]) {
        cube(size=[x, 1.5, 1.5]);
        translate([x / 2 - .75, 0, 0]) {
          cube(size=[1.5, y, 1.5]);
        }
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
    translate([lead_screw_hole_offset, .75, -1]) {
      cylinder(r=r, h=10, center=true);
    }
    translate([x - lead_screw_hole_offset, .75, -1]) {
      cylinder(r=r, h=10, center=true);
    }
    translate([x / 2, y - lead_screw_hole_offset, -1]) {
      cylinder(r=r, h=10, center=true);
    }
  }
}

module lead_screw() {
  h = 500 * 0.0393701; // 500mm high
  translate([0, 0, h / 2]) {
    r = 4 * 0.0393701; // 8mm diameter
    cylinder(r=r, h=h, center=true);
  }
}

module frame(x, y, z, lead_screw_hole_offset, core_xy_z_offset) {
  // columns
  for (i=[[0, 0], [x - 1.5, 0]]) {
    translate([i[0], i[1], 0]) {
      color([119/255, 136/255, 153/255]) {
        cube(size=[1.5, 1.5, z]);
      }
    }
  }

  for (i=[[x - 1.5, y - 1.5], [0, y - 1.5]]) {
    translate([i[0], i[1], 0]) {
      cube(size=[1.5, 1.5, z]);
    }
  }

  // members at 3" and along the top

  translate([0, 0, 3]) {
    color([119/255, 136/255, 153/255]) {
      cube(size=[1.5, y, 1.5]);
    }
    cube(size=[x, 1.5, 1.5]);
  }
  translate([0, y - 1.5, 3]) {
    cube(size=[x, 1.5, 1.5]);
  }
  translate([x - 1.5, 0, 3]) {
    color([119/255, 136/255, 153/255]) {
      cube(size=[1.5, y, 1.5]);
    }
  }

  translate([0, 0, z - 1.5]) {
    cube(size=[1.5, y, 1.5]);
    cube(size=[x, 1.5, 1.5]);
  }
  translate([0, y - 1.5, z - 1.5]) {
    cube(size=[x, 1.5, 1.5]);
  }
  translate([x - 1.5, 0, z - 1.5]) {
    cube(size=[1.5, y, 1.5]);
  }

  // member for pulleys that drive Z-axis
  translate([0, y /2 - .75, 3]) {
    color([119/255, 136/255, 153/255]) {
      cube(size=[x, 1.5, 1.5]);
    }
  }

  // members to mount CoreXY
  union() {
    color([119/255, 136/255, 153/255]) {
      translate([0, 0, z - core_xy_z_offset]) {
        difference() {
          cube(size=[1.5, y, 1.5]);
          /* I /think/ these won't be necessary */
          /*translate([.75, lead_screw_hole_offset, 1.5 / 2 -.01]) {
            cylinder(r=16 * 0.0393701 / 2, h=1.6, center=true);
          }*/
        }
      }
      translate([x - 1.5, 0, z - core_xy_z_offset]) {
        difference() {
          cube(size=[1.5, y, 1.5]);
          /*translate([.75, lead_screw_hole_offset, 1.5 / 2 -.01]) {
            cylinder(r=16 * 0.0393701 / 2, h=1.6, center=true);
          }*/
        }
      }
    }
  }
}

module stepper() {
  color([244/255, 206/255, 66/255]) {
    cube(size=[2.5, 2.5, 2.5]);
  }
}

build_plate_size = 12;
bed_frame_x = 20; // make wider if print head can't print edge to edge
bed_frame_y = 14.5;
build_plate_screw_offset = 0.5;
lead_screw_hole_offset = 0.75;
rail_and_block_height = 1.25984; // http://www.lm76.com/speed_guide.htm
core_xy_z_offset = 8;

frame_x = bed_frame_x;
frame_y = 1.5 + rail_and_block_height + bed_frame_y;
frame_z = 30;

frame(bed_frame_x, frame_y, frame_z, 1.5 + .75 + rail_and_block_height, core_xy_z_offset);

translate([0, 1.5 + rail_and_block_height, 5.5]) {
  bed_frame(bed_frame_x, bed_frame_y, build_plate_size, build_plate_screw_offset, lead_screw_hole_offset);

  translate([(bed_frame_x - build_plate_size) / 2, .5, 2.5]) {
    color([255/255, 0/255, 0/255]) {
      build_plate(build_plate_size, 0.5);
    }
  }
}

translate([1.5 + rail_and_block_height, (frame_y - 1.5) / 2 , frame_z - core_xy_z_offset]) {
  color([119/255, 136/255, 153/255]) {
    print_head_beam(frame_x - 2 * rail_and_block_height - 3);
  }
}


color([0/255, 191/255, 255/255]) {
  translate([.75, 1.5 + .75 + rail_and_block_height, 2]) {
    lead_screw();
  }
  translate([bed_frame_x - .75,  1.5 + .75 + rail_and_block_height, 2]) {
    lead_screw();
  }
  translate([bed_frame_x / 2, frame_y - .75, 2]) {
    lead_screw();
  }
}


// CoreXY steppers

translate([1.5, frame_y - 2.5, frame_z - core_xy_z_offset + 1.5]) {
  stepper();
}

translate([frame_x - 2.5 - 1.5, frame_y - 2.5, frame_z - core_xy_z_offset + 1.5]) {
  stepper();
}

// Bed stepper
translate([frame_x / 4, frame_y - 1.5 - 2.5, 3]) {
  stepper();
}


// HEIGHT OF PRINT HEAD / HEIGHT OF FRAME / HOLES IN PRINT HEAD RAIL
// RAILS AND BLOCKS
// PRINT HEAD RAILS/BLOCKS, BEAM
// COREXY pulleys
