# 第一章：Introduction（课程介绍）详细笔记

---

## 一、C++ 简介

### 1.1 什么是C++
- C++是一种**静态类型、编译式、通用**的编程语言
- 支持**多范式编程**：过程式、面向对象、泛型编程
- 是C语言的超集，兼容C语言的大部分语法

### 1.2 C++的特点
- **高效性**：接近底层硬件，执行效率高
- **灵活性**：提供丰富的底层控制能力
- **可移植性**：标准跨平台支持
- **广泛应用**：系统软件、游戏开发、嵌入式等领域

---

## 二、推荐学习资源

### 2.1 教材推荐
| 书名 | 作者 | 特点 |
|------|------|------|
| 《The C++ Programming Language》(3rd edition) | Bjarne Stroustrup | C++之父经典著作 |
| 《C++ Primer Plus》(5th Edition) | Stephen Prata | 入门经典，讲解详细 |
| 《C++ Primer》(3rd Edition) | Stanley B. Lippman | 全面深入 |
| 《Thinking in C++》 | Bruce Eckel | 注重编程思想 |
| 《Essential C++》 | Stanley B. Lippman | 简洁精要 |
| 《Effective C++》 | Scott Meyers | 进阶必读 |
| 《More Effective C++》 | Scott Meyers | 进阶续篇 |

---

## 三、计算机系统基础

### 3.1 计算机系统层次结构

```
用户层
    ↓
应用程序层 (Java, Basic等)
    ↓
操作系统层 (Windows, Linux, UNIX)
    ↓
硬件层 (CPU, RAM/ROM, 外设)
```

### 3.2 CPU工作原理

#### 3.2.1 CPU主要组件
- **ALU** (算术逻辑单元)：执行算术和逻辑运算
- **寄存器** (Register)：高速临时存储
- **总线控制器** (BUS Controller)：数据传输控制
- **缓存** (Cache)：高速数据缓冲

#### 3.2.2 指令执行过程
```
高级语言代码:
a = (a+b)*c/d;

汇编代码:
mov  eax, dword ptr [a]
add  eax, dword ptr [b]
imul eax, dword ptr [c]
xor  edx, edx
div  eax, dword ptr [d]
mov  dword ptr [a], eax
```

#### 3.2.3 内存与CPU交互
- CPU通过**地址总线**和**数据总线**与内存通信
- 内存地址以字节为单位（如 3500, 3501...）
- 每条汇编指令对应特定的机器码（十六进制表示）

---

## 四、编程语言发展史

### 4.1 历史时间线

