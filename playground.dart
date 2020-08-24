void main() {
  int noOfBottles = 99;

  for (int i = noOfBottles; true; i--) {
    int temp = noOfBottles;
    print(
        '$noOfBottles bottles of beer on the wall, $noOfBottles bottles of beer.');
    print(
        'Take one and pass it around ${temp - 1} bottles of beer on the wall\n\n');
  }
}
