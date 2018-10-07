#include <cstdio>
#include <cmath>

#define MAX 1005

int main() {
  int n;
  double students[MAX];
  while (scanf("%d", &n) == 1 && n != 0) {
    double sum = 0.0;
    for (int i = 0; i < n; i++) {
      double tmp;
      scanf("%lf", &tmp);
      students[i] = tmp;
      sum += students[i];
    }
    double avg = sum / n;
    double exchange = 0.0;
    double neg_exchange = 0.0;
    for (int i = 0; i < n; i++) {
      if (students[i] > avg) {
        exchange += floorf((students[i] - avg) * 100) / 100;
      } else {
        neg_exchange += floorf((avg - students[i]) * 100) / 100;
      }
    }
    printf("$%.2f\n", exchange < neg_exchange ? neg_exchange : exchange);
  }
  return 0;
}
