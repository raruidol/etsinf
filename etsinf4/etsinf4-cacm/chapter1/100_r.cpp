#include <iostream>

using namespace std;
int memo[1000000] = {0};

int alg3np1(int x)
{
    int count = 1;
    int k = x;
    while (x != 1){
        if (x % 2 == 0){
            x /= 2;
        }
        else{
            x = 3*x+1;
        }
        
        if(x<1000000 && memo[x] != 0) {
        	return memo[x]+count;
        }
        count++;
        }
    if(k<1000000){
        memo[k] = count;
    }
    return count;
}

int maxCycle(int i,  int j)
{
    int max = 0;
    if (i > j){
        int aux = i;
        i = j;
        j = aux;
    }
    for(int n = i; n<=j; n++) {
        int val = alg3np1(n);
        if (val > max) {
            max = val;
        }
    }
    return max;
}


int main()
{
    int a, b;
    while(cin >> a >> b){
        int res = maxCycle(a, b);
        cout << a << " " << b << " " << res << endl;
    }
}
