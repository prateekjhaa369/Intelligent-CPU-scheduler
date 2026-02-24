import javax.swing.*;
import javax.swing.border.EmptyBorder;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;
import java.awt.*;
import java.util.*;
import java.util.List;

class Process {
    int id, arrivalTime, burstTime, completionTime, turnAroundTime, waitingTime;
    Color color;

    public Process(int id, int arrivalTime, int burstTime) {
        this.id = id;
        this.arrivalTime = arrivalTime;
        this.burstTime = burstTime;
        // Modern palette: bright but soft colors
        Color[] palette = {
            new Color(108, 92, 231), new Color(0, 206, 201), 
            new Color(255, 118, 117), new Color(253, 203, 110),
            new Color(162, 155, 254), new Color(85, 239, 196)
        };
        this.color = palette[id % palette.length];
    }
}

public class CPUScheduler extends JFrame {
    // Advanced UI Colors
    private final Color BG_DARK = new Color(30, 30, 30);
    private final Color ACCENT_BLUE = new Color(0, 120, 215);
    private final Color CARD_BG = new Color(45, 45, 48);
    private final Color TEXT_COLOR = Color.WHITE;

    private DefaultTableModel tableModel;
    private JTable table;
    private JPanel ganttPanel;
    private JLabel insightLabel;
    private List<Process> results = new ArrayList<>();

    public CPUScheduler() {
        setTitle("Intelligent CPU Scheduler Pro");
        setSize(1100, 700);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        getContentPane().setBackground(BG_DARK);
        setLayout(new BorderLayout(10, 10));

        // 1. Header Area
        JLabel header = new JLabel("CPU SCHEDULER SIMULATOR", JLabel.CENTER);
        header.setFont(new Font("Segoe UI", Font.BOLD, 24));
        header.setForeground(TEXT_COLOR);
        header.setBorder(new EmptyBorder(20, 0, 20, 0));
        add(header, BorderLayout.NORTH);

        // 2. Central Input Table
        setupTable();
        JPanel tableContainer = new JPanel(new BorderLayout());
        tableContainer.setBackground(BG_DARK);
        tableContainer.setBorder(new EmptyBorder(0, 20, 0, 20));
        JScrollPane scrollPane = new JScrollPane(table);
        scrollPane.getViewport().setBackground(CARD_BG);
        scrollPane.setBorder(BorderFactory.createLineBorder(new Color(60, 60, 60)));
        tableContainer.add(scrollPane, BorderLayout.CENTER);
        add(tableContainer, BorderLayout.CENTER);

        // 3. Control & Visualization Panel
        setupBottomPanel();
    }

    private void setupTable() {
        String[] columns = {"Process ID", "Arrival Time", "Burst Time"};
        tableModel = new DefaultTableModel(columns, 0);
        table = new JTable(tableModel);
        
        // Styling Table
        table.setBackground(CARD_BG);
        table.setForeground(TEXT_COLOR);
        table.setGridColor(new Color(60, 60, 60));
        table.setRowHeight(30);
        table.setFont(new Font("Segoe UI", Font.PLAIN, 14));
        
        JTableHeader header = table.getTableHeader();
        header.setBackground(new Color(50, 50, 50));
        header.setForeground(TEXT_COLOR);
        header.setFont(new Font("Segoe UI", Font.BOLD, 14));

        // Initial Data
        tableModel.addRow(new Object[]{"1", "0", "5"});
        tableModel.addRow(new Object[]{"2", "1", "3"});
        tableModel.addRow(new Object[]{"3", "2", "1"});
    }

