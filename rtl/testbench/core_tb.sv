`timescale 1ns / 1ns

module Core_tb;

 // clock and reset signals
 logic clk = 1;
 logic reset;

 // Loop variable for loading instructions
 integer i;


bit [31:0] test_instructions [] = {
  //simple flushing test
    32'h00000000//  = NOP
    32'h002282b3//  = add x5, x5, x2      → x5 = x5 + x2
    32'h40760233//  = sub x4, x12, x7     → x4 = x12 - x7
    32'hff9ff56f//  = jal x10, -8         → x10 = PC+4, jump to PC-8 (back to the add)
    32'h405202b3//  = sub x5, x4, x5      → x5 = x4 - x5 (should be FLUSHED)
    32'h00c20313//  = addi x6, x4, 12     → x6 = x4 + 12 (should be FLUSHED)
};



 
 initial
 begin
   // dump waveform signals into a vcd waveform file
   $dumpfile("Core_Simulation.vcd");
   $dumpvars(0, Core_tb);
	
	reset = 1'b1;
	
	#1
   // Loop over the array of instructions
   for (i = 0; i < $size(test_instructions); i++)
   begin
	
	  // Now load each byte in to memory manually
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 0] = test_instructions[i][31:24];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 1] = test_instructions[i][23:16];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 2] = test_instructions[i][15:8];
     rv32_core.InstructionFetch_Module.InstructionMemory.instr_RAM[i * 4 + 3] = test_instructions[i][7:0];
   end
	
	#3 reset = 1'b0;
	
	
   // end simulation after (# of instructions * 4ns(clk period))
   #100 $finish;
 end


always
	#2 clk <= ~clk;



 // instantiate the RISC-V core
 Core rv32_core (
        .clock(clk),
        .reset(reset),
        .mem_en(1'b1)
      );

endmodule
