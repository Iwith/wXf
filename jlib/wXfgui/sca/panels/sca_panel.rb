#!/usr/bin/env jruby

require 'rubygems'
require 'java'
require 'find'

begin
   require 'to_regexp'
rescue LoadError
    print("\e[1;31m[wXf error]\e[0m Please ensure you have the following gems installed:\n")
    print("1) to_regexp\n")
end

import javax.swing.ListSelectionModel
import javax.swing.table.DefaultTableModel
import javax.swing.JTable
import javax.swing.JTabbedPane
import javax.swing.SwingConstants
import javax.swing.GroupLayout
import java.awt.Color
import javax.swing.JButton
import java.awt.FlowLayout
import javax.swing.JFileChooser
import javax.swing.JFrame
import javax.swing.JOptionPane
import javax.swing.JPanel
import javax.swing.JTextField
import javax.swing.JTextArea
import javax.swing.JScrollPane
import java.awt.event.FocusListener
import java.awt.event.MouseListener
import java.awt.Dimension
import javax.swing.JLabel

class DataEntryPanel < JPanel
   
   def initialize
      super(FlowLayout.new(FlowLayout::LEFT))
      init
   end
   
   def init
   
      # Labels
      
      l1 = JLabel.new("Directory to search")
      l2 = JLabel.new("string to search for")
      
      # Text Fields
      @tf1 = JTextField.new(3)
      @tf2 = JTextField.new(3)
      
      #
      # GROUP LAYOUT OPTIONS
      #
      
      layout = GroupLayout.new self
      # Add Group Layout to the frame
      self.setLayout layout
      # Create sensible gaps in components (like buttons)
      layout.setAutoCreateGaps true
      layout.setAutoCreateContainerGaps true     
   
      sh1 = layout.createSequentialGroup
      sv1 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
    
      layout.setHorizontalGroup sh1
      layout.setVerticalGroup sv1
      
      p1.addComponent(l1)
      p1.addComponent(@tf1)
      p1.addComponent(l2)
      p1.addComponent(@tf2)
      sh1.addGroup(p1)
      sv1.addComponent(l1)
      sv1.addComponent(@tf1)
      sv1.addComponent(l2)
      sv1.addComponent(@tf2)

   end
end

class ResultsTable <  DefaultTableModel
  # include TableModelListener
   
   def initialize
      super
      init
   end
   
   def init
       self.add_column("file")
       self.add_column("line number")
       self.add_column("string match")
   end 
   
   def isCellEditable(row, col)
      return false
   end
   
   def delete_all_rows
      i = 0
      while i < self.getRowCount()
         self.removeRow(i)
         i+1
      end
   end   
   
end 

