module tb;

  reg  [3:0] a;
  reg  [3:0] b;
  reg        op;
  wire [3:0] result;

  integer errors;
  integer i;
  integer j;
  reg [3:0] expected;

  alu dut (
    .a      (a),
    .b      (b),
    .op     (op),
    .result (result)
  );

  task check;
    input [3:0] exp;
    begin
      #1;
      if (result !== exp) begin
        $display("FAIL at time %0t: a=%b b=%b op=%b got result=%b expected=%b",
                 $time, a, b, op, result, exp);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;

    // Same operands, switch ONLY op
    a = 4'd5;
    b = 4'd3;

    op = 1'b0;
    check(4'd8);

    op = 1'b1;
    check(4'd2);

    // Several subtraction cases
    a = 4'd9;
    b = 4'd4;
    op = 1'b1;
    check(4'd5);

    a = 4'd12;
    b = 4'd7;
    op = 1'b1;
    check(4'd5);

    a = 4'd3;
    b = 4'd10;
    op = 1'b1;
    check(4'd9);

    // All 16 operand pairs for both operations
    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin

        a = i;
        b = j;

        // Addition
        op = 1'b0;
        expected = i + j;
        check(expected);

        // Subtraction
        op = 1'b1;
        expected = i - j;
        check(expected);

      end
    end

    if (errors == 0)
      $display("SUMMARY: PASS - all tests passed");
    else
      $display("SUMMARY: FAIL - %0d tests failed", errors);

    $finish;
  end

endmodule