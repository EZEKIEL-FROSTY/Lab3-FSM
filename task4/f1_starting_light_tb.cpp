#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vf1_starting_light.h"

#include "../vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 100000

int main(int argc, char **argv, char **env)
{
    int simcyc;     // simulation clock count
    int tick;       // each clk cycle has two ticks for two edges
    int lights = 0; // state to toggle LED lights

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vf1_starting_light *top = new Vf1_starting_light;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("f1_starting_light.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("L3T4: F1 Lights");
    vbdSetMode(1); 

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 0;
    top->trigger = 0;
    top->N = 44; 

    bool startWatch = false;
    int reactionTime = 0;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            top->clk = !top->clk;
            top->eval();
            tfp->dump(2 * simcyc + tick);
        }
        top->trigger = vbdFlag();
        vbdBar(top->data_out & 0xFF);

        if (top->data_out == 0x00 && !watch_started)
        {
            vbdInitWatch();
            startWatch = true;
        }

        if (watch_started && vbdFlag()) 
        {
            reaction_time = vbdElapsed();
            vbdHex(reaction_time);
            startWatch = false;
        }

        if (Verilated::gotFinish() || vbdGetkey() == 'q')
            exit(0);
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}