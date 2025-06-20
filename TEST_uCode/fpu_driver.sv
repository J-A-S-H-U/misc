import uvm_pkg::*;
`include "uvm_macros.svh"

class fpu_driver extends uvm_driver #(fpu_sequence_item);
  `uvm_component_utils(fpu_driver)
  virtual fpu_if vif;
  fpu_sequence_item drv_pkt;
  int fp;
  
  string file_input = "input_capture.txt";
  

	int a,b,c,d,e;
	
  function new(string name="fpu_driver",uvm_component parent);
      super.new(name,parent);
      `uvm_info("fpu_driver", "Inside constructor of fpu_driver", UVM_HIGH)
      
  endfunction

  function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      `uvm_info("fpu_driver", "Inside build phase", UVM_HIGH) 
	`ifdef NORMAL 
		open_file();
	`endif
	
    if(!(uvm_config_db #(virtual fpu_if)::get(this,"*","fpu_vif",vif)))
          `uvm_error(get_name(), "Faild to get Virtual interface")

  endfunction: build_phase

  task run_phase(uvm_phase phase);
      super.run_phase(phase);
      `uvm_info("fpu_driver", "Inside run phase", UVM_HIGH)
	
    repeat(2) begin
      drv_pkt=fpu_sequence_item::type_id::create("drv_pkt");
      seq_item_port.get_next_item(drv_pkt);
      init_drive(drv_pkt);
      seq_item_port.item_done();   
    end

    forever begin
      drv_pkt=fpu_sequence_item::type_id::create("drv_pkt");
      seq_item_port.get_next_item(drv_pkt);
      drive(drv_pkt);
      seq_item_port.item_done();
    end
	
	
  endtask


task drive(fpu_sequence_item drv_pkt);
  `uvm_info(get_name(),"Drive...",UVM_HIGH)
  @(posedge vif.ready);
  vif.reset<=drv_pkt.reset;
  vif.cmd<=drv_pkt.cmd;
  vif.din1<=drv_pkt.din1;
  vif.din2<=drv_pkt.din2;
  vif.valid<=drv_pkt.valid;
`ifdef NORMAL
  $fwrite(fp,"%b	%d	%d	%d	%b\n",vif.reset, vif.cmd, vif.din1, vif.din2, vif.valid);
`endif

endtask

task init_drive(fpu_sequence_item drv_item);
  `uvm_info(get_name(),"Init Drive...",UVM_HIGH)
  @(negedge vif.clk);
  vif.reset<=drv_item.reset;
  vif.cmd<=drv_item.cmd;
  vif.din1<=drv_item.din1;
  vif.din2<=drv_item.din2;
  vif.valid<=drv_item.valid;
`ifdef NORMAL
  $fwrite(fp,"%b	%d	%d	%d	%b\n",vif.reset, vif.cmd, vif.din1, vif.din2, vif.valid);
`endif
endtask

`ifdef NORMAL
 function void extract_phase(uvm_phase phase);
      super.extract_phase(phase);
      `uvm_info("fpu_driver", "Inside build phase", UVM_HIGH)
	  
		close_file();
	
  endfunction: extract_phase
`endif

`ifdef NORMAL
function open_file();
	fp = $fopen(file_input,"w");
	if (fp == 0)	$display("inputfile didnot open******************************************************************************************");
	
	$fwrite(fp,"RESET	CMD	DIN1	DIN2	VALID\n");
endfunction

task close_file();
	$fclose(fp);
endtask

`endif
endclass: fpu_driver