
// Trigger and Send DMA Data: ADC, TbT, FA

#include <stdio.h>

#include <xparameters.h>

#include <FreeRTOS.h>
#include <lwip/sys.h>
#include <lwip/stats.h>
#include "xil_cache.h"

#include "local.h"
#include "pl_regs.h"
#include "dmadata.h"

#include "xtime_l.h"

extern u32 soft_trig_cnt;







void dma_arm() {

	//u32 *adc_ptr, *tbt_ptr, *fa_ptr;
	u32 adclen;


	//Disable the ADC,TbT,FA DMA logic (trig_logic.vhd)
	//xil_printf("   Disable DMA\r\n");
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_ADCENABLE_REG, 0);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TBTENABLE_REG, 0);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FAENABLE_REG, 0);


	//Read the DMA length registers, just so we can print them
	adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);
    adclen = 1966100*2;

	xil_printf("Arming DMA...   DMA ADC Length = %d\r\n",adclen);


	//clear the DMA memory, not necessary, already Invalidated it.
	//adc_ptr = (u32 *) ADC_DMA_DATA;
	//for (i=0;i<10000000;i++)  adc_ptr[i] = 0;


	//reset the PL DMA FIFO
	Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FIFORST_REG, 1);
	Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FIFORST_REG, 0);

	//reset the AXI DMA Core
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DMACR, 4);

	//Start the S2MM channel with all interrupts masked
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DMACR, 0xF001);


	//Write the Destination Address for the ADC data
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_DA, ADC_DMA_DATA);



	//Write the S2MM transfer length (must be written last (PG021 p72)
    //length is in bytes, for adc: 4 adc channels * 2bytes/sample
	Xil_Out32(XPAR_AXI_DMA_0_BASEADDR + S2MM_LEN, (adclen+16) * 4 * 2);




	//Enable the ADC,TbT,FA DMA logic (trig_logic.vhd)
	//DMA triggers are disabled until rising edge of ADC_ENABLE_REG
	//xil_printf("   Enabling DMA Triggers\r\n");
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TBTENABLE_REG, 1);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_FAENABLE_REG, 1);
	//Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_ADCENABLE_REG, 1);


}

/*******************************************************
 * VHDL packing:
 *
 *   adc3_data & adc2_data & adc1_data & adc0_data
 *
 * DMA transfers the lowest bits first:
 *
 *   12 samples from channel 0
 *   12 samples from channel 1
 *   12 samples from channel 2
 *   12 samples from channel 3
 *
 * Then the pattern repeats.
 *
 * Each 32-bit word contains two 16-bit ADC samples:
 *
 *   bits 15:0  = first sample
 *   bits 31:16 = second sample
 *
 * nsamples = number of samples PER CHANNEL.
 *
 * Full acquisition:
 *   240000 samples/channel x 4 channels x 2 bytes
 *   = 1,920,000 DMA bytes.
 *
 * Call after DMA completion and any required
 * DMA cache invalidation.
 *******************************************************/

#define NSAMPLES_PER_CHANNEL 1966080U //8192 turns     240000U * 4
#define NUM_CHANNELS         4U
#define SAMPLES_PER_GROUP    12U
#define WORDS_PER_GROUP      (SAMPLES_PER_GROUP / 2U)

