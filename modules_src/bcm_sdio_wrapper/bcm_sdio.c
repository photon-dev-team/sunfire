/* 
* bcm_sdio.c
*
*Copyright (C) 2010 Beceem Communications, Inc.
*
*This program is free software: you can redistribute it and/or modify 
*it under the terms of the GNU General Public License version 2 as
*published by the Free Software Foundation. 
*
*This program is distributed in the hope that it will be useful,but 
*WITHOUT ANY WARRANTY; without even the implied warranty of
*MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 
*See the GNU General Public License for more details.
*
*You should have received a copy of the GNU General Public License
*along with this program. If not, write to the Free Software Foundation, Inc.,
*51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
*
*/


#include <linux/kernel.h>
#include <linux/module.h>
#include <linux/init.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/sched.h>
#include <linux/errno.h>
#include <linux/device.h>
#include <linux/kdev_t.h>
#include <linux/platform_device.h>
#include <linux/mmc/sdio_ids.h>
#include <linux/mmc/sdio_func.h>
#include <linux/mmc/sdio.h>
#include <linux/mmc/card.h>

#include "bcm_sdio.h"

#define VERSION "0.1"
#define VENDOR_ID 0x392
#define SDIO_MODEM_T3LPB 0xDC
#define SDIO_MODEM_350 0x015E
#define SDIO_MODEM_BCSM250 0x00FA 
#define SDIO_MODEM_BCSM351 0x015F 
#define SDIO_MODEM_BCSM352 0x0160


#define BCM_SDIO_FN0 0
#define BCM_SDIO_FN1 1
int BCM_SDIO_FN0_BLK_SIZE ;

int debuglevel = 0;
int g_irq_num = -1;

struct bcmsdio_data {
	struct sdio_func *func;
	void *wimax_data;
	unsigned int 	bremoved:1;
};

static bcmwimax_probe probe_notifier = NULL;
static bcmwimax_remove remove_notifier = NULL;
static bcmwimax_platform_deinit platform_deinit_notifier = NULL;

static struct bcmsdio_data *func_data[8] = { NULL };

static const struct sdio_device_id bcmsdio_table[] = {
	{SDIO_DEVICE(VENDOR_ID,SDIO_MODEM_T3LPB)},
	{SDIO_DEVICE(VENDOR_ID,SDIO_MODEM_350)},
	{SDIO_DEVICE(VENDOR_ID,SDIO_MODEM_BCSM250)},
    {SDIO_DEVICE(VENDOR_ID,SDIO_MODEM_BCSM351)},
    {SDIO_DEVICE(VENDOR_ID,SDIO_MODEM_BCSM352)},
 	{}							/* Terminating entry */
};

#define SDIO_CMD_RETRIES	8

MODULE_DEVICE_TABLE(sdio, bcmsdio_table);

#define BCM_DEBUG_PRINT(dbg_level, string, args...) do { \
	if (dbg_level) {	\
		printk (string, ##args);	\
	}  \
} while (0)

static int bcmsdio_probe(struct sdio_func *func, const struct sdio_device_id *id)
{
	struct bcmsdio_data *data;
	int ret = 0;

#if 1
	BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " WIMAX SDIO PROBE: NUM:x%x VID:x%x PID:x%x\n", func->num, func->vendor, func->device);
#endif

	if (func_data[func->num]) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "Can not handle function-%d\n", func->num);
		ret = -ENXIO;
		goto end;
	}

	data = kzalloc(sizeof(*data), GFP_KERNEL);
	if (!data) {
		ret = -ENOMEM;
		goto end;
	}
	data->func = func;
	func_data[func->num] = data;

	/* Enable the function */
	sdio_claim_host(func);
	sdio_enable_func(func);
	sdio_release_host(func);

	sdio_set_drvdata(func, data);

	ret = probe_notifier(func->num, &data->wimax_data,func->vendor, func->device);
	if (ret < 0) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "Probe notifier failed\n");
		goto free_data;
	}
	return 0;
  free_data:
	func_data[func->num] = NULL;
	kfree(data);

	sdio_claim_host(func);
	sdio_disable_func(func);
	sdio_release_host(func);

	sdio_set_drvdata(func, NULL);
  end:
	return ret;
}

static void bcmsdio_remove(struct sdio_func *func)
{
	struct bcmsdio_data *data = sdio_get_drvdata(func);

	BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " WIMAX SDIO REMOVE: NUM:x%x VID:x%x DID:x%x\n", func->num, func->vendor, func->device);
	if (!data)
		return;

	remove_notifier(data->wimax_data);

	sdio_claim_host(func);
	data->bremoved = 1;
	sdio_release_host(func);

	/* Disable function */
	sdio_claim_host(func);
	sdio_disable_func(func);
	sdio_release_host(func);

	sdio_set_drvdata(func, NULL);
	func_data[func->num] = NULL;
	kfree(data);
}

