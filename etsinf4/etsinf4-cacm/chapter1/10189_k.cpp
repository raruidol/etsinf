#include <iostream>
#include <vector>

using namespace std;

int main() {
  unsigned row, column, nextRow, nextColumn, i, j;
  unsigned n = 1;
  cin >> nextRow >> nextColumn;
  do {
    row = nextRow;
    column = nextColumn;
    char A[150][150];
    unsigned B[150][150] = {0};
    for (i = 1; i <= row; ++i) {
      for (j = 1; j <= column; ++j) {
        cin >> A[i][j];
      }
    }
    for (i = 1; i <= row; ++i) {
      for (j = 1; j <= column; ++j) {
        if (A[i][j] == '*') {
          B[i][j+1]++;
          B[i+1][j+1]++;
          B[i+1][j]++;
          B[i+1][j-1]++;
          B[i][j-1]++;
          B[i-1][j-1]++;
          B[i-1][j]++;
          B[i-1][j+1]++;
        }
      }
    }
    cout << "Field #" << n++ << ":" << endl;
    for (i = 1; i <= row; ++i) {
      for (j = 1; j <= column; ++j) {
        if (A[i][j] == '*') {
          cout << A[i][j];
        } else {
          cout << B[i][j];
        }
      }
      cout << endl;
    }
    cin >> nextRow >> nextColumn;
    if (nextRow != 0  && nextColumn != 0) {
      cout << endl;
    }
  } while (nextRow != 0 && nextColumn != 0); 
  return 0;
}
