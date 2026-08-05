
// Trigger and Send DMA Data: ADC, TbT, FA

#include <stdio.h>

#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>
#include "xil_cache.h"

#include "local.h"
#include "rfdfe.h"
#include "pl_regs.h"


#include "xtime_l.h"




void processADC(s16 *adcmsg, u32 nsamples, u32 fifoaddr)
{
    u32 i, j, data;
    s16 *adcmsgbase = adcmsg;

    // Each FIFO word is 32 bits: two 16-bit ADC samples
    // FIFO is 256 bits: 12–16 bit ADC samples, 4 words of zeros
    for (i = 0; i<nsamples; i=i+12) {
        for (j = 0; j<8; j++) {
            data = Xil_In32(XPAR_M_AXI_BASEADDR + fifoaddr);

            if (j < 6) {
                // Extract upper 16 bits and lower 16 bits
                s16 sample_high = (s16)((data >> 16) & 0xFFFF);
                s16 sample_low  = (s16)(data & 0xFFFF);

                // Scale samples (right shift by 2)
                sample_high >>= 2;
                sample_low  >>= 2;
                //printf("i=%d: j=%d    %d   %d\n",i,j,sample_high,sample_low);

                // Store in network byte order
                *adcmsg++ = htons(sample_high);
                *adcmsg++ = htons(sample_low);
            }
            // j >= 6: just read FIFO to skip zero words
        }
    }


    // Debug print first 50 samples, 12 per line
    /*
    for (i = 0; i < 12*4; i++) {
        s16 sample = (s16) ntohs(adcmsgbase[i]);
        // Print sample with a space
        printf("%6d ", sample);
        // After every 12 samples, print a newline
        if ((i + 1) % 12 == 0)
            printf("\n");
    }
    printf("\n");
    */
}








static void adcdata_push(void *unused)
{
    (void)unused;

     u32 triggered, wdcnt;
     u32 trigcnt=0;

     #define ADC_MAX_LEN 8000*12

     static s16 adc[ADC_MAX_LEN];
     //static s16 chb[ADC_MAX_LEN];
     //static s16 chc[ADC_MAX_LEN];
     //static s16 chd[ADC_MAX_LEN];



    while (1) {
        vTaskDelay(pdMS_TO_TICKS(10));

        //This gets set when the ADC data has triggered and FIFO write is done
        // ADC data can get triggered from either EVR, Soft Trig or DAC
        triggered = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_WRDONE_REG);

        //triggered is set to 1 by the fabric when all the ADC data is in the
        //FIFO and ready to read out
        if (triggered == 1) {
        	trigcnt++;
            //vTaskDelay(pdMS_TO_TICKS(100));
            xil_printf("ADC Data Ready... Trigger #: %d\r\n", trigcnt);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC0_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 60, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC1_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 61, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC2_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 62, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC3_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 63, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC4_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 64, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC5_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 65, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC6_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 66, sizeof(adc), adc);

            // Process DMA data into adcmsg array
            processADC(adc, ADC_MAX_LEN, RFADC7_FIFO_DOUT_REG);
            // Send buffer (size = nsamples * sizeof(adcmsg_t))
            psc_send(the_server, 67, sizeof(adc), adc);

            xil_printf("Data Read and Sent to IOC\r\n");

            //Tell the Fabric the Readout of the ADC FIFO's is complete, to allow another trigger
            Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RDOUTDONE_REG, 1);
            Xil_Out32(XPAR_M_AXI_BASEADDR + RFADC_FIFO_RDOUTDONE_REG, 0);

            /*
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC0_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch0 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC1_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch1 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC2_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch2 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            wdcnt = Xil_In32(XPAR_M_AXI_BASEADDR + RFADC3_FIFO_WDCNT_REG);
            xil_printf("FIFO Ch3 Wdcnt after reading FIFO = %d\r\n",wdcnt);
            */

        }
    }
}

void adcdata_setup(void)
{
    printf("INFO: Starting ADC Data daemon\n");
    sys_thread_new("adcdata", adcdata_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

