function lifting_line_properties_definition( fpc , header ,name , eta_chord , chord , quarter_off_set , eta_airtables , airtables_name , flap_flag );


eta_number = max(size(eta_chord));
airtables_number = max(size(eta_airtables));

if header == 'y',
    fprintf(fpc,' LiftingLineProperties :\n');
end

fprintf(fpc,'  LiftingLineProperty :\n');
fprintf(fpc,'    Name : %2s ;\n', deblank(name) );
fprintf(fpc,'      ChordLengths :\n');
fprintf(fpc,'      NumberOfTerms : %2g ;\n' , eta_number );
for i = 1 : eta_number,
    fprintf(fpc,'      EtaValue : %2.16g ; ', eta_chord(i) );
    fprintf(fpc,'      ChordLength : %2.16g ;' , chord(i) );
    fprintf(fpc,'      QuarterChordOffset : %2.16g ; \n', quarter_off_set(i) );
end
fprintf(fpc,'     ;\n');
fprintf(fpc,'      Airtables :\n');
fprintf(fpc,'      NumberOfTerms : %2g ;\n' , airtables_number );
for i = 1 : airtables_number,
    fprintf(fpc,'      EtaValue : %2.16g ;' , eta_airtables(i) );
    fprintf(fpc,'      Airtable : %2s ;\n' , deblank(airtables_name(i,:)) );
end
fprintf(fpc,'     ;\n');


if flap_flag == 'y',
    fprintf(fpc,'      Flapstations :\n');
    fprintf(fpc,'      NumberOfTerms : n°ap ;\n');
    fprintf(fpc,'      EtaValue : ´ ;\n');
    fprintf(fpc,'      Beam : beam name ;\n');
    fprintf(fpc,'      HingeLocation : xhinge ;\n');
    fprintf(fpc,'     ;\n');
    fprintf(fpc,'      NumberOfStates : nstate ;\n');    
end

fprintf(fpc,'     ;\n');

if header == 'y',
    fprintf(fpc,' ;\n\n\n');
end