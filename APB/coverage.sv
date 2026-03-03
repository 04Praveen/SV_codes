class coverage;

  apb_transaction tr;

  covergroup apb_cg;

    cp_write : coverpoint tr.pwrite {
      bins WRITE = {1};
      bins READ  = {0};
    }

    cp_addr : coverpoint tr.addr {
      bins low_addr[] = {[0:4]};
      bins high_addr[] = {[5:9]};
    }

    cp_data : coverpoint tr.data {
      bins small1[] = {[0:10]};
      bins medium1[] = {[11:20]};
      bins large1[] = {[21:31]};
    }

    cross cp_write, cp_addr;

  endgroup

  function new();
    apb_cg = new();
  endfunction

  function void sample(apb_transaction t);
    tr = t;
    apb_cg.sample();
  endfunction

endclass
