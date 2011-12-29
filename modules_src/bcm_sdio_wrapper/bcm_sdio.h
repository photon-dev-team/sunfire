/* 
* bcm_sdio.h
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

#ifndef __BCM_SDIO_WRAPPER__
#define __BCM_SDIO_WRAPPER__

typedef int (*bcmwimax_probe) (int funcnum, void **driver_data,unsigned int Vid, unsigned int Pid);

typedef void (*bcmwimax_remove) (void *driver_data);

typedef int (*bcmwimax_platform_init) (void);

typedef int (*bcmwimax_platform_deinit) (void);

/* ************************************************************************* */
/* bcmsdio_reg_driver: To register a module/driver to this SDIO wrapper 
 * driver. At max one driver can be registered at any point of time.
 * Input Parameters:
 * 	probe_fn: 
 * 		Probe function callback pointer. Called whenever a SDIO device
 * 	of the build time selected class is plugged-in. This callback is 
 * 	called for every function, including function 0.\
 * 	remove_fn:
 * 		Remove function callback pointer. Called, for every function,
 * 		 upon the removal of the SDIO device of selcected class or
 * 		 on unregistration of the driver.
 *    platform_init_fn:
 *           This is called to trigger the vendor specific platform init routine. 
 *
 * Output Parameters:
 * 	None
 * Return Value:
 * 	Returns negative number if error; otherwise 0 or positive number. 
 */
/* ************************************************************************* */
extern int bcmsdio_reg_driver(bcmwimax_probe probe_fn, bcmwimax_remove remove_fn, bcmwimax_platform_init platform_init_fn, bcmwimax_platform_deinit platform_deinit, int oob_irq_num);

/* ************************************************************************* */
/* bcmsdio_unreg_driver: To unregister a module/driver from this SDIO wrapper 
 * driver. 
 * Input Parameters:
 * 	None
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None. 
 */
/* ************************************************************************* */
extern void bcmsdio_unreg_driver(void);

/* ************************************************************************* */
/* bcmsdio_cmd52: This is a wrapper over standard linux SDIO calls to do
 * read/write single byte operation for the specified function. This is a
 * blocking call. It shall not be called from the SDIO interrupt handler.
 * Input Parameters:
 * 	data: 
 * 		If write, 'data' to be written; otherwise ignored.
 * 	addr: 
 * 		Device address to be read/writen 
 * 	rw: 
 * 		Read/Write Flag. If non-zero, write operation is performed;
 * 		otherwise read operation is performed.
 * 	func:
 * 		Function number to which operation to be performed.
 * Output Parameters:
 * 	perrval:
 *		Contains error code, in case error occurred in read/write.
 * Return Value:
 * 	Returns the read/write value.
 */
/* ************************************************************************* */
extern int bcmsdio_cmd52(unsigned int data, unsigned addr, unsigned rw, unsigned func,int *perrval);

/* ************************************************************************* */
/* bcmsdio_cmd53: This is a wrapper over standard linux SDIO calls to do
 * read/write for multiple bytes in single operation, for the specified 
 * function. This is a blocking call. It shall not be called from the 
 * SDIO interrupt handler.
 * Input Parameters:
 * 	offset: 
 * 		Start address of the device for read/write operation. 
 * 	rw: 
 * 		Read/Write Flag. If non-zero, write operation is performed;
 * 		otherwise read operation is performed.
 * 	func:
 * 		Function number to which operation to be performed.
 * 	blk_mode: 
 * 		Not used.
 * 	opcode:
 * 		If nonzero: read/write operation is performed from 'offset'
 * 		location with incremental location. Just like readling from 
 * 		RAM.
 * 		If zero: read/write operation is performed from 'offset' 
 * 		fixed address. Just like reading from FIFO.
 * 	buflen: 
 * 		Number of bytes to be read/written. If its value is less
 * 		than current block size of that function then operation 
 * 		is performed in non-block mode; otherwise operation is 
 * 		performed... (1) As many number of blocks as possible, 
 * 		in block mode, as single request. plus (2) Last small 
 * 		packet (smaller than current block size), if any,
 * 		in non-block mode. 
 * 	buff:
 * 		Location from/to where read/write operation to be performed.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	Returns 0 on success otherwise negative error code.
 */
/* ************************************************************************* */
extern int bcmsdio_cmd53(unsigned int offset, int rw, int func, int blk_mode, int opcode, int buflen, char *buff);

/* ************************************************************************* */
/* bcmsdio_set_blk_size: Sets the current block size of the specified function.
 * It shall not be called from the SDIO interrupt handler.
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * 	blk_size: 
 * 		Block size in bytes.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	Returns the negative error code, if error; otherwise non-negative 
 * 	number.
 */
/* ************************************************************************* */
extern int bcmsdio_set_blk_size(int func, unsigned int blk_size);

