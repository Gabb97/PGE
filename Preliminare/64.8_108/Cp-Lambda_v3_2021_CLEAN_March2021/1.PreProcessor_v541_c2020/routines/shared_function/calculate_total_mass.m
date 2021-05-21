function [total_mass,n_beam_element]=calculate_total_mass( length , mass_unit_length , point_mass_flag , point_mass );

i=1;
total_mass = 0 ;
n_beam_element = 0 ;
numerator=max(size(length));

while i < numerator;
    
    if ( length( i ) ~= length( i + 1 ) ),
        
        n_beam_element = n_beam_element + 1 ;
        
        a = length ( i ) ;
        c = length (i + 1 );
    
        d = mass_unit_length ( i ) ;
        f = mass_unit_length ( i + 1 ) ;
        
        
        total_mass =  total_mass + ( d * ( c - a ) ) + 0.5 * ( f - d ) * ( c - a );
    
        
    end
    
    i = i + 1 ;
    
end

if point_mass_flag == 'y',

    total_point_mass=sum(point_mass);
    
    total_mass = total_mass + total_point_mass;
    
end
