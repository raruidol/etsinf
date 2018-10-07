#include <iostream>
#include <vector>

using namespace std;

int main() {
  int c;
  cin >> c;
  while (c--) {
    int n, m;
    cin >> n >> m;
    vector<vector<char> > matrix(n + 55, vector<char>(m + 55));
    for (int i = 1; i <= n; i++) {
      for (int j = 1; j <= m; j++) {
        char chr;
        cin >> chr;
        matrix[i][j] = tolower(chr);
      }
    }
    int k;
    cin >> k;
    while (k--) {
      string target;
      cin >> target;
      for (int i = 0; i < target.size(); i++) {
        target[i] = tolower(target[i]);
      }
      bool found = false;
      for (int i = 1; i <= n && !found; i++) {
        for (int j = 1; j <= m && !found; j++) {
          if (matrix[i][j] == target[0]) {
            int len = target.size();
            int rightHorizontalMatches = 1;
            int leftHorizontalMatches = 1;
            int downVerticalMatches = 1;
            int upVerticalMathches = 1;
            int leftUpDiagonalMatches = 1;
            int leftDownDiagonalMatches = 1;
            int rightDownDiagonalMatches = 1;
            int rightUpDiagonalMatches = 1;
            for (int k = 1; k < len; k++) {
              if (i - k >= 0 && matrix[i - k][j + k] == target[k]) {
                rightUpDiagonalMatches++;
              }
              if (j - k >= 0  && matrix[i + k][j - k] == target[k]) {
                leftDownDiagonalMatches++;
              }
              if (matrix[i][j + k] == target[k]) {
                rightHorizontalMatches++;
              }
              if (j - k >= 0 && matrix[i][j - k] == target[k]) {
                leftHorizontalMatches++;
              }
              if (i - k >= 0 && matrix[i - k][j] == target[k]) {
                upVerticalMathches++;
              
              }
              if (matrix[i + k][j] == target[k]) {
                downVerticalMatches++;
              }
              if (matrix[i + k][j + k] == target[k]) {
                rightDownDiagonalMatches++;
              }
              if (i - k >= 0 && j - k >= 0  && matrix[i - k][j - k] == target[k]) {
                leftUpDiagonalMatches++;
              }
            }
            if (rightUpDiagonalMatches == len || leftDownDiagonalMatches == len || upVerticalMathches == len || leftUpDiagonalMatches == len || leftHorizontalMatches == len || rightHorizontalMatches == len || downVerticalMatches == len || rightDownDiagonalMatches == len) {
              found = true;
              cout << i << " " << j << endl;
            }
          }
        }
      }
    }
    if (c) {
      cout << endl;
    }
  }
  return 0;
}
