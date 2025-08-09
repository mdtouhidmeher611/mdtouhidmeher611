import javax.swing.*;
import java.awt.*;
import java.awt.event.*;


public class nuegui extends JFrame implements ActionListener {
     JButton close;
     JLabel welcome;

     public nuegui(){
        setTitle("I am doing it");
        setSize(200,100);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel center = new JPanel (new FlowLayout(FlowLayout.CENTER,10,20));

        welcome = new JLabel("Welcome");
        close = new JButton("Close");
        
        close.addActionListener(this);
        
        
        center.add(welcome);
        center.add(close);
        
        add(center);
        
        setVisible(true);
     }

     @Override
     public void actionPerformed(ActionEvent e){
        if(e.getSource() == close){
            System.exit(0);
        }
     }
     public static void main(String[] args) {
        new nuegui();
     }

    
}
