
#include <stdio.h>
#include <string.h>
#include <sleep.h>
#include "xil_cache.h"

#include "lwip/sockets.h"
#include "netif/xadapter.h"
#include "lwipopts.h"
#include "xil_printf.h"
#include "FreeRTOS.h"
#include "task.h"

/* Hardware support includes */
#include "pl_regs.h"
#include "psc_msg.h"
#include "rfdfe.h"








void set_fpleds(u32 msgVal)  {
	Xil_Out32(XPAR_M_AXI_BASEADDR + FP_LEDS_REG, msgVal);
}


void soft_trig(u32 msgVal) {

	u32 wdcnt, active_trig;

    //Triggered from PV write to this register which sets it high
    active_trig = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG);
	if (msgVal == 1 && active_trig == 0) {
      xil_printf("Soft Trigger...\r\n");
      // clear the FIFO
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RST_REG, 1);
      vTaskDelay(pdMS_TO_TICKS(10));
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RST_REG, 0);
      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt after reset = %d\r\n",wdcnt);
      //Trigger
      Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 1);
      vTaskDelay(pdMS_TO_TICKS(10));
      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt after trigger = %d\r\n",wdcnt);
      //Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_TRIG_REG, 0);
      wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
      xil_printf("FIFO Wdcnt = %d\r\n",wdcnt);
	}
}

void set_eventno(u32 msgVal) {
	Xil_Out32(XPAR_M_AXI_BASEADDR + EVR_DMA_TRIGNUM_REG, msgVal);
}

void set_trigsrc(u32 msgVal) {
    if (msgVal == 0) {
        xil_printf("Setting Trigger Source to EVR\r\n");
        Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TRIGSRC_REG, msgVal);
    }
    else if (msgVal == 1) {
	    xil_printf("Setting Trigger Source to INT (soft)\r\n");
        Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TRIGSRC_REG, msgVal);
    }
    else
        xil_printf("Invalid Trigger Source\r\n");

}













void reg_settings(void *msg) {

	u32 *msgptr = (u32 *)msg;
	u32 addr;

	typedef union {
	    u32 u;
	    float f;
	    s32 i;
	} MsgUnion;

	MsgUnion data;


    addr = htonl(msgptr[0]);
    data.u = htonl(msgptr[1]);

    //xil_printf("Addr: %d    Data: %d\r\n",addr,data.u);


    switch(addr) {
        case SOFT_TRIG_MSG:
            soft_trig(data.u);
            break;

        case EVENT_NO_MSG:
           	xil_printf("DMA Event Number Message:   Value=%d\r\n",data.u);
            set_eventno(data.u);
            break;

        case FP_LED_MSG:
          	xil_printf("Setting FP LED:   Value=%d\r\n",data.u);
          	//set_fpleds(data.u);
          	break;



        default:
          	xil_printf("Msg not supported yet...\r\n");
           	break;
        }

}



