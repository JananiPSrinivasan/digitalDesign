class uart_monitor; 
    virtual uart_if vif; // virtual handle

    function new(virtual uart_if pif); 
        this.vif = pif;
    endfunction

    task wait_bclk();
        do begin 
            @(posedge vif.clk);
        end while (!vif.bclk_pulse);
    endtask

    task monitor(output uart);
    
    endtask

endclass