static struct sdio_driver bcmsdio_driver = {
	.name = "bcmsdio",
	.probe = bcmsdio_probe,
	.remove = bcmsdio_remove,
	.id_table = bcmsdio_table,
};

static int wimax_probe(struct platform_device *pdev)
{
	return 0;
}

static int wimax_remove(struct platform_device *pdev)
{
	return 0;
}

static void wimax_dev_release(struct device *pdev)
{
	return;
}

static int wimax_suspend(struct platform_device *pdev, pm_message_t state)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	BCM_DEBUG_PRINT(debuglevel, "BRCM WiMAX Suspend Called\n");
    disable_irq_nosync(g_irq_num);
	sdio_claim_host(function);
    return 0;
}

static int wimax_resume(struct platform_device *pdev)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	sdio_release_host(function);
	BCM_DEBUG_PRINT(debuglevel, "BRCM WiMAX Resume Called\n");
	enable_irq(g_irq_num);
    return 0;
}

struct platform_device p_wimax_device = {
    .name       = "brcm_wimax",
    .id     = -1,
    .dev = {
        .init_name  = "wimax platform",
        .release = wimax_dev_release, 
    },
};

static struct platform_driver wimax_device = {
    .probe          = wimax_probe,
    .remove         = wimax_remove,
    .suspend        = wimax_suspend,
    .resume         = wimax_resume,
    .driver         = {
        .name   = "brcm_wimax",
        }
};

/* Exported functions */

int bcmsdio_reg_driver(bcmwimax_probe probe_fn, bcmwimax_remove remove_fn, bcmwimax_platform_init platform_init_fn,bcmwimax_platform_deinit platform_deinit_fn, int irq_num)
{
	int ret = 0;
	if (probe_notifier || remove_notifier ||platform_deinit_notifier) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ERR " Notifiers are already registered\n");
		ret = -EINVAL;
		goto end;
	}

	if (!probe_fn || !remove_fn || !platform_deinit_fn) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ERR " Can not register NULL notifier\n");
		ret = -EINVAL;
		goto end;
	}
	probe_notifier = probe_fn;
	remove_notifier = remove_fn;
	platform_deinit_notifier = platform_deinit_fn;

    g_irq_num = irq_num;
    
	ret = sdio_register_driver(&bcmsdio_driver);

	if(!ret)
	{
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " Calling platform init function\n");
		ret = platform_init_fn();

		if(ret)
		{
			BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "Platform Init returned error and hence unregestering\n");		
			bcmsdio_unreg_driver();
		}
	}
	else
	{
		probe_notifier = NULL;
		remove_notifier = NULL;	
		platform_deinit_notifier = NULL;	
	}
	
    if(g_irq_num >= 0)
    {
        ret = platform_device_register(&p_wimax_device);
        if(ret)
        {
			BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "Platform Device Register returned error: %x\n", ret);		
            goto end;
        }

        ret = platform_driver_register(&wimax_device);
    }

  end:
	return ret;
}

EXPORT_SYMBOL(bcmsdio_reg_driver);

void bcmsdio_unreg_driver(void)
{
    if(g_irq_num >= 0)
    {
        platform_driver_unregister(&wimax_device);
        platform_device_unregister(&p_wimax_device);
    }
	sdio_unregister_driver(&bcmsdio_driver);
	platform_deinit_notifier();
	probe_notifier = NULL;
	remove_notifier = NULL;
	platform_deinit_notifier = NULL;	
}

EXPORT_SYMBOL(bcmsdio_unreg_driver);

int bcmsdio_cmd52(unsigned int data, unsigned addr, unsigned rw, unsigned func,int *perrval)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	int ret = data;
	int count = 0;

	*perrval = 0;
	
	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ** NULL FUNC PTR: x%x\n", func);
		return -1;
	}

	sdio_claim_host(function);
	if(func_data[BCM_SDIO_FN1]->bremoved) {
		ret = -1;
		goto rel_host;
	}

	while ( count < SDIO_CMD_RETRIES )
	{
		if (rw) {
			if(func != BCM_SDIO_FN0)
				sdio_writeb(function, data, addr,perrval);
			else
				sdio_f0_writeb(function, data, addr,perrval);
				
		} else {
			if(func != 0 )
				ret = sdio_readb(function, addr,perrval);
			else
				ret = sdio_f0_readb(function,addr,perrval);
		}
		if(!(*perrval))
			break;			

		count++;
	}

	if(count)
		BCM_DEBUG_PRINT(debuglevel, "Count is higher than 0 for cmd52: %x\n", count);
	
	if(*perrval) {
		BCM_DEBUG_PRINT(debuglevel, "ERR IN CMD52 %d rw: %x addr: %x, count: %x\n", *perrval, rw, addr, count);
	}
