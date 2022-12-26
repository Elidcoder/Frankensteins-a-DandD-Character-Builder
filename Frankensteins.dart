List<String> a = ["a", "b", "c"];

void checker(List<int> an) {
  an[0]++;
}

void main() {
  List<int> b = [for (var x in a) a.indexOf(x)];
  print("eli");
  checker(b);
  print(b);
}
