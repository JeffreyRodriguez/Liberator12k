module HullIf(test=true) {
  if (test) {
    hull() children();
  } else {
    children();
  }
}

module MirrorIf(test=true, mirrorArray=[0,0,0], both=false) {
  if (test) {
    if (both) children();

    mirror(mirrorArray) children();
  } else {
    children();
  }
}

module RenderIf(test=true, convexity=undef) {
  if (test) {
    render(convexity) children();
  } else {
    children();
  }
}

module TranslateIf(test=true, xyz=[0,0,0]) {
  if (test) {
    translate(xyz) children();
  } else {
    children();
  }
}
