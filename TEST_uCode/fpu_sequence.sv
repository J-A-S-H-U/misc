import uvm_pkg::*;
`include "uvm_macros.svh"
class fpu_base_sequence extends uvm_sequence#(fpu_sequence_item);
  `uvm_object_utils(fpu_base_sequence)
  fpu_sequence_item fpu_item;
	`ifdef REPLAY
	
	int fp;
	int line = 0;
	int parse;
	string file_name = "input_capture.txt";
	logic rset;
	logic [1:0] command;
    logic [31:0] data1;
    logic [31:0] data2;
    logic vald;
	`endif
  function new(string name="fpu_sequence");
      super.new(name);
  endfunction

endclass: fpu_base_sequence


class fpu_rst_seq extends fpu_base_sequence;

  `uvm_object_utils(fpu_rst_seq)
  fpu_sequence_item item;

  function new(string name="fpu_rst_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("fpu_sequence","Running reset sequence...",UVM_HIGH);

    item=fpu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with { reset == 1;};
    finish_item(item);

  endtask
endclass


class fpu_main_seq extends fpu_base_sequence;

  `uvm_object_utils(fpu_main_seq)
  fpu_sequence_item item;

  function new(string name="fpu_main_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info("fpu_sequence","Running main sequence...",UVM_HIGH);
	`ifdef NORMAL
    item=fpu_sequence_item::type_id::create("item");
    start_item(item);
    item.randomize() with { reset == 0;
                            valid == 1;};
    finish_item(item);
	
	`elsif REPLAY
	
	fp = $fopen(file_name, "r");
	while (!$feof(fp)) begin
		parse = $fscanf(fp,"%b	%b	%b	%b	%b\n", rset, command, data1, data2, vald);
		line++;
		if (line==1) continue;
		item=fpu_sequence_item::type_id::create("item");
		start_item(item);
			item.reset = rset;
			item.cmd = command;
			item.din1 = data1;
			item.din2 = data2;
			item.valid = vald;
		finish_item(item);
	end
	`endif
	
	
  endtask
	`ifdef REPLAY
	task post_body();
		$fclose(fp);
	endtask
	`endif
endclass