rel_host:
	sdio_release_host(function);

	return ret;
}

EXPORT_SYMBOL(bcmsdio_cmd52);

int bcmsdio_cmd52_nolock(unsigned int data, unsigned addr, unsigned rw, unsigned func,int *perrval)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	int ret = data, count = 0;
	*perrval = 0;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ** NULL FUNC PTR: x%x\n", func);
		return -1;
	}

	if(func_data[BCM_SDIO_FN1]->bremoved) {
		return -1;
	}

	while ( count < SDIO_CMD_RETRIES )
	{
		if (rw) {
			if(func != BCM_SDIO_FN0)
				sdio_writeb(function, data, addr, perrval);
			else
				sdio_f0_writeb(function, data, addr, perrval);
				
		} else {
			if(func != BCM_SDIO_FN0)
				ret = sdio_readb(function, addr, perrval);
			else
				ret = sdio_f0_readb(function, addr, perrval);
		}
		
		if(!(*perrval))
			break;

		count++;
	}

	if(count)
		BCM_DEBUG_PRINT(debuglevel, "Count is higher than 0 for cmd52_nolock: %x\n", count);
	
	if(*perrval) {
		BCM_DEBUG_PRINT(debuglevel, "ERR IN NO LOCK CMD52 %d rw: %x addr: %x, count: %x\n", *perrval, rw, addr, count);
	}

	return ret;
}

EXPORT_SYMBOL(bcmsdio_cmd52_nolock);

int bcmsdio_cmd53(unsigned int offset, int rw, int func, int blk_mode, int opcode, int buflen, char *buff)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	int ret = -1;
	int count = 0;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
		return -1;
	}

	sdio_claim_host(function);
	if(func_data[BCM_SDIO_FN1]->bremoved) {
		ret = -1;
		goto rel_host;
	}

	/* NOTE: blk_mode is not used here. If buflen exceeds corresponding 
	 * block size then SDIO stack will internally convert the request to 
	 * block req
	 * */
	if(buflen%4) {
		int i;
		
		/* Some SDIO controllers don't like CMD53 for 
 		 * request len not-multiple of 4. */
		ret = 0;
		for(i=0; i<buflen; i++) {

			buff[i] = bcmsdio_cmd52_nolock(buff[i], offset, rw, func,&ret);
			if(ret) {
				BCM_DEBUG_PRINT(debuglevel, "FAILED IN INDEX: %d for CMD52 %d rw: %x addr: %x\n", i, ret, rw, offset);
				goto rel_host;
			} else {
				if(opcode) 
					offset++;
			}
		}
	}
	else 
	{
		while( count < SDIO_CMD_RETRIES )
		{
			if(func != BCM_SDIO_FN0)
			{
				if (rw) {
					if (opcode)
						ret = sdio_memcpy_toio(function, offset, buff, buflen);
					else
						ret = sdio_writesb(function, offset, buff, buflen);
				} else {
					if (opcode)
						ret = sdio_memcpy_fromio(function, buff, offset, buflen);
					else
						ret = sdio_readsb(function, buff, offset, buflen);
				}
			}
			else
			{
				ret = bcm_sdio_cmd53(function,rw,offset,opcode,buff,buflen,BCM_SDIO_FN0_BLK_SIZE);
			}

			if(!ret)
				break;
			
			count++;
		}
		
		if(count)
			BCM_DEBUG_PRINT(debuglevel, "Count is higher than 0 for cmd53: %x\n", count);
		
		if(ret)
			BCM_DEBUG_PRINT(debuglevel, "FAILED IN CMD53 %d rw: %x addr: %x count: %x\n", ret, rw, offset, count);
	}
	//BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "cmd53-fn-%d-%d: addr:x%x w:x%x sz:x%x ret:x%x\n", func, function->num, offset, rw, buflen, ret);
rel_host:
	sdio_release_host(function);

	return ret;
}

EXPORT_SYMBOL(bcmsdio_cmd53);

