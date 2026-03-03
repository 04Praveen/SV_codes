class scoreboard;

  mailbox #(apb_transaction) mbx;
  bit [4:0] ref_mem [0:31];

  function new(mailbox #(apb_transaction) mbx);
    this.mbx = mbx;
  endfunction

  task run();
    apb_transaction tr;

    forever begin
      mbx.get(tr);

      if(tr.pwrite) begin
        ref_mem[tr.addr] = tr.data;
        $display("[SCB] WRITE stored addr=%0d data=%0d",
                  tr.addr, tr.data);
      end
      else begin
        if(ref_mem[tr.addr] == tr.data)
          $display("[SCB] READ PASS addr=%0d data=%0d",
                    tr.addr, tr.data);
        else
          $display("[SCB] READ FAIL addr=%0d expected=%0d got=%0d",
                    tr.addr, ref_mem[tr.addr], tr.data);
      end
    end
  endtask

endclass
