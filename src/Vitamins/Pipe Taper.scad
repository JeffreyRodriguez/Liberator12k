function taperNPT_L2(nominalPipeSize, tpi) = (0.8*nominalPipeSize + 6.8)*(1/tpi); //NPT's effective thread length

function taperNPT_E0(nominalPipeSize, tpi) = nominalPipeSize - (0.05*nominalPipeSize + 1.1)*(1/tpi); //NPT's Pitch diameter at end of pipe

function taperNPT_E1(E0, L1) = E0 + 0.0625*L1; //NPT's Pitch diameter at large end of internal thread

module taperNPT(nominalPipeSize, tpi, L1 = 0){
	if(L1 == 0)
	cylinder(taperNPT_L2(nominalPipeSize, tpi), taperNPT_E1(taperNPT_E0(nominalPipeSize, tpi), taperNPT_L2(nominalPipeSize, tpi))/2, taperNPT_E0(nominalPipeSize, tpi)/2);
	else
	cylinder(taperNPT_L2(nominalPipeSize, tpi), taperNPT_E1(taperNPT_E0(nominalPipeSize, tpi), L1)/2, taperNPT_E0(nominalPipeSize, tpi)/2);
}

taperNPT(1/4, 20);