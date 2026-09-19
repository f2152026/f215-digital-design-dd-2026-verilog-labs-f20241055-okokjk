module tb;

  reg  [1:0] t_a;
  reg  [1:0] t_b;
  wire       t_gt;
  wire       t_lt;
  wire       t_eq;

  reg        exp_gt;
  reg        exp_lt;
  reg        exp_eq;

  integer a;
  integer b;
  integer errors;

  comp2 dut (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  initial begin
    errors = 0;

    for (a = 0; a < 4; a = a + 1) begin
      for (b = 0; b < 4; b = b + 1) begin

        t_a = a;
        t_b = b;

        // Expected values calculated independently
        exp_gt = (a > b);
        exp_lt = (a < b);
        exp_eq = (a == b);

        #1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq,
                   exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end

      end
    end

    $write("SUMMARY: %0d passed out of 16, %0d failed", 16-errors, errors);
    $display("");
    $finish;
  end

endmodule