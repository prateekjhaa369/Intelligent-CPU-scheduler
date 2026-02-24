# 🚀 Intelligent CPU Scheduler Simulator (Pro Version)

An interactive, Java-based simulation tool designed to visualize and analyze key CPU scheduling algorithms. This project provides an educational and practical resource for understanding how Operating Systems manage processes in real-time.



## ✨ Features
* [cite_start]**Dual Algorithm Support**: Implementation of **First-Come, First-Served (FCFS)** [cite: 4, 24] [cite_start]and **Shortest Job First (SJF)**[cite: 4, 26].
* [cite_start]**Intelligence Insight**: Dynamically calculates and compares metrics to suggest the most efficient algorithm for the given workload[cite: 89, 101].
* [cite_start]**Modern UI**: Built with Java Swing, featuring a professional Dark Mode interface[cite: 8, 15].
* [cite_start]**Dynamic Gantt Chart**: Real-time graphical visualization of the process execution sequence[cite: 5, 32].
* [cite_start]**Performance Metrics**: Automatically calculates Average Waiting Time, Turnaround Time, and Throughput[cite: 6, 33, 71].

## 🧠 Core Logic & Data Structures
* [cite_start]**Process Model**: A dedicated `Process` class encapsulates attributes like Arrival Time, Burst Time, and Priority[cite: 1, 11].
* [cite_start]**SJF Optimization**: Utilizes a **PriorityQueue (Min-Heap)** to efficiently select the shortest task ($O(\log n)$ complexity)[cite: 49, 52].
* [cite_start]**FCFS Implementation**: Processes are sorted by arrival time to ensure a fair execution sequence[cite: 43, 46].

## 🛠️ Technology Stack
* [cite_start]**Language**: Java[cite: 80].
* [cite_start]**Framework**: Java Swing & AWT for the Graphical User Interface[cite: 8, 15].
* [cite_start]**Tools**: VS Code, Git/GitHub[cite: 103, 104].

## 📊 Performance Metrics Defined
1.  [cite_start]**Waiting Time (WT)**: The total time a process spends waiting in the ready queue[cite: 70].
2.  [cite_start]**Turnaround Time (TAT)**: The total time from arrival to completion[cite: 71].
    * *Formula*: $TAT = Completion\ Time - Arrival\ Time$
3.  [cite_start]**Throughput**: Number of processes completed per unit of time[cite: 73].

## 🚀 How to Run
1.  **Clone the repository**:
    ```bash
    git clone [https://github.com/YourUsername/Intelligent-CPU-Scheduler.git](https://github.com/YourUsername/Intelligent-CPU-Scheduler.git)
    ```
2.  **Compile the Java file**:
    ```bash
    javac CPUScheduler.java
    ```
3.  **Run the Application**:
    ```bash
    java CPUScheduler
    ```

## 📈 Future Scope
* [cite_start]Adding **Round Robin (RR)** and **Priority-based scheduling**[cite: 124, 127].
* [cite_start]Implementing **Cloud Integration** for distributed simulations[cite: 126].
* [cite_start]Developing a **Mobile Application** version for on-the-go analysis[cite: 128].

---
**Developed with ❤️ by Prateek, Manish and Aditya **
