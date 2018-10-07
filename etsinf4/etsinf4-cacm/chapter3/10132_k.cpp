#include <vector>
#include <iostream>
#include <map>

using namespace std;

int main() {
  int k;
  cin >> k;
  cin.ignore();
  cin.ignore();
  while (k--) {
    string frag;
    vector<string> frags;
    int n = 0;
    int lenSum = 0;
    while (getline(cin, frag) && frag != "") {
      n++;
      lenSum += frag.size();
      frags.push_back(frag);
    }

    int len = lenSum / (n / 2);
    string pattern = "";
    int max = -1;
    map<string, int> counts;
    for (auto frag_1 : frags) {
      for (auto frag_2 : frags) {
        string piece = frag_1 + frag_2;
        if (piece.size() == len) {
          counts[piece]++;
          if (counts[piece] > max) {
            max = counts[piece];
            pattern = piece;
          }
        }
      }
    }
    cout << pattern << endl;
    if (k) {
      cout << endl;
    }
  }
}
