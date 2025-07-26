module logical_unit (
    input [1:0] L_sel,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] G
);

    always @(*) begin
        case (L_sel)
            2'b00: G = A & B;
            2'b01: G = A | B;
            2'b10: G = A ^ B;
            2'b11: G = ~(A ^ B);
            default: G = 4'b0000;
        endcase
    end
endmodule
