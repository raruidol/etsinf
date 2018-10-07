#include <iostream>
#include <vector>
#include <algorithm>
#include <sstream>

using namespace std;

bool pairSecondValueDescSort(pair<int, int> p1, pair<int, int> p2) {
  if (p1.second == p2.second) {
    return p1.first < p2.first;
  } else {
    return p1.second > p2.second;
  }
}

int main() {
  int k;
  cin >> k;
  while(k--) {
    int n;
    cin >> n;
    cin.ignore();
    vector<string> names;
    names.push_back("dummy");
    for (int i = 0; i < n; i++) {
      string name;
      getline(cin, name);
      names.push_back(name);
    }

    vector<vector<int> > ballots;
    string votes;
    while(getline(cin, votes) && votes != "") {
      ballots.push_back(vector<int>());
      stringstream ss(votes);
      while (true) {
        int n;
        ss >> n;
        if (!ss) {
          break;
        }
        ballots.back().push_back(n);
      }
    }

    vector<bool> removed(n + 1, false);
    while (true) {
      vector<int> sums(n + 1, 0);
      for (auto votes : ballots) {
        int i = 0;
        while (removed[votes[i]]) {
          i++;
        }
        sums[votes[i]]++;
      }
      vector<pair<int, int> > candidateIdAndSum;
      for (int i = 1; i < removed.size(); i++) {
        if (!removed[i]) {
          candidateIdAndSum.push_back(pair<int, int>(i, sums[i]));
        }
      }
      sort(candidateIdAndSum.begin(), candidateIdAndSum.end(), pairSecondValueDescSort);
      if (candidateIdAndSum.front().second > ballots.size() / 2) {
        cout << names[candidateIdAndSum.front().first] << endl;
        break;
      } else if (candidateIdAndSum.front().second  == candidateIdAndSum.back().second) {
        for (auto p : candidateIdAndSum) {
          cout << names[p.first] << endl;
        }
        break;
      } else {
        int minVal = candidateIdAndSum.back().second;
        for (auto p : candidateIdAndSum) {
          if (p.second <= minVal) {
            removed[p.first] = true;
          }
        }
      }
    }
    if (k) cout << endl;
  }
  return 0;
}
