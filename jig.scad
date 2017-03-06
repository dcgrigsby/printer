$fa=.1;
$fs=.1;
extrusion_dimension = 38.1;

base = (2.8 - 1.5) * 25.4;

bolt_radius = 6.35 / 2;

difference() {
  union() {
    cube([extrusion_dimension * 3, extrusion_dimension * 3, base]);
    translate([extrusion_dimension * .75, 0, base]) {
      cube([extrusion_dimension * 1.5, extrusion_dimension * 3, extrusion_dimension * 1]);
    }
  }
  translate([extrusion_dimension, -10, base]) {
    /* endstop version */
    /*cube([extrusion_dimension, extrusion_dimension * 3, extrusion_dimension * 2]);*/
    /* alignment version */
    cube([extrusion_dimension, extrusion_dimension * 4, extrusion_dimension * 2]);
  }
  translate([extrusion_dimension * .75 * .5, extrusion_dimension / 2, -10]) {
    cylinder(r=bolt_radius, h=extrusion_dimension * 5, center=true);
  }
  translate([extrusion_dimension * .75 * .5, extrusion_dimension * 3 - extrusion_dimension / 2, -10]) {
    cylinder(r=bolt_radius, h=extrusion_dimension * 5, center=true);
  }
  translate([extrusion_dimension * 3 - extrusion_dimension * .75 * .5, extrusion_dimension / 2, -10]) {
    cylinder(r=bolt_radius, h=extrusion_dimension * 5, center=true);
  }
  translate([extrusion_dimension * 3 - extrusion_dimension * .75 * .5, extrusion_dimension * 3 - extrusion_dimension / 2, -10]) {
    cylinder(r=bolt_radius, h=extrusion_dimension * 5, center=true);
  }
  translate([-.01, extrusion_dimension, -1]) {
    cube(size=[extrusion_dimension * .75, extrusion_dimension * 1, 100]);
  }
  translate([extrusion_dimension * 2.25, extrusion_dimension, -1]) {
    cube(size=[extrusion_dimension, extrusion_dimension, 100]);
  }
  translate([-0.001, -0.001, 10]) {
    cube(size=[extrusion_dimension * .75 + .001, extrusion_dimension * 100, 100]);
  }
  translate([extrusion_dimension * 2.25, -10, 10]) {
    cube(size=[extrusion_dimension, extrusion_dimension * 100, 1000]);
  }
  translate([extrusion_dimension, extrusion_dimension, -1]) {
    cube([extrusion_dimension, extrusion_dimension, 1000]);
  }
}
