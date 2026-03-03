`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "coverage.sv"
`include "monitor.sv"
`include "scoreboard.sv"



class env;

  generator gen;
  driver    drv;
  monitor   mon;
  scoreboard scb;

  mailbox #(apb_transaction) gen_drv_mbx;
  mailbox #(apb_transaction) mon_scb_mbx;

  virtual apb_if vif;

  function new(virtual apb_if vif);
    this.vif = vif;

    gen_drv_mbx = new();
    mon_scb_mbx = new();

    gen = new(gen_drv_mbx);
    drv = new(vif, gen_drv_mbx);
    mon = new(vif, mon_scb_mbx);
    scb = new(mon_scb_mbx);
  endfunction

  task run();
   wait(vif.PRESETn);
    fork
      gen.run();
      drv.run();
      mon.run();
      scb.run();
    join_none
  endtask

endclass
