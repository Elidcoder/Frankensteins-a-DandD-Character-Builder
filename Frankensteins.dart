void myFunc(List<dynamic> x) {
  x[1].add(x[0]);
}

main() {
  //List<int> b = [for (var x in a) a.indexOf(x)];
  List<List<dynamic>> a = [
    ["Name", []],
    ["Name1", []]
  ];
  for (var x = 0; x < a.length; x++) {
    myFunc(a[x]);
  }
  print(a);
}
