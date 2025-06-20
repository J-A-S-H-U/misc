import uvm_pkg::*;
`include "uvm_macros.svh"

class fpu_monitor extends uvm_monitor;
  `uvm_component_utils(fpu_monitor)
  virtual fpu_if vif;
  fpu_sequence_item mon_pkt;
  int fp;
  
  string file_input = "output_capture.txt";
  
  uvm_analysis_port #(fpu_sequence_item) mon_port;
  
  function new(string name="fpu_monitor",uvm_component parent);
      super.new(name,parent);
    `uvm_info("fpu_monitor", "Inside constructor", UVM_HIGH)
  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("fpu_monitor", "Inside build phase", UVM_HIGH)
    
    mon_port=new("mon_port",this);
	

		open_file();

	
    if(!(uvm_config_db #(virtual fpu_if)::get(this,"*","fpu_vif",vif)))
        `uvm_error("fpu_monitor", "Faild to get Virtual Interface")  
        
  endfunction: build_phase

  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      `uvm_info("fpu_monitor", "Inside connect phase", UVM_HIGH)
  endfunction

  task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("fpu_monitor", "Inside run phase", UVM_HIGH)
	  
      forever begin
        mon_pkt=fpu_sequence_item::type_id::create("mon_pkt");
        sample(mon_pkt);
        mon_port.write(mon_pkt);
      end

	

  endtask


  task sample(fpu_sequence_item mon_item);

    @(posedge vif.ready);

    mon_item.cmd=vif.cmd;
    mon_item.din1=vif.din1;
    mon_item.din2=vif.din2;
    mon_item.result=vif.result;
    mon_item.reset=vif.reset;
    mon_item.valid=vif.valid;
    mon_item.ready=vif.ready;

	$fwrite(fp,"%b	%d	%d	%d	%d	%b	%b\n",vif.reset, vif.cmd, vif.din1, vif.din2, vif.result, vif.valid, vif.ready);


  endtask
	
 function void extract_phase(uvm_phase phase);
      super.extract_phase(phase);
      `uvm_info("fpu_driver", "Inside build phase", UVM_HIGH)
	  
		close_file();
	
  endfunction: extract_phase
  

function open_file();
	fp = $fopen(file_input,"w");
	if (fp == 0)	$display("outputfile didnot open******************************************************************************************");
	
	$fwrite(fp,"RESET	CMD	DIN1	DIN2	RESULT	VALID	READY\n");
endfunction

task close_file();
	$fclose(fp);
endtask

endclass: fpu_monitor