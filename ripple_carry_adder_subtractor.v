`timescale 1ns / 1ps

module ripple_carry_adder_subtractor #(parameter N = 4) (
    input [N-1:0] A,
    input [N-1:0] B,
    input Cin,
    output Cout,
    output [N-1:0] S
);

    wire [N-1:0] B_mod = B ^ {N{Cin}};
    wire [N:0] carry;
    assign carry[0] = Cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder
            assign {carry[i+1], S[i]} = A[i] + B_mod[i] + carry[i];
        end
    endgenerate

    assign Cout = carry[N];
endmodule
