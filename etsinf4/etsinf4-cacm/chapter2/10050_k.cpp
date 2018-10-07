#include <iostream>
#include <vector>

using namespace std;

int main() {
  int T;
  cin >> T;
  while(T--) {
    int N;
    int P;
    int nStrikes = 0;
    cin >> N >> P;
    vector<bool> strikes(N + 1);
    for (int i = 0; i < P; i++) {
      int param;
      cin >> param;
      for (int j = 1; j <= N; j++) {
        int day = j % 7;
        if (day != 6 && day != 0) {
          if (j % param == 0 && !strikes[j]) {
            nStrikes++;
            strikes[j] = true;
          }
        }
      }
    }
    cout << nStrikes << endl;
  }
  return 0;
}
