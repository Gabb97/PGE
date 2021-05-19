%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Creazione cartella             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

0.a) Creare una cartella in Preliminare per ogni simulazione nel formato: RaggioRotore_HubHeight

	Esempio: 57.6_80 --> 	Raggio Rotore: 57.6 m
												Altezza Hub: 80 m
0.b) Copiare un CpLambda INTERO E PULITO !!! nella cartella appena creata

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Rigenerazione struttura           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

1.a) Impostare Rotor radius su Baseline_96....Structure_Data.xlsx
1.b) Eseguire RotoCS_Main.m
1.c) Salvare nella cartella input del PreProcessor i file prodotti

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              Creazione modello              %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

2.a) Impostare Rated Electrical Power a 2.7 MW in WTData.xlsx
2.b) Impostare Hub height al valore assegnato in hub_details.txt
	--> Impostare Tower height di conseguenza (1 metro sotto all'hub)
2.c) Impostare Weibull Vave a 10 m/s in WTData.xlsx ( lo fa automaticamente facendo 2.e )
2.d) Impostare Wind Turbine Category a B in WTData.xlsx
2.e) Impostare Wind Turbine Class 1 in WTData.xlsx
2.f) Eseguire il PreProcessor (generare il modello MB)
2.g) Spostare i 35 file del modello MB in Cp_lambda

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Analisi con CpLambda             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

3.a) Lanciare la procedura MAIN_Campbell.m
3.b) Lanciare la procedura MAIN_CpLambda.m

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%            Successive simulazioni           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

4.a) Ripartire dal punto 0.a) per le successive 2 simulazioni

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                --- FINE ---                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
