#include <iostream>
#include <algorithm>
#include <string>
#include <sstream>
#include <vector>

using namespace std;

int main() {
  string str;
  while (getline(cin, str) && str != "") {
    cout << str << endl;
    stringstream ss(str);
    vector<int> pks;
    while (true) {
      int pk;
      ss >> pk;
      if (!ss) {
        break;
      }
      pks.push_back(pk);
    }

    vector<int> ops;
    for (int i = pks.size() - 1; i >= 1; i--) {
      int currMaxValIndex = i;
      for (int j = i - 1; j >= 0; j--) {
        if (pks[j] > pks[currMaxValIndex]) {
          currMaxValIndex = j;
        }
      }
      if (currMaxValIndex != i) {
        if (currMaxValIndex != 0) {
          reverse(pks.begin(), pks.begin() + currMaxValIndex + 1);
          ops.push_back(pks.size() - currMaxValIndex);
        }
        reverse(pks.begin(), pks.begin() + i + 1);
        ops.push_back(pks.size() - i);
      }
    }
    
    for (auto op : ops) {
      cout << op << " ";
    }
    cout << 0 << endl;
  }
  return 0;
}