| 年份 | 事件 |
|------|------|
| 1834 | Babbage 提出分析机概念 |
| 1848 | Boole 创立布尔代数 |
| 1890 | Hollerith 发明制表机，1896年成立IBM |
| 1906 | 电子管发明 |
| 1937 | Turing 提出图灵机理论 |
| 1939 | Hewlett-Packard (HP) 成立 |
| 1946 | **ENIAC** - 第一台电子计算机（18K真空管，30吨，25KW，3000立方英尺） |
| 1949 | 第一台存储程序计算机 |
| 1952 | MIT 诞生第一台实时计算机 |
| 1954 | IBM 开始开发Fortran |
| 1957 | **Fortran** 正式发布 |
| 1958 | **Algol 60** 发布；Noyce创立Intel |
| 1960 | COBOL发布 |
| 1961 | CPL语言 |
| 1963 | BCPL语言（CPL的简化版） |
| 1965 | **BASIC** 语言诞生 |
| 1967 | **PASCAL** 语言（基于Algol） |
| 1970 | **B语言** 诞生 |
| 1971 | Intel 4004（第一款微处理器） |
| 1972 | **C语言** 在Bell Lab诞生，UNIX系统开发 |
| 1974 | Altair 8800（Intel 8080） |
| 1975 | Bill Gates创立Microsoft |
| 1979 | **Ada** 语言 |
| 1981 | IBM-PC发布，MS-DOS和BASIC |
| **1983** | **C++诞生**（Bjarne Stroustrup，Bell Lab） |
| 1983 | Borland公司成立（Pascal、C/C++ IDE） |
| 1985 | MS Windows 1.0发布 |
| 1989 | HTML/WWW诞生 |
| 1993 | Windows 3.1 |
| 1994 | Netscape 1.0 |
| 1995 | **Java** 发布（Sun/Netscape） |
| 2002 | Microsoft .NET (C#) |

### 4.2 编程语言家族树

```
                    Algol
                      │
        ┌─────────────┼─────────────┐
        │             │             │
      Pascal      Fortran       COBOL
        │             │             │
    ┌───┴───┐        │             │
    │       │        │             │
   Ada   Modula-2   PL/I         Prolog
    │       │        │             │
    │       │        │             │
    └───┬───┘        │         Common LISP
        │            │             │
     Simula          C++           │
        │            │             │
   Smalltalk      Java ────────────┘
        │            │
        └────────────┘
```

### 4.3 编程语言分类

#### 4.3.1 按执行方式分类
1. **编译型语言**：Fortran、Pascal、C、Ada
   - 源代码 → 编译器 → 机器码 → 执行
   - 执行效率高

2. **解释型语言**：BASIC、Java、.NET(C#/C++/Java)
   - 源代码 → 解释器/虚拟机 → 执行
   - 跨平台性好

#### 4.3.2 按编程范式分类
1. **过程式/结构化**：Fortran、BASIC、Algol、Pascal、C、Ada
   - 强调算法和步骤
   - 使用goto、顺序、选择、循环结构

2. **面向对象**：Smalltalk、C++、Java、C#
   - 强调数据和行为的封装
   - 支持继承、多态、封装

---

## 五、面向对象编程（OOP）简介

### 5.1 什么是面向对象编程
- **Object Oriented Programming**
- 核心思想：将数据和对数据的操作封装在一起
- 主要特点：
  - **封装** (Encapsulation)
  - **继承** (Inheritance)
  - **多态** (Polymorphism)

### 5.2 OOP的优势
- **代码复用** (Re-use)
- **模块化设计**
- **易于维护和扩展**

### 5.3 C++与面向对象
```
C++ = C + 面向对象特性
```
- 兼容C语言的过程式编程
- 增加类(class)、对象(object)机制
- 支持运算符重载、模板等高级特性

---

## 六、C/C++程序结构

### 6.1 源文件组织

#### 6.1.1 文件扩展名
| 扩展名 | 含义 |
|--------|------|
| `.h` | 头文件（Header） |
| `.c` | C源文件 |
| `.cpp` / `.cxx` / `.cc` | C++源文件 |
| `.res` / `.def` | Windows SDK相关文件 |

#### 6.1.2 头文件与源文件分离
```
MyString.h          MyString.c          MyProgram.c
(声明接口)          (实现接口)          (使用接口)
     │                  │                   │
     └──────────────────┴───────────────────┘
                         │
                    MyProgram.exe
```

**示例代码结构：**

**MyString.h**（头文件 - 声明）
```c
#define MAX_STR_LEN 256

typedef struct {
    int iSize;
    char StrBuf[MAX_STR_LEN];
} STRING;

void PrintfString(STRING str);
void CopyString(STRING str, char* src);
```

**MyString.c**（源文件 - 实现）
```c
#include <stdio.h>
#include "MyString.h"

void PrintfString(STRING str) {
    if (str.iSize > 0)
        printf("%s\n", str.StrBuf);
}

void CopyString(STRING str, char* src) {
    int i = 0;
    while (src[i] && i < MAX_STR_LEN - 1) {
        str.StrBuf[i] = src[i];
        str.StrBuf[i] = 0;
    }
}
```

**MyCount.h**（头文件）
```c
extern int iCnt;
int AddCount();
```

**MyCount.c**（源文件）
```c
#include "MyCount.h"

int iCnt;

int AddCount() {
    iCnt++;
    return iCnt;
}
```

**MyProgram.c**（主程序）
```c
#include "MyString.h"
#include "MyCount.h"

char* Number[] = {
    "one", "tow", "three", "four", "five",
    "six", "seven", "eight", "nine", "ten"
};

main() {
    STRING str;
    iCnt = 0;
    while (iCnt < 10) {
        CopyString(str, Number[iCnt]);
        PrintString(str);
        AddCount();
    }
}
```

### 6.2 编译过程

```
源代码(.c/.cpp)
      │
      ▼
  预处理(Preprocess)
      │  #include展开, #define替换
      ▼
  编译(Compile)
      │  语法检查, 生成汇编代码
      ▼
  汇编(Assemble)
      │  生成目标文件(.obj)
      ▼
  链接(Link)
      │  链接库文件(.lib)
      ▼
  可执行文件(.exe)
```

### 6.3 标准库与库文件

#### 6.3.1 C/C++标准库
- 提供I/O操作、操作系统接口等功能
- 例如：`printf()`函数在C标准库中实现

#### 6.3.2 库文件类型
| 类型 | 扩展名 | 说明 |
|------|--------|------|
| 静态库 | `.lib` (Windows) / `.a` (UNIX) | 编译时链接 |
| 动态库 | `.dll` (Windows) / `.so` (UNIX) | 运行时加载 |

---

## 七、开发环境

### 7.1 开发工具链

```
源代码编辑器(Editor)
        ↓
编译器(Compiler) - gcc, clang, MSVC
        ↓
链接器(Linker)
        ↓
调试器(Debugger) - GDB, Visual Studio Debugger
```

### 7.2 开发环境类型

#### 7.2.1 命令行环境（UNIX/Linux）
```
My Projects/
├── Project_1/
│   ├── include/    (头文件)
│   ├── src/        (源文件)
│   ├── bin/        (可执行文件)
│   ├── obj/        (目标文件)
│   └── config/     (配置文件)
├── Project_2/
└── ...
```

#### 7.2.2 集成开发环境（IDE）
- **Visual Studio** (Windows)
- **CLion** (跨平台)
- **Code::Blocks** (跨平台)
- **Dev-C++** (Windows)

#### 7.2.3 IDE项目结构（Visual Studio）
```
My Solution/
├── Project_1/
│   ├── Debug/      (调试版本输出)
│   ├── Release/    (发布版本输出)
│   ├── res/        (资源文件)
│   ├── SourceFile.cpp
│   └── HeaderFile.h
├── Project_2/
└── ...
```

### 7.3 版本控制系统
- **CVS** (Concurrent Versions System)
- **SourceSafe** (Microsoft)
- **Git** (现代主流)

---

## 八、代码规范

### 8.1 命名规范

#### 8.1.1 命名风格对比
| 风格 | 示例 | 用途 |
|------|------|------|
| 匈牙利命名法 | `iCnt`, `strBuf`, `pLogFile` | Windows/Microsoft风格 |
| 驼峰命名法 | `eventLogFlag`, `addCount` | Java/JavaScript常用 |
| 下划线命名法 | `max_value`, `event_info` | UNIX/C++标准库风格 |

#### 8.1.2 常用前缀
| 前缀 | 含义 | 示例 |
|------|------|------|
| `i` | integer | `iCnt`, `iSize` |
| `s` | string | `sMsgBuf` |
| `p` | pointer | `pLogFile`, `pEvInfo` |
| `g_` | global | `g_dwSum` |
| `m_` | member | `m_pConfig` |
| `dw` | DWORD | `dwSum` |

### 8.2 代码注释规范

#### 8.2.1 文件头注释
```c
/* --------------------------------------------------------------------------------------------
    项目/模块名称: HY-1 Communication Subsystem : event log subroutines

    Programmer : HU Bo
    Version    : 1.00
    Date       : 2025-04-26

    Description: Error and event handling and logging
-----------------------------------------------------------------------------------------------*/
```

#### 8.2.2 函数注释
```c
/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Function: 函数功能描述

    Input:  参数说明
    Output: 返回值说明
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
void LogEvent(int iEventID, char * sEvDesc) {
    // 函数实现
}
```

### 8.3 编码原则

#### 8.3.1 "min-length max-information"
- 代码简洁，信息丰富
- 避免冗余，提高可读性

#### 8.3.2 良好的编程习惯
1. **有意义的命名**：变量名和函数名应清晰表达用途
2. **适当的注释**：关键逻辑需要注释说明
3. **模块化设计**：函数功能单一，高内聚低耦合
4. **错误处理**：考虑异常情况，做好边界检查

---

## 九、实践示例

### 9.1 事件日志系统示例

```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <sys/time.h>

// 事件处理标志
#define EVH_FILELOG    0x01    // 日志写入文件
#define EVH_CONSOLE    0x02    // 输出到控制台

// 事件信息记录结构
typedef struct __EventInfoRecord__ {
    int iEvLogFlag;     // 事件处理标志
    int iEvLogLevel;    // 事件级别
    int iParNr;         // 参数数量
    int iEventID;       // 事件标识符
} EvInfoRecord;

// 全局数据
char sMsgBuf[4096];           // 消息缓冲区
static FILE * pLogFile = NULL; // 日志文件指针

// 获取当前时间字符串
char * GetCurrentTimed(void) {
    static char sBuf[20];
    struct timeval stCurTime;
    struct tm* pTM;

    gettimeofday(&stCurTime, NULL);
    pTM = localtime(&(stCurTime.tv_sec));

    sprintf(sBuf, "%.4d-%.2d-%.2d %.2d:%.2d:%.2d",
        pTM->tm_year + 1900, pTM->tm_mon + 1,
        pTM->tm_mday, pTM->tm_hour,
        pTM->tm_min, pTM->tm_sec);

    return sBuf;
}

// 记录事件
void LogEvent(int iEventID, char * sEvDesc) {
    EvInfoRecord * pEvInfo;

    if (!iEventID) {
        OutputEventLog(0, sEvDesc,
            EVH_FILELOG | EVH_CONSOLE);
        pEvInfo = GetEvInfoTabEntry(iEventID);

        if (iEventID != pEvInfo->iEventID)
            return;
    } else {
        if (pEvInfo->iEvLogFlag & EVH_SENDMSG)
            SendCtrlMessage(iEventID, sEvDesc);
    }

    OutputEventLog(iEventID, sEvDesc, pEvInfo->iEvLogFlag);
}
```

---

## 十、总结

### 10.1 本章重点
1. C++语言的特点和优势
2. 计算机系统基本工作原理
3. 编程语言发展历史
4. 面向对象编程的基本概念
5. C/C++程序的组织结构和编译过程
6. 开发环境的搭建和使用
7. 代码规范和命名约定

### 10.2 学习建议
1. 理解计算机底层工作原理对编写高效代码很重要
2. 掌握C/C++程序的组织方式，养成良好的项目结构习惯
3. 遵循代码规范，提高代码可读性和可维护性
4. 选择合适的开发工具，提高开发效率

---

*笔记整理日期: 2026-03-02*