/* ************************************************************************* */
/* bcmsdio_register_intr_handler: Registers the interrupt handler for the
 * specified function. It shall not be called from the SDIO interrupt handler.
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * 	handler: 
 * 		Interrupt handler to be registered.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	Returns the negative error code, if error; otherwise non-negative 
 * 	number.
 */
/* ************************************************************************* */
extern int bcmsdio_register_intr_handler(int func, sdio_irq_handler_t * handler);

/* ************************************************************************* */
/* bcmsdio_unregister_intr_handler: Unregisters the interrupt handler for the
 * specified function. 
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None
 */
/* ************************************************************************* */
extern void bcmsdio_unregister_intr_handler(int func);

/* ************************************************************************* */
/* bcmsdio_get_drvdata: Utility function to get the driver data from the 
 * function handler. To be used in the interrupt handleri.
 * Input Parameters:
 * 	func:
 * 		Function handler.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	Driver data pointer.
 */
/* ************************************************************************* */
extern void *bcmsdio_get_drvdata(struct sdio_func *func);

/* ************************************************************************* */
/* bcmsdio_enable_func: Enables/Disables the specified function. By default,
 * all the functions are enabled.
 * It shall not be called from the SDIO interrupt handler.
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * 	benable: 
 * 		If non-zero, enables the function; otherwise disables the 
 * 		function.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None
 */
/* ************************************************************************* */
extern void bcmsdio_enable_func(int func, int benable);


/* ************************************************************************* */
/* bcmsdio_cmd52_nolock: This is a wrapper over standard linux SDIO calls to do
 * read/write single byte operation for the specified function. This is a
 * blocking call. Unlike other functions, this function doen't take sdio 
 * host lock; so caller shall make sure that  sdio_claim_host() is taken/called
 * before this function call. Typically, it should be called from the 
 * SDIO interrupt handler, registered using bcmsdio_register_intr_handler(), 
 * because of the fact that interrupt handler is called with the 
 * sdio_claim_host() lock taken.
 * Input Parameters:
 * 	data: 
 * 		If write, 'data' to be written; otherwise ignored.
 * 	addr: 
 * 		Device address to be read/writen 
 * 	rw: 
 * 		Read/Write Flag. If non-zero, write operation is performed;
 * 		otherwise read operation is performed.
 * 	func:
 * 		Function number to which operation to be performed.
 * Output Parameters:
 * 	perrval:
 *		Contains error code, in case error occurred in read/write.
 * Return Value:
 * 	Returns the read/write value.
 */
/* ************************************************************************* */
extern int bcmsdio_cmd52_nolock(unsigned int data, unsigned addr, unsigned rw, unsigned func,int *perrval);


/* ************************************************************************* */
/* 
 * bcmsdio_claim_host: This is a wrapper over sdio_claim_host 
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None.
 * */
/* ************************************************************************* */
extern void bcmsdio_claim_host(int func);

/* ************************************************************************* */
/* 
 * bcmsdio_release_host: This is a wrapper over sdio_release_host 
 * Input Parameters:
 * 	func:
 * 		Function number to which operation to be performed.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None.
 * */
/* ************************************************************************* */
extern void bcmsdio_release_host(int func);

/* ************************************************************************* */
/* 
 * setDebugLevel: This shall set the debuglevel for sdio wrapper driver prints
 * Input Parameters:
*  level: if prints have to be turned ON, pass 1.
 * Output Parameters:
 * 	None
 * Return Value:
 * 	None.
 * */
/* ************************************************************************* */
extern void setDebugLevel(int level);

/* ************************************************************************* */
/*

 * bcm_class_create		: This is a wrapper over class_create
 * Input Parameters		:
 *						: None
 * Output Parameters	:
 *						: None
 * Return Value			:
 *						: struct class *
 * */
/* ************************************************************************* */

extern struct class *bcm_class_create(void);

/* ************************************************************************* */
/* 
 * bcm_device_create: This is a wrapper over device_create
 * Input Parameters	:
 * 					: struct class *
					: major no.
 * Output Parameters:
 *					: None
 * Return Value		:
 *					: struct device *
 * */
/* ************************************************************************* */

extern struct device *bcm_device_create(struct class *bcm_class,unsigned int major);

/* ************************************************************************* */
/* 
 * bcm_device_destroy: This is a wrapper over device_destroy
 * Input Parameters	:
 *					: struct class *
 *					: major no.
 * Output Parameters:
 *					: None
 * Return Value		:
 *					: None.
 * */
/* ************************************************************************* */

extern void bcm_device_destroy (struct class *bcm_class, unsigned int major);

/* ************************************************************************* */
/* 
 * bcm_class_destroy: This is a wrapper over class_destroy
 * Input Parameters	:
 *					: struct class *  
 * Output Parameters:
 *					: None
 * Return Value		:
 *					: None.
 * */
/* ************************************************************************* */

extern void bcm_class_destroy (struct class *bcm_class);


#endif

