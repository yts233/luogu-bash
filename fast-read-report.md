# C++ 数据读取测试

## 准备

n=100000000

由 `1.py` 生成输入文件

```python
import random
import math
n=100000000
print(n)
for i in range(n):
	print(math.floor(random.random()*100000),end="\n")
```

由 `complie` 脚本编译

```bash
#!/usr/bin/env bash
time g++ 1.cpp -o a.out
```

由 `run` 脚本运行

```bash
#!/usr/bin/env bash
echo "
Running"
time ./a.out 0<./1.in 1>./1.out 2>./1.err
echo "
STDOUT:"
cat ./1.out
echo "

STDERR:"
cat ./1.err
echo
```

由于系统采用 Ubuntu 22.04 LTS Live CD，编译器、输入和代码均在内存中，所以不会有磁盘输入读取瓶颈

## Cin and sync_with_stdio(true)

代码:

```cpp
#include<iostream>
using namespace std;

int main(){
	int n;
	cin>>n;
	int ans=0;
	for(int i=0;i<n;i++){
		int x;
		cin>>x;
		ans^=x;
	}
	printf("%d",ans);
	return 0;
}
```

结果:

```
real	0m31.973s
user	0m31.047s
sys	0m0.284s

STDOUT:
128019

STDERR:

```

## Cin and sync_with_stdio(false)

代码:

```cpp
#include<iostream>
using namespace std;

int main(){
	ios::sync_with_stdio(false);
	int n;
	cin>>n;
	int ans=0;
	for(int i=0;i<n;i++){
		int x;
		cin>>x;
		ans^=x;
	}
	cout<<ans;
	return 0;
}
```

结果:

```
real	0m9.690s
user	0m9.506s
sys	0m0.156s

STDOUT:
128019

STDERR:

```

## Scanf

代码:

```cpp
#include<iostream>
using namespace std;

int main(){
	int n;
	scanf("%d",&n);
	int ans=0;
	for(int i=0;i<n;i++){
		int x;
		scanf("%d",&x);
		ans^=x;
	}
	printf("%d",ans);
	return 0;
}
```

结果:

```cpp
real	0m10.422s
user	0m10.083s
sys	0m0.232s

STDOUT:
128019

STDERR:

```

居然比 `Cin and sync_with_stdio(false)` 还要慢

## getchar()

代码:

```cpp
#include<iostream>
#include<cctype>
using namespace std;

inline int read(){
	int c,ret=0;
	while(!isdigit(c=getchar()));
	do{
		ret=(ret<<3)+(ret<<1)+c-'0';
	}while(isdigit(c=getchar()));
	return ret;
}

int main(){
	int n=read();
	int ans=0;
	for(int i=0;i<n;i++){
		ans^=read();
	}
	printf("%d",ans);
	return 0;
}
```

结果:

```cpp
real	0m4.402s
user	0m4.241s
sys	0m0.144s

STDOUT:
128019

STDERR:

```

## fread()

代码:

```cpp
#include<iostream>
#include<cctype>
using namespace std;

char*buffer,*currentPositionOfBuffer,*endOfBuffer;

inline void init(){
	const size_t bufferSize=700000000;
	if(buffer==nullptr)
		buffer=new char[bufferSize];
	currentPositionOfBuffer=buffer;
	endOfBuffer=buffer+fread(buffer,bufferSize,1,stdin);
}

inline char getchar1(){
	if(currentPositionOfBuffer==endOfBuffer)
		init();
	return *(currentPositionOfBuffer++);
}

inline int read(){
	int c,ret=0;
	while(!isdigit(c=getchar1()));
	do{
		ret=(ret<<3)+(ret<<1)+c-'0';
	}while(isdigit(c=getchar1()));
	return ret;
}

int main(){
	int n=read();
	int ans=0;
	for(int i=0;i<n;i++){
		ans^=read();
	}
	printf("%d",ans);
	return 0;
}
```

结果:

```cpp
real	0m3.314s
user	0m2.932s
sys	0m0.356s

STDOUT:
128019

STDERR:

```

