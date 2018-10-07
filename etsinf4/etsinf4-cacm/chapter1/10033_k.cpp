#include <iostream>
#include <string>
#include <vector>

using namespace std;

#define MAX 1005

int main() {
  int n;
  cin >> n;
  cin.ignore();
  cin.ignore();
  while (n--) {
    vector<string> mem(MAX, "000");
    string inst;
    int pc = 0; 
    while (getline(cin, inst) && inst != "") {
      mem[pc++] = inst;
    }
    pc = 0;
    int count = 0;
    vector<int> reg(15, 0);
    bool halted = false;
    while (!halted) {
      int a = mem[pc][0] - '0';
      int b = mem[pc][1] - '0';
      int c = mem[pc][2] - '0';
      count++;
      pc++;
      switch(a) {
        case 1:
          halted = true;
          break;
        case 2:
          reg[b] = c;
          break;
        case 3:
          reg[b] += c;
          reg[b] %= 1000;
          break;
        case 4:
          reg[b] *= c;
          reg[b] %= 1000;
          break;
        case 5:
          reg[b] = reg[c];
          break;
        case 6:
          reg[b] += reg[c];
          reg[b] %= 1000;
          break;
        case 7:
          reg[b] *= reg[c];
          reg[b] %= 1000;
          break;
        case 8:
          reg[b] = stoi(mem[reg[c]]);
          break;
        case 9:
          char tmp[3];
          sprintf(tmp, "%03d", reg[b]);
          mem[reg[c]] = tmp;
          break;
        case 0:
          if (reg[c] != 0) {
            pc = reg[b];
          }
          break;
      }
    }
    cout << count << endl;
    if (n) {
      cout << endl;
    }
  }
  return 0;
}
