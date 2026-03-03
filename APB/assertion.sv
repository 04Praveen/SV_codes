module apb_assert (
    input        PCLK,
    input        PRESETn,
    input        PSEL,
    input        PENABLE,
    input        PWRITE,
    input  [4:0] PWDATA,
    input  [4:0] PRDATA,
    input        PREADY);

  property write_phase_check;
    @(posedge vif.PCLK)
    disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && vif.PWRITE) |-> vif.PREADY;
  endproperty

  assert_write_check: assert property(write_phase_check)
    else $error("WRITE happened outside ACCESS phase");

  property read_phase_check;
    @(posedge vif.PCLK)
    disable iff (!vif.PRESETn)
    (vif.PSEL && vif.PENABLE && !vif.PWRITE) |-> vif.PREADY;
  endproperty

  assert_read_check: assert property(read_phase_check)
    else $error("READ happened outside ACCESS phase");

  property penable_check;
    @(posedge vif.PCLK)
    disable iff (!vif.PRESETn)
    vif.PENABLE |-> vif.PSEL;
  endproperty

  assert_penable_check: assert property(penable_check)
    else $error("PENABLE high without PSEL");endmodule
