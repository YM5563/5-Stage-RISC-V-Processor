import CORE_PKG::*;

module Flush_Control (
  input logic reset,
  input logic alu_valid,

  input pc_mux pc_mux_ip,

  output logic flush_en
);

    always @(*) begin
        flush_en = 1'b0;
        
        if (pc_mux_ip == ALU_RESULT && alu_valid == 1'b1) begin
            flush_en = 1'b1;
        end
    end


endmodule