    private void setupBottomPanel() {
        JPanel bottomContainer = new JPanel(new BorderLayout(10, 10));
        bottomContainer.setBackground(BG_DARK);
        bottomContainer.setBorder(new EmptyBorder(10, 20, 20, 20));

        // Buttons
        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));
        btnPanel.setBackground(BG_DARK);
        
        JButton addBtn = createModernBtn("Add Process", new Color(46, 204, 113));
        JButton fcfsBtn = createModernBtn("Run FCFS", ACCENT_BLUE);
        JButton sjfBtn = createModernBtn("Run SJF", ACCENT_BLUE);

        addBtn.addActionListener(e -> tableModel.addRow(new Object[]{tableModel.getRowCount()+1, "0", "0"}));
        fcfsBtn.addActionListener(e -> runAlgorithm(false));
        sjfBtn.addActionListener(e -> runAlgorithm(true));

        btnPanel.add(addBtn);
        btnPanel.add(fcfsBtn);
        btnPanel.add(sjfBtn);

        // Insight & Gantt
        JPanel visPanel = new JPanel(new BorderLayout());
        visPanel.setBackground(CARD_BG);
        visPanel.setBorder(BorderFactory.createLineBorder(new Color(70, 70, 70)));

        insightLabel = new JLabel("Status: System Ready");
        insightLabel.setForeground(new Color(200, 200, 200));
        insightLabel.setBorder(new EmptyBorder(10, 10, 10, 10));

        ganttPanel = new JPanel() {
            @Override
            protected void paintComponent(Graphics g) {
                super.paintComponent(g);
                Graphics2D g2 = (Graphics2D) g;
                g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
                drawAdvancedGantt(g2);
            }
        };
        ganttPanel.setPreferredSize(new Dimension(800, 150));
        ganttPanel.setBackground(CARD_BG);

        visPanel.add(insightLabel, BorderLayout.NORTH);
        visPanel.add(ganttPanel, BorderLayout.CENTER);

        bottomContainer.add(btnPanel, BorderLayout.NORTH);
        bottomContainer.add(visPanel, BorderLayout.CENTER);
        add(bottomContainer, BorderLayout.SOUTH);
    }

    private JButton createModernBtn(String text, Color bg) {
        JButton btn = new JButton(text);
        btn.setFocusPainted(false);
        btn.setBackground(bg);
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 13));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setBorder(new EmptyBorder(10, 20, 10, 20));
        return btn;
    }

    private void runAlgorithm(boolean isSJF) {
        List<Process> processes = new ArrayList<>();
        try {
            for (int i = 0; i < tableModel.getRowCount(); i++) {
                int id = Integer.parseInt(tableModel.getValueAt(i, 0).toString());
                int arr = Integer.parseInt(tableModel.getValueAt(i, 1).toString());
                int burst = Integer.parseInt(tableModel.getValueAt(i, 2).toString());
                processes.add(new Process(id, arr, burst));
            }
        } catch (Exception e) {
            JOptionPane.showMessageDialog(this, "Please enter valid numbers!");
            return;
        }

        results.clear();
        int time = 0;
        double totalWait = 0;

        if (isSJF) {
            PriorityQueue<Process> pq = new PriorityQueue<>(Comparator.comparingInt(p -> p.burstTime));
            int done = 0, n = processes.size();
            boolean[] added = new boolean[n];
            while (done < n) {
                for (int i = 0; i < n; i++) {
                    if (!added[i] && processes.get(i).arrivalTime <= time) {
                        pq.add(processes.get(i));
                        added[i] = true;
                    }
                }
                if (pq.isEmpty()) { time++; continue; }
                Process cur = pq.poll();
                cur.waitingTime = time - cur.arrivalTime;
                totalWait += cur.waitingTime;
                time += cur.burstTime;
                results.add(cur);
                done++;
            }
        } else {
            processes.sort(Comparator.comparingInt(p -> p.arrivalTime));
            for (Process p : processes) {
                if (time < p.arrivalTime) time = p.arrivalTime;
                p.waitingTime = time - p.arrivalTime;
                totalWait += p.waitingTime;
                time += p.burstTime;
                results.add(p);
            }
        }

        insightLabel.setText(String.format(" Intelligence Insight: %s Mode | Average Waiting Time: %.2f ms", 
                            isSJF ? "SJF" : "FCFS", totalWait / results.size()));
        ganttPanel.repaint();
    }

    private void drawAdvancedGantt(Graphics2D g) {
        int x = 30;
        int y = 40;
        for (Process p : results) {
            int width = p.burstTime * 40;
            
            // Draw Box with Shadow effect
            g.setColor(p.color);
            g.fillRoundRect(x, y, width, 60, 10, 10);
            
            // Draw Text
            g.setColor(Color.WHITE);
            g.setFont(new Font("Segoe UI", Font.BOLD, 12));
            g.drawString("P" + p.id, x + (width/2) - 10, y + 35);
            
            // Draw Time marker
            g.setColor(new Color(180, 180, 180));
            g.setFont(new Font("Segoe UI", Font.PLAIN, 10));
            g.drawString(String.valueOf(x-30), x, y + 80);
            
            x += width + 5; // spacing
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new CPUScheduler().setVisible(true));
    }
}