void process_ADC_dma(adcmsg_t *adcmsg, u32 nsamples)
{
    u32 i, j, k, channel;
    u32 regval;
    u32 total_groups;
    u32 bytes_per_channel;
    u32 print_samples;
    s16 sample0, sample1;

    const u32 *adc_data = (const u32 *)ADC_DMA_DATA;

    /*
     * Buffers contain network-order samples for psc_send().
     */
    static u16 adc_ch0[NSAMPLES_PER_CHANNEL];
    static u16 adc_ch1[NSAMPLES_PER_CHANNEL];
    static u16 adc_ch2[NSAMPLES_PER_CHANNEL];
    static u16 adc_ch3[NSAMPLES_PER_CHANNEL];

    u16 *adc_channels[NUM_CHANNELS] = {
        adc_ch0, adc_ch1, adc_ch2, adc_ch3
    };

    u32 channel_count[NUM_CHANNELS] = {
        0U, 0U, 0U, 0U
    };

    (void)adcmsg;  /* Retained for compatibility. */




    /*
     * Validate sample count before accessing the DMA buffer.
     * The completed DMA transfer must contain at least
     * nsamples * NUM_CHANNELS * sizeof(u16) bytes.
     */
    if ((nsamples == 0U) ||
        (nsamples > NSAMPLES_PER_CHANNEL) ||
        ((nsamples % SAMPLES_PER_GROUP) != 0U)) {

        xil_printf(
            "Invalid samples/channel: %u\r\n"
            "Must be a multiple of 12, from 12 to %u.\r\n",
            (unsigned int)nsamples,
            (unsigned int)NSAMPLES_PER_CHANNEL);

        return;
    }

    /*
     * Each iteration processes 12 samples from one channel.
     * For 240000 samples/channel, process 80000 groups.
     */
    total_groups =
        (nsamples / SAMPLES_PER_GROUP) * NUM_CHANNELS;

    bytes_per_channel = nsamples * sizeof(u16);

    xil_printf("DMA ADC Data: %u samples/channel\r\n",
               (unsigned int)nsamples);

    for (i = 0U; i < total_groups; i++) {

        channel = i % NUM_CHANNELS;

        for (j = 0U; j < WORDS_PER_GROUP; j++) {

            regval = *adc_data++;

            sample0 = (s16)(regval & 0xFFFFU);
            sample1 = (s16)((regval >> 16) & 0xFFFFU);

            // Scale samples (right shift by 2)
            sample0 >>= 2;
            sample1 >>= 2;

            adc_channels[channel][channel_count[channel]++] =
                htons((u16)sample0);

            adc_channels[channel][channel_count[channel]++] =
                htons((u16)sample1);
        }
    }

    xil_printf("Sending DMA data...\r\n");

    psc_send(the_server, 70, bytes_per_channel, adc_ch0);
    psc_send(the_server, 71, bytes_per_channel, adc_ch1);
    psc_send(the_server, 72, bytes_per_channel, adc_ch2);
    psc_send(the_server, 73, bytes_per_channel, adc_ch3);

    xil_printf("Finished\r\n");

    /*
     * Convert network-order samples back to signed
     * host-order values for console output.
     */
    print_samples = (nsamples < 96U) ? nsamples : 96U;

    for (channel = 0U; channel < NUM_CHANNELS; channel++) {

        xil_printf("\r\nChannel %u - First %u Samples\r\n",
                   (unsigned int)channel,
                   (unsigned int)print_samples);

        for (k = 0U; k < print_samples; k++) {

            sample0 = (s16)ntohs(adc_channels[channel][k]);

            xil_printf("%d   ", (int)sample0);

            if (((k + 1U) % 8U) == 0U) {
                xil_printf("\r\n");
            }
        }

        if ((print_samples % 8U) != 0U) {
            xil_printf("\r\n");
        }
    }

    xil_printf("\r\n");
}








static void dmadata_push(void *unused)
{
    (void)unused;

    static adcmsg_t adcmsg[ADC_DMA_MAX_LEN];

    u32 prev_soft_trig_cnt = 0;
    u32 adclen, tbtlen, falen;
    u32 trignum = 0, prevtrignum = 0;


    //dma_arm();
	//Read the DMA length registers
	//adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);
	//tbtlen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_TBTBURSTLEN_REG);
	//falen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_FABURSTLEN_REG);
    Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TESTDATAENB_REG, 0);

    while (1) {
        vTaskDelay(pdMS_TO_TICKS(10));

        //trignum is incremented after DMA data is pushed to DDR
        //trignum = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_TRIGCNT_REG);



        if (prev_soft_trig_cnt != soft_trig_cnt) {
            xil_printf("Received Soft Trigger Number: %d \r\n",soft_trig_cnt);
            prev_soft_trig_cnt = soft_trig_cnt;


            dma_arm();
            //Trigger the DMA
            Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_SOFTTRIG_REG, 1);
            Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_SOFTTRIG_REG, 0);

            //xil_printf("\nTrig Num: %d\r\n", trignum);
            //prevtrignum = trignum;
            vTaskDelay(pdMS_TO_TICKS(100));
            // Invalidate caches to see fresh DMA data
            Xil_DCacheInvalidateRange(ADC_DMA_DATA, ADC_DMA_MAX_LEN * sizeof(adcmsg_t));


            // get the DMA lengths
           	adclen = Xil_In32(XPAR_M_AXI_BASEADDR + DMA_ADCBURSTLEN_REG);


            // Process DMA data into adcmsg array
            process_ADC_dma(adcmsg, 1966080);


            // Clear DMA Trigger Latch, allows for next trigger
            //Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TXTOIOC_DONE_REG, 1);
            //Xil_Out32(XPAR_M_AXI_BASEADDR + DMA_TXTOIOC_DONE_REG, 0);




            // Re-arm DMA for next trigger
            dma_arm();

        }
    }
}

void dmadata_setup(void)
{
    printf("INFO: Starting DMA Data daemon\n");
    sys_thread_new("dmadata", dmadata_push, NULL, THREAD_STACKSIZE, DEFAULT_THREAD_PRIO);
}

