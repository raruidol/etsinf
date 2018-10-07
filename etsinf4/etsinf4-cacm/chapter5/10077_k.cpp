#include <vector>
#include <iostream>

using namespace std;

typedef pair<double, double> frac;

int main() {
  double m, n;
  while (cin >> m >> n && (m != 1.0 || n != 1.0)) {
    frac left(0.0, 1.0);
    frac mid(1.0, 1.0);
    frac right(1.0, 0.0);
    while (mid.first != m || mid.second != n) {
      if (mid.first/mid.second > m / n) {
        cout << "L";
        right = mid;
        mid.first += left.first;
        mid.second += left.second;
      } else {
        cout << "R";
        left = mid;
        mid.first += right.first;
        mid.second += right.second;
      }
    }
    cout << endl;
  }
  return 0;
}