int bcmsdio_set_blk_size(int func, unsigned int blk_size)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;
	int ret = 0;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
		return -1;
	}

	sdio_claim_host(function);

	if(func != BCM_SDIO_FN0)
		ret = sdio_set_block_size(function, blk_size);
	else
	{
		BCM_SDIO_FN0_BLK_SIZE = blk_size;
		sdio_f0_writeb(function,BCM_SDIO_FN0_BLK_SIZE & 0xFF, 0x10, &ret);
		if(ret < 0)
		{
			BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "failed to set the f0 block size");
		}
		sdio_f0_writeb(function,(BCM_SDIO_FN0_BLK_SIZE >> 8) &0xFF , 0x11, &ret);
		if(ret < 0)
		{
			BCM_DEBUG_PRINT(debuglevel, KERN_ALERT "failed to set the f0 block size");
		}

	}	

	sdio_release_host(function);

	return ret;
}

EXPORT_SYMBOL(bcmsdio_set_blk_size);

int bcmsdio_register_intr_handler(int func, sdio_irq_handler_t * handler)
{
	struct sdio_func *function = func_data[func]->func;
	int ret;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
		return -1;
	}

	sdio_claim_host(function);

	ret = sdio_claim_irq(function, handler);
	if (ret < 0)
		BCM_DEBUG_PRINT(debuglevel, KERN_ERR "Func-%d ISR Registration failed\n", func);

	sdio_release_host(function);

	return ret;
}

EXPORT_SYMBOL(bcmsdio_register_intr_handler);

void bcmsdio_unregister_intr_handler(int func)
{
	struct sdio_func *function = func_data[func]->func;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
		return;
	}

	sdio_claim_host(function);

	sdio_release_irq(function);

	sdio_release_host(function);

	return;
}

EXPORT_SYMBOL(bcmsdio_unregister_intr_handler);

void *bcmsdio_get_drvdata(struct sdio_func *func)
{
	struct bcmsdio_data *data = sdio_get_drvdata(func);
	if (data) {
		return data->wimax_data;
	} else {
		return NULL;
	}
}

EXPORT_SYMBOL(bcmsdio_get_drvdata);

void bcmsdio_enable_func(int func, int benable)
{
	struct sdio_func *function = func_data[func]->func;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
		return;
	}

	sdio_claim_host(function);

	if (benable) {
		sdio_enable_func(function);
	} else {
		sdio_disable_func(function);
	}

	sdio_release_host(function);

	return;
}

EXPORT_SYMBOL(bcmsdio_enable_func);

void bcmsdio_claim_host(int func)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
	} else {
		sdio_claim_host(function);
	}
	return;
}
EXPORT_SYMBOL(bcmsdio_claim_host);

void bcmsdio_release_host(int func)
{
	struct sdio_func *function = func_data[BCM_SDIO_FN1]->func;

	if (function == NULL) {
		BCM_DEBUG_PRINT(debuglevel, KERN_ALERT " ***Error: %s %d ***\n", __func__, __LINE__);
	} else {
		sdio_release_host(function);
	}
	return;
}
EXPORT_SYMBOL(bcmsdio_release_host);

void setDebugLevel(int level)
{
	printk("Turning Debug level to %x for SDIO Wrapper Driver\n", level);
	debuglevel = level;
	return;
}

EXPORT_SYMBOL(setDebugLevel);
	
struct class *bcm_class_create (void)
{
	return class_create(THIS_MODULE, "tarang");
}

EXPORT_SYMBOL(bcm_class_create);

struct device *bcm_device_create(struct class *bcm_class,unsigned int major)
{
	return 	device_create (bcm_class, NULL,MKDEV(major, 0),NULL,"tarang");
}

EXPORT_SYMBOL(bcm_device_create);


void bcm_device_destroy (struct class *bcm_class, unsigned int major)
{
	device_destroy (bcm_class,MKDEV(major, 0));
}

EXPORT_SYMBOL(bcm_device_destroy);


void bcm_class_destroy (struct class *bcm_class)
{

	class_destroy (bcm_class);	
}

EXPORT_SYMBOL(bcm_class_destroy);





	
/* Module's entry/exit functions */

static int __init bcmsdio_init(void)
{
	BCM_DEBUG_PRINT(debuglevel, KERN_INFO "Beceem WiMax SDIO driver ver %s", VERSION);
	return 0;
}

static void __exit bcmsdio_exit(void)
{
	return;
}

module_init(bcmsdio_init);
module_exit(bcmsdio_exit);

MODULE_AUTHOR("Ambika Prasad <aprasad@beceem.com>");
MODULE_DESCRIPTION("Beceem SDIO Wrapper driver ver " VERSION);
MODULE_VERSION(VERSION);
MODULE_LICENSE("GPL");
