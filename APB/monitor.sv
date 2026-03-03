class monitor;

  virtual apb_if vif;
  mailbox #(apb_transaction) mbx;
  coverage cov; 

  function new(virtual apb_if vif,
               mailbox #(apb_transaction) mbx);
    this.vif = vif;
    this.mbx = mbx;
    cov = new();
  endfunction

 task run();
  apb_transaction tr;

  forever begin
    @(posedge vif.PCLK);

    if(vif.PREADY) begin  
      tr = new();
      tr.pwrite = vif.PWRITE;
      tr.addr   = vif.PADDR;

      if(vif.PWRITE)
        tr.data = vif.PWDATA;
      else
        tr.data = vif.PRDATA;

      tr.display("MON");
      mbx.put(tr);

      cov.sample(tr); // sample coverage
    end
  end
endtask

endclass
