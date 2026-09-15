`timescale 1ns / 1ns

module Core_tb;

 // clock and reset signals
 logic clk = 1;
 logic reset;

 // Loop variable for loading instructions
 integer i;


bit [31:0] test_instructions [] = {

  //FEW Functional tests: ADD ANY SET OF INSTRUCTION HERE

  //Simple functional testing
    32'h00000000,// = nop
    32'hfec10493,// = addi x9, x2, -20
    32'h00c58533,// = add x10, x11, x12
    32'h00002403,// = lw x8, 0(x0)
    32'h40618a33,// = sub x20, x3, x6
    32'h01392ab3,// = slt x21, x18, x19
    32'h014005ef,// = jal x11, 20

  //simple flushing test
    32'h00000000,//  = NOP
    32'h002282b3,//  = add x5, x5, x2      x5 = x5 + x2
    32'h40760233,//  = sub x4, x12, x7     x4 = x12 - x7
    32'hff9ff56f,//  = jal x10, -8         x10 = PC+4, jump to PC-8 (back to the add)
    32'h405202b3,//  = sub x5, x4, x5      x5 = x4 - x5 (should be FLUSHED)
    32'h00c20313,//  = addi x6, x4, 12     x6 = x4 + 12 (should be FLUSHED)

  //JAL test
    32'h00000000, 
    32'h00002783, 
    32'h00178793, 
    32'h0080056f, 
    32'h00a182b3, 
    32'h00a782b3, 
    32'h004005ef, 
    32'h0040066f, 
    32'h00c582b3, 
    32'h003282b3, 
    32'h00c006ef, 
    32'h003a8a33, 
    32'hfd9ff76f, 
    32'h00402683 
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
