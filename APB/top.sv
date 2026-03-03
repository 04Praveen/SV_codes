`include "environment.sv"
`include "interface.sv"
`include "design.sv"
//`include "assertion.sv"


module tb;

  logic PCLK;

  apb_if vif(PCLK);
  env e;

  apb dut(.PCLK(PCLK),.PRESETn(vif.PRESETn),.PSEL(vif.PSEL),.PENABLE(vif.PENABLE),.PWRITE(vif.PWRITE),
    .PADDR(vif.PADDR),.PWDATA(vif.PWDATA),.PRDATA(vif.PRDATA),.PREADY(vif.PREADY),.PSLVERR(vif.PSLVERR));

 //apb_assert simple_assert_inst (.PCLK(vif.PCLK),.PRESETn(vif.PRESETn),.PSEL(vif.PSEL),.PENABLE(vif.PENABLE),
   // .PWRITE  (vif.PWRITE),.PWDATA  (vif.PWDATA),.PRDATA  (vif.PRDATA),.PREADY  (vif.PREADY));

  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end

  initial begin
    vif.PRESETn = 0;
    #20;
    vif.PRESETn = 1;
  end

  initial begin
    e = new(vif);
    e.run();
    #2000;
    $finish;
  end

  final begin
  $display("\n==========================");
  $display("Functional Coverage = %0.2f%%",
            e.mon.cov.apb_cg.get_coverage());
  $display("==========================\n");
end

endmodule
