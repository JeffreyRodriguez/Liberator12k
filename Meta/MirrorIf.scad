module MirrorIf(test=true, mirrorArray=[0,0,0]) {
  if (test) {
    mirror(mirrorArray) children();
  } else {
    children();
  }
}
