module RenderIf(test=true) {
  if (test) {
    render() children();
  } else {
    children();
  }
}
