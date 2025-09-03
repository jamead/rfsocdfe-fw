
// remote reporting of select LwIP statistics

#include <stdio.h>


#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>

#include "local.h"

#include "xtime_l.h"

#include "rfdfe.h"
#include "pl_regs.h"

#define MAX_TASKS 16




static void rfstats_push(void *unused)
{
    (void)unused;

    struct {
        uint32_t clk0_freq; // 0
        uint32_t clk1_freq; // 4
        uint32_t clk2_freq; // 8
        uint32_t clk3_freq; // 4
        uint32_t clk4_freq; // 8
    } msg;


    while(1) {

    	//xil_printf("RF stats Push...\r\n");
        vTaskDelay(pdMS_TO_TICKS(1000));

        //printf("Clk0: %f\r\n",Xil_In32(XPAR_M_AXI_BASEADDR + CLK0_FREQ_REG)/1e6);
        //printf("Clk1: %f\r\n",Xil_In32(XPAR_M_AXI_BASEADDR + CLK1_FREQ_REG)/1e6);
        //printf("Clk2: %f\r\n",Xil_In32(XPAR_M_AXI_BASEADDR + CLK2_FREQ_REG)/1e6);
        //printf("Clk3: %f\r\n",Xil_In32(XPAR_M_AXI_BASEADDR + CLK3_FREQ_REG)/1e6);
        //printf("Clk4: %f\r\n",Xil_In32(XPAR_M_AXI_BASEADDR + CLK4_FREQ_REG)/1e6);
        //xil_printf("\r\n");

        msg.clk0_freq = htonl(Xil_In32(XPAR_M_AXI_BASEADDR + CLK0_FREQ_REG));
        msg.clk1_freq = htonl(Xil_In32(XPAR_M_AXI_BASEADDR + CLK1_FREQ_REG));
        msg.clk2_freq = htonl(Xil_In32(XPAR_M_AXI_BASEADDR + CLK2_FREQ_REG));
        msg.clk3_freq = htonl(Xil_In32(XPAR_M_AXI_BASEADDR + CLK3_FREQ_REG));
        msg.clk4_freq = htonl(Xil_In32(XPAR_M_AXI_BASEADDR + CLK4_FREQ_REG));


        psc_send(the_server, 104, sizeof(msg), &msg);
    }
}

void rfstats_setup(void)
{
    printf("INFO: Starting rf stats daemon\n");
    sys_thread_new("rfstats", rfstats_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

