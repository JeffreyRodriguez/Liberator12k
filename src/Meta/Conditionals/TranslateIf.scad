module TranslateIf(test=true, xyz=[0,0,0]) {
  if (test) {
    translate(xyz) children();
  } else {
    children();
  }
}
