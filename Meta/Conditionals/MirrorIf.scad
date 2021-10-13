module MirrorIf(test=true, mirrorArray=[0,0,0], both=false) {
  if (test) {
    if (both) children();
   
    mirror(mirrorArray) children();
  } else {
    children();
  }
}
