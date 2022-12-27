List<String> a = ["a", "b", "c"];
List<int> d = [1, 2, 3, 4];
void checker(List<int> an) {
  an[0]++;
}

void main() {
  List<int> b = [for (var x in a) a.indexOf(x)];
  print("eli");
  checker(b);
  print(b);
  print(d.reduce((value, element) => value + element));
}
