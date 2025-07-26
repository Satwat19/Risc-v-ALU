`timescale 1ns / 1ps

module ALU (
    input clk,
    input reset,
    input [3:0] G_sel,
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] G,
    output [3:0] ZCNVFlags,
    output led_Z,
    output led_C,
    output led_N,
    output led_V
);

    wire [3:0] Arithmetic_result, Logical_result;
    wire carry_out;

    wire signed [3:0] A_signed = A;
    wire signed [3:0] B_signed = B;

    reg [3:0] flags;
    assign ZCNVFlags = flags;

    assign led_Z = flags[3];
    assign led_C = flags[2];
    assign led_N = flags[1];
    assign led_V = flags[0];

    ripple_carry_adder_subtractor #(.N(4)) rcas (
        .A(A),
        .B(B),
        .Cin(G_sel[0]),
        .Cout(carry_out),
        .S(Arithmetic_result)
    );

    logical_unit lu (
        .L_sel(G_sel[2:1]),
        .A(A),
        .B(B),
        .G(Logical_result)
    );

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            G <= 4'b0000;
            flags <= 4'b0000;
        end else begin
            if (G_sel[3]) begin
                G <= Logical_result;
                flags <= {~|Logical_result, 1'b0, 1'b0, 1'b0};
            end else begin
                G <= Arithmetic_result;
                flags[0] <= (!G_sel[0] & A_signed[3] & B_signed[3] & ~Arithmetic_result[3]) |
                            (!G_sel[0] & ~A_signed[3] & ~B_signed[3] & Arithmetic_result[3]) |
                            (G_sel[0] & A_signed[3] & ~B_signed[3] & ~Arithmetic_result[3]) |
                            (G_sel[0] & ~A_signed[3] & B_signed[3] & Arithmetic_result[3]);
                flags[1] <= Arithmetic_result[3];
                flags[2] <= carry_out;
                flags[3] <= ~|Arithmetic_result;
            end
        end
    end
endmodule
