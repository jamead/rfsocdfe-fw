#ifndef DMADATA_H
#define DMADATA_H

#include <stdint.h>
#include <lwip/inet.h>   // for htons, ntohs




// One ADC sample (4 channels)
typedef struct {
    s16 cha;   // channel A
    s16 chb;   // channel B
    s16 chc;   // channel C
    s16 chd;   // channel D
} adcmsg_t;




// Function prototype
void process_ADC_dma(adcmsg_t *adcmsg, u32 nsamples);




#define ADC_DMA_MAX_LEN 1000000
#define TBT_DMA_MAX_LEN 1000000
#define FA_DMA_MAX_LEN  1000000


//base address of AXI-DMA Core for ADC Data
#define AXIDMA_ADCBASEADDR  0xA0010000


//base addresses of DMA destination
#define ADC_DMA_DATA 0x10000000


//AXI DMA CORE REGISTERS
#define S2MM_DMACR 0x30 //12
#define S2MM_DMASR 0x34 //13
#define S2MM_DA 0x48 //18
#define S2MM_LEN 0x58 //22


#endif
