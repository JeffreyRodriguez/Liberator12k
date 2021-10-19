module RenderIf(test=true, convexity=undef) {
  if (test) {
    render(convexity) children();
  } else {
    children();
  }
}
