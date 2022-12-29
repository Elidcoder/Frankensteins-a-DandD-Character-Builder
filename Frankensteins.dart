List<dynamic> a = [];
String b = "ELI";
void main() {
  //List<int> b = [for (var x in a) a.indexOf(x)];
  if (!["ELI"].contains(b)) {
    print("$b not in [rli]");
  } else {
    print("$b in [ELI]");
  }
}
