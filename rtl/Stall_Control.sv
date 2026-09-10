import CORE_PKG::*;

module Stall_Control (
  input logic reset, 

  input logic [6:0] ID_instr_opcode_ip,
  input logic [4:0] ID_src1_addr_ip,
  input logic [4:0] ID_src2_addr_ip,

  //The destination register from the different stages
  input logic [4:0] EX_reg_dest_ip,  // destination register from EX pipe
  input logic [4:0] LSU_reg_dest_ip,
  input logic [4:0] WB_reg_dest_ip,
  input logic WB_write_reg_en_ip,

  // The opcode of the current instr. in ID/EX
  input [6:0] EX_instr_opcode_ip,

  output logic stall_op
);

  always_comb begin
    stall_op = 1'b0;
    case(ID_instr_opcode_ip) 

    OPCODE_OP: begin
        if (EX_instr_opcode_ip === OPCODE_LOAD && 
                EX_reg_dest_ip !== 5'd0 && 
                (EX_reg_dest_ip === ID_src1_addr_ip || EX_reg_dest_ip === ID_src2_addr_ip)) begin
            stall_op = 1'b1;
        end
        else if (WB_write_reg_en_ip && WB_reg_dest_ip !== 5'd0 && 
            (WB_reg_dest_ip === ID_src1_addr_ip || WB_reg_dest_ip === ID_src2_addr_ip) &&
            (WB_reg_dest_ip != EX_reg_dest_ip) && (WB_reg_dest_ip != LSU_reg_dest_ip)) begin
              stall_op = 1'b1;
        end

    end

    OPCODE_OPIMM: begin
        if (EX_instr_opcode_ip === OPCODE_LOAD &&
                EX_reg_dest_ip !== 5'd0 &&
                EX_reg_dest_ip === ID_src1_addr_ip) begin
            stall_op = 1'b1;
        end
        else if (WB_write_reg_en_ip && WB_reg_dest_ip !== 5'd0 && 
            (WB_reg_dest_ip === ID_src1_addr_ip) &&
            (WB_reg_dest_ip != EX_reg_dest_ip) && (WB_reg_dest_ip != LSU_reg_dest_ip)) begin
              stall_op = 1'b1;
        end
    end

      default: begin
        stall_op = 1'b0;
      end
    endcase
  end

  endmodule
