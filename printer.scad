$fa=.01;
$fs=.01;

inches_per_mm = 0.0393701;

rail_and_block_height = 32 * inches_per_mm;
rail_height = 18.5 * inches_per_mm;
rail_width = 38 * inches_per_mm;

module extrusion1515(length, dimension, note="", model="1515") {
  if (dimension == "x") {
    cube([length, 1.5, 1.5]);
  } else if (dimension == "y") {
    cube([1.5, length, 1.5]);
  } else if (dimension == "z") {
    cube([1.5, 1.5, length]);
  }

  if (note != "") {
    echo(str(model, " Extrusion: ", length, " (", note, ")"));
  } else {
    echo(str(model, " 1515 Extrusion: ", length));
  }
}

module extrusion1504(length, dimension, note="") {
  color([119/255, 136/255, 153/255]) {
    extrusion1515(length, dimension, note, "1504");
  }
}

module print_head_beam(size) {
  extrusion1504(size, "x", "print head beam");
}

module build_plate(size, hole_offset) {
  echo(str("Build plate: ", size, "x", size));
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
      extrusion1504(x, "x", "bed frame x");
      translate([x / 2 - .75, 1.5, 0]) {
        extrusion1504(y - 1.5, "y", "bed frame y");
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
    r = (16 + 2) * inches_per_mm / 2; // 16mm diameter + 2mm buffer
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

module lead_screw(note="") {
  h = 500 * inches_per_mm; // 500mm high
  translate([0, 0, h / 2]) {
    r = 4 * inches_per_mm; // 8mm diameter
    cylinder(r=r, h=h, center=true);
    if (note != "") {
      echo(str("Lead screw (", note, ")"));
    } else {
      echo("Lead screw");
    }
  }
}

module frame(x, y, z, lead_screw_hole_offset, core_xy_z_offset) {
  // columns
  for (i=[[0, 0], [x - 1.5, 0]]) {
    translate([i[0], i[1], 0]) {
      extrusion1504(z, "z", "front column");
    }
  }

  for (i=[[x - 1.5, y - 1.5], [0, y - 1.5]]) {
    translate([i[0], i[1], 0]) {
      extrusion1515(z, "z", "rear column");
    }
  }

  // members at 3" and along the top

  translate([0, 1.5, 3]) {
    extrusion1504(y - 3, "y", "left, bottom y");
  }
  translate([1.5, 0, 3]) {
    extrusion1515(x - 3, "x", "front, bottom x");
  }
  translate([1.5, y - 1.5, 3]) {
    extrusion1515(x - 3, "x", "rear, bottom x");
  }
  translate([x - 1.5, 1.5, 3]) {
    extrusion1504(y - 3, "y", "right, bottom y");
  }
  translate([0, 1.5, z - 1.5]) {
    extrusion1515(y - 3, "y", "left, top y");
  }
  translate([1.5, 0, z - 1.5]) {
    extrusion1515(x - 3, "x", "front, top x");
  }
  translate([1.5, y - 1.5, z - 1.5]) {
    extrusion1515(x - 3, "x", "rear, top x");
  }
  translate([x - 1.5, 1.5, z - 1.5]) {
    extrusion1515(y - 3, "y", "right, top y");
  }

  // member for pulleys that drive Z-axis
  translate([1.5, y / 2 - .75, 3]) {
    extrusion1504(x - 3, "x", "bottom, for pulleys for z");
  }

  // members to mount CoreXY
  translate([0, 1.5, z - core_xy_z_offset]) {
    extrusion1504(y - 3, "y", "left corexy");
  }
  translate([x - 1.5, 1.5, z - core_xy_z_offset]) {
    extrusion1504(y - 3, "y", "right corexy");
  }
}

module stepper() {
  echo("Stepper");
  color([244/255, 206/255, 66/255]) {
    cube(size=[2.5, 2.5, 2.5]);
  }
}

module rail(length, rotation, note="") {
  // http://www.lm76.com/speed_guide.htm - size 15N
  rotate(rotation) {
    color([89/255, 2/255, 221/255]) {
      cube(size=[rail_width, length, rail_height]);
    }
    if (note != "") {
      echo(str("Rail: ", length, " (", note, ")"));
    } else {
      echo(str("Rail: ", length));
    }
  }
}

build_plate_size = 12;
bed_frame_x = 20; // make wider if print head can't print edge to edge
bed_frame_y = 14.5;
build_plate_screw_offset = 0.5;
lead_screw_hole_offset = 0.75;
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

// Rails

z_rail_length = frame_z - 3 - core_xy_z_offset - 1.5 - .5;

translate([0, 1.5 + rail_height, 4.75]) {
  rail(z_rail_length, [90, 0, 0], "vertical");
}

translate([frame_x - rail_width, 1.5 + rail_height, 4.75]) {
  rail(z_rail_length, [90, 0, 0], "vertical");
}

y_rail_offset = frame_z - core_xy_z_offset + 1.5;
y_rail_length =  frame_y - 3.5;

translate([1.5, 1.5 + .25, y_rail_offset]) {
  rail(y_rail_length, [0, 90, 0], "corexy y");
}

translate([frame_x - 1.5 - rail_height, 1.5 + .25, y_rail_offset]) {
  rail(y_rail_length, [0, 90, 0], "corexy y");
}

// print head beam and rail

translate([1.5 + rail_and_block_height, (frame_y - 1.5) / 2 , frame_z - core_xy_z_offset]) {
  print_head_beam_length = frame_x - 2 * rail_and_block_height - 3;
  print_head_beam(print_head_beam_length);
  translate([0, 0, 1.5]) {
    rotate([90, 0, 0]) {
      #rail(print_head_beam_length - .5, [0, 0, -90], "corexy x");
    }
  }
}

// TODO:
// bed frame needs to be wider to accommodate block - will extend beyond columns on both sides
// add blocks
