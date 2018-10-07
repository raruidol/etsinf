#include <iostream>

using namespace std;

int maxCount(int n1, int n2) {
  int max = 0;
  int count;
  int temp;
  if (n1 > n2) {
    temp = n1;
    n1 = n2;
    n2 = temp;
  }
  for (; n1 <= n2; n1++) {
    int a = n1;
    count = 1;
    while (a != 1) {
      if (a % 2 != 0) {
        a = a * 3 + 1;
        count++;
      } else {
        a = a / 2;
        count++;
      }
    }
    if (count > max) max = count;
  }
  return max;
}

int main() {
  int a, b;
  while (cin >> a >> b) {
    cout << a << " " << b << " " << maxCount(a, b) << endl;
  }
}
