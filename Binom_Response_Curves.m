success = [21	21	31	32	47	50	15];
trials = [68	69	68	52	65	52	39];

		
			

[phat,pci] = binofit(success,trials);
CI_percent = [pci(:,2),pci(:,1)]*100