#
#
# This is going to be an analysis tab where the decision tree works its magic
#
#
module WxfGui
class ScaPanel < JPanel
  
   include MouseListener
   include FocusListener
  
  def initialize
    super
    init
  end
  
  def init
   
      
     
      # Panels
      jp1 = DataEntryPanel.new()
      #JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      #jp2 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      jp3 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      #  jp4 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      jp5 = JPanel.new(FlowLayout.new(FlowLayout::LEFT))
      
    
     
      # Table area
       @results_table = ResultsTable.new
       @table = JTable.new(@results_table)
       @table.setPreferredScrollableViewportSize(Dimension.new(1000, 250))
       @table.setFillsViewportHeight(true)
       @table.setSelectionMode(ListSelectionModel.SINGLE_SELECTION)
      
      # Scroll pane
      @js1 = JScrollPane.new(@table)
      
      
      # Buttons
      chooseDir = JButton.new("choose")
      searchButton = JButton.new("search")
      
      
      # Add stuff to panels
     # jp1.add(@tf1)
      #jp2.add(@tf2)
      jp3.add(@js1)
     # jp4.add(l1)
      #jp5.add(l2)
      
      # Add listener actions to button
      #
      # Choose Directory Button
      chooseDir.addActionListener do |e|
        dir = JFileChooser.new
        dir.setCurrentDirectory(java.io.File.new(Dir.pwd))
        dir.setFileSelectionMode(JFileChooser::DIRECTORIES_ONLY)
        ret = dir.showDialog @panel, "Choose Directory"
        if  ret  == JFileChooser::APPROVE_OPTION
            destDir = dir.getCurrentDirectory()
            searchDir = destDir.to_s
            @tf1.text = searchDir.length > 0 ? searchDir : ''
        end 
      end 
      
      # Search button
      searchButton.addActionListener do |e|
         if @tf1.text.length <= 0
           error("Please enter a directory")
         elsif @tf2.text.length <= 0
           error("Please enter something to search for")
         else
            search
         end
      end 
      
      
      
      #
      # GROUP LAYOUT OPTIONS
      #
      
      layout = GroupLayout.new self
      # Add Group Layout to the frame
      self.setLayout layout
      # Create sensible gaps in components (like buttons)
      layout.setAutoCreateGaps true
      layout.setAutoCreateContainerGaps true     
     
      sh1 = layout.createSequentialGroup
      sh2 = layout.createSequentialGroup
      sh3 = layout.createSequentialGroup
      sv1 = layout.createSequentialGroup
      sv2 = layout.createSequentialGroup
      sv3 = layout.createSequentialGroup
      p1 = layout.createParallelGroup
      p2 = layout.createParallelGroup
      p3 = layout.createParallelGroup
      
      layout.setHorizontalGroup sh3
      layout.setVerticalGroup sv3
      
      
      # Horizontal
      #p1.addComponent(jp4)
      p1.addComponent(jp1)
      p1.addComponent(jp5)
      #@p1.addComponent(jp2)
      p1.addComponent(jp3)
      
      sh1.addGroup(p1)
      p2.addComponent(chooseDir)
      p2.addComponent(searchButton)
      sh2.addGroup(p2)
      sh3.addGroup(sh1)
      sh3.addGroup(sh2)
      
      # Vertical
     # sv1.addComponent(jp4)
      sv1.addComponent(jp1)
      sv1.addComponent(jp5)
      #sv1.addComponent(jp2)      
 
      sv1.addComponent(jp3)
      sv2.addComponent(chooseDir)
      sv2.addComponent(searchButton)
      p3.addGroup(sv1)
      p3.addGroup(sv2)
      sv3.addGroup(p3)
      
       layout.linkSize SwingConstants::HORIZONTAL, 
          chooseDir, searchButton

     
  end
  
  def error(text)
   JOptionPane.showMessageDialog self, "#{text}",
      "Error", JOptionPane::ERROR_MESSAGE     
  end
  
  def search
     if @tf1.text.length > 0 and @tf2.text.length > 0
        if File.directory?("#{@tf1.text}")
           finder
        end
     end
  end
  
  def finder
     @file_array = []
     @str = ''
     return unless @tf1.text.length > 0     
     
     #First loop, to collect
     Find.find(@tf1.text) do |file|
        if File.file?(file) and File.extname(file) == '.rb'        
            @file_array<<(file)
        end
     end
     
     # Second loop, to read
     @file_array.each do |file|
        f = File.open(file, "r")
        f.each_with_index do |line, idx|
           if line.include?("#{@tf2.text}") || line.include?("#{@tf2.text.downcase}") || line.include?("#{@tf2.text.capitalize}")
              @str << "File: #{file}, line number: #{idx}\n"
             # @ta.text = "#{@str}"
           end
        end
     end
     @str << "Finished!"
  end
  
end


class WxfScaPanel < JTabbedPane
   
   def initialize
      super(JTabbedPane::TOP, JTabbedPane::SCROLL_TAB_LAYOUT)
      init
   end
   
   def init
    cp = ScaPanel.new
    self.add("Regexp Search", cp)
   end
end

=begin
#Test code within here


=end

class TestFrame < JFrame
  
  def initialize
    super("Unit Test")
    init
  end
  
  def init
     
    
    smp = WxfScaPanel.new
    
    self.add(smp)
    
    self.setJMenuBar menuBar
    self.setPreferredSize Dimension.new(1300, 900)
    self.pack
    
    self.setDefaultCloseOperation JFrame::EXIT_ON_CLOSE
    self.setLocationRelativeTo nil
    self.setVisible true
    
  end
  
end 

end

WxfGui::TestFrame.new