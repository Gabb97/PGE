function surface = DefineDefaultPointsForSurfaces

% This subroutine defines the standard coordinates for hub, nacelle
% surfaces. These data should not be edited as they are quite standard for
% the majority of applications #LS

% nacelle_botton
%--------------------------------------------------------------------------
surface.nacelle_botton.name             = 'nacelle_botton'; 
surface.nacelle_botton.type             = 'surface'; 
surface.nacelle_botton.frame            = 'frame_shape_nacelle_botton'; 
surface.nacelle_botton.numb_points      = [12 9]; 
surface.nacelle_botton.curve_degree     = [3 2]; 
surface.nacelle_botton.coordinates      = [    
                                            1 			1.34387 	-4 				1;
                                           0.958954 	1.34387 	-3.66593 		1;
                                           0.891552 	1.34387 	-3.16492 		1;
                                           0.791786 	1.34387 	-2.49877 		1;
                                           0.708529 	1.34387 	-1.99822 		1;
                                           0.614589 	1.34387 	-1.49652 		1;
                                           0.502893 	1.34387 	-0.993445 		1;
                                           0.391164 	1.34387 	-0.588452 		1;
                                           0.27344 		1.34387 	-0.290956 		1;
                                           0.173859 	1.34387 	-0.090947 		1;
                                           0.0715269 	1.34387 	-0.0245467 		1;
                                           0.02 		1.34387 	0 				1;
                                           1 			2.34387		-4 				0.707107;
                                           0.958954 	2.30282		-3.66592 		0.707107;
                                           0.891553 	2.23542		-3.16491 		0.707107;
                                           0.791787 	2.13566		-2.49877 		0.707107;
                                           0.708529 	2.05241		-1.99821 		0.707107;
                                           0.614589 	1.95846		-1.49652 		0.707107;
                                           0.502893 	1.84676		-0.993445 		0.707107;
                                           0.391163 	1.73503		-0.588451 		0.707107;
                                           0.273441 	1.61731		-0.290956 		0.707107;
                                           0.173859 	1.51773		-0.0909469 		0.707107;
                                           0.0715269 	1.4154 		-0.0245468 		0.707107;
                                           0.0199999 	1.36387 	0 				0.707107;
                                           0 			2.34387 	-4 				1;
                                           0 			2.30282 	-3.66593 		1;
                                           0 			2.23542 	-3.16492 		1;
                                           0 			2.13566 	-2.49877 		1;
                                           0 			2.0524 		-1.99822 		1;
                                           0 			1.95846 	-1.49652 		1;
                                           0 			1.84676 	-0.993445 		1;
                                           0 			1.73503 	-0.588452 		1;
                                           0 			1.61731 	-0.290956 		1;
                                           0 			1.51773 	-0.090947 		1;
                                           0 			1.4154 		-0.0245467 		1;
                                           0 			1.36387 	0 				1;
                                           -1 			2.34387 	-4 				0.707107;
                                           -0.958954 	2.30282 	-3.66592 		0.707107;
                                           -0.891553 	2.23542 	-3.16491 		0.707107;
                                           -0.791787 	2.13566 	-2.49877 		0.707107;
                                           -0.708529 	2.05241 	-1.99821 		0.707107;
                                           -0.614589 	1.95846 	-1.49652 		0.707107;
                                           -0.502893 	1.84676 	-0.993445 		0.707107;
                                           -0.391163 	1.73503 	-0.588451 		0.707107;
                                           -0.273441 	1.61731 	-0.290956 		0.707107;
                                           -0.173859 	1.51773 	-0.0909469 		0.707107;
                                           -0.0715269 	1.4154 		-0.0245468 		0.707107;
                                           -0.0199999 	1.36387 	0 				0.707107;
                                           -1 			1.34387 	-4 				1;
                                           -0.958954 	1.34387 	-3.66593 		1;
                                           -0.891552 	1.34387 	-3.16492 		1;
                                           -0.791786 	1.34387 	-2.49877 		1;
                                           -0.708529 	1.34387 	-1.99822 		1;
                                           -0.614589 	1.34387 	-1.49652 		1;
                                           -0.502893 	1.34387 	-0.993445 		1;
                                           -0.391164 	1.34387 	-0.588452 		1;
                                           -0.27344 	1.34387 	-0.290956 		1;
                                           -0.173859 	1.34387 	-0.090947 		1;
                                           -0.0715269 	1.34387 	-0.0245467 		1;
                                           -0.02 		1.34387 	0 				1;
                                           -1 			0.343872 	-4 				0.707107;
                                           -0.958954 	0.384918 	-3.66592 		0.707107;
                                           -0.891553 	0.452319 	-3.16491 		0.707107;
                                           -0.791787 	0.552085 	-2.49877 		0.707107;
                                           -0.708529 	0.635342 	-1.99821 		0.707107;
                                           -0.614589 	0.729281 	-1.49652 		0.707107;
                                           -0.502893 	0.840977 	-0.993445 		0.707107;
                                           -0.391163 	0.952707 	-0.588451 		0.707107;
                                           -0.273441 	1.07043 	-0.290956 		0.707107;
                                           -0.173859 	1.17001 	-0.0909469 		0.707107;
                                           -0.0715269 	1.27234 	-0.0245468 		0.707107;
                                           -0.0199999 	1.32387 	0 				0.707107;
                                           0 			0.343871 	-4 				1;
                                           0 			0.384917 	-3.66593 		1;
                                           0 			0.452319 	-3.16492 		1;
                                           0 			0.552085 	-2.49877 		1;
                                           0 			0.635342 	-1.99822 		1;
                                           0 			0.729282 	-1.49652 		1;
                                           0 			0.840978 	-0.993445 		1;
                                           0 			0.952708 	-0.588452 		1;
                                           0 			1.07043 	-0.290956 		1;
                                           0 			1.17001 	-0.090947 		1;
                                           0 			1.27234 	-0.0245467 		1;
                                           0 			1.32387 	0 				1;
                                           1 			0.343872 	-4 				0.707107;
                                           0.958954 	0.384918 	-3.66592 		0.707107;
                                           0.891553 	0.452319 	-3.16491 		0.707107;
                                           0.791787 	0.552085 	-2.49877 		0.707107;
                                           0.708529 	0.635342 	-1.99821 		0.707107;
                                           0.614589 	0.729281 	-1.49652 		0.707107;
                                           0.502893 	0.840977 	-0.993445 		0.707107;
                                           0.391163 	0.952707 	-0.588451 		0.707107;
                                           0.273441 	1.07043 	-0.290956 		0.707107;
                                           0.173859 	1.17001 	-0.0909469 		0.707107;
                                           0.0715269 	1.27234 	-0.0245468 		0.707107;
                                           0.0199999 	1.32387 	0 				0.707107;
                                           1 			1.34387 	-4 				1;
                                           0.958954 	1.34387 	-3.66593 		1;
                                           0.891552 	1.34387 	-3.16492 		1;
                                           0.791786 	1.34387 	-2.49877 		1;
                                           0.708529 	1.34387 	-1.99822 		1;
                                           0.614589 	1.34387 	-1.49652 		1;
                                           0.502893 	1.34387 	-0.993445 		1;
                                           0.391164 	1.34387 	-0.588452 		1;
                                           0.27344 		1.34387 	-0.290956 		1;
                                           0.173859 	1.34387 	-0.090947 		1;
                                           0.0715269 	1.34387 	-0.0245467 		1;
                                           0.02 		1.34387 	0 				1;
                                        ];

% nacelle_centre
%--------------------------------------------------------------------------
surface.nacelle_centre.name             = 'nacelle_centre'; 
surface.nacelle_centre.type             = 'surface'; 
surface.nacelle_centre.frame            = 'frame_shape_nacelle_botton'; 
surface.nacelle_centre.numb_points      = [4 9]; 
surface.nacelle_centre.curve_degree     = [3 2]; 
surface.nacelle_centre.coordinates      = [    
                                              1 	0 	-4 			1;
                                              1 	0 	-3.5 		1;
                                              1 	0 	-3 			1;
                                              1 	0 	-2.5 		1;
                                              1 	1 	-4 			0.707107;
                                              1 	1 	-3.49999 	0.707107;
                                              1 	1 	-3 			0.707107;
                                              1 	1 	-2.5 		0.707107;
                                              0 	1 	-4 			1;
                                              0 	1 	-3.5 		1;
                                              0 	1 	-3 			1;
                                              0 	1 	-2.5 		1;
                                              -1 	1 	-4 			0.707107;
                                              -1 	1 	-3.49999 	0.707107;
                                              -1 	1 	-3 			0.707107;
                                              -1 	1 	-2.5 		0.707107;
                                              -1 	0 	-4 			1;
                                              -1 	0 	-3.5 		1;
                                              -1 	0 	-3 			1;
                                              -1 	0 	-2.5 		1;
                                              -1 	-1 	-4 			0.707107;
                                              -1 	-1 	-3.49999 	0.707107;
                                              -1 	-1 	-3 			0.707107;
                                              -1 	-1 	-2.5 		0.707107;
                                              0 	-1	-4 			1;
                                              0 	-1	-3.5 		1;
                                              0 	-1	-3 			1;
                                              0 	-1	-2.5 		1;
                                              1 	-1	-4 			0.707107;
                                              1 	-1	-3.49999 	0.707107;
                                              1 	-1	-3 			0.707107;
                                              1 	-1	-2.5 		0.707107;
                                              1 	0 	-4 			1;
                                              1 	0 	-3.5 		1;
                                              1 	0 	-3 			1;
                                              1 	0 	-2.5 		1;
                                               ];

                                           
% nacelle_initial                                           
%--------------------------------------------------------------------------
surface.nacelle_initial.name             = 'nacelle_initial'; 
surface.nacelle_initial.type             = 'surface'; 
surface.nacelle_initial.frame            = 'frame_shape_nacelle_botton'; 
surface.nacelle_initial.numb_points      = [5 9]; 
surface.nacelle_initial.curve_degree     = [3 2]; 
surface.nacelle_initial.coordinates      = [    
                                              0.8 		0 			-1 				1;
                                              0.833333 	0 			-0.833333 		1;
                                              0.9 		0 			-0.5 			1;
                                              0.966667 	0 			-0.166667 		1;
                                              1 		0 			0 				1;
                                              0.799999 	0.799999 	-1 				0.707107;
                                              0.833334 	0.833334 	-0.833334 		0.707107;
                                              0.9 		0.9 		-0.499999 		0.707107;
                                              0.966667 	0.966667 	-0.166666 		0.707107;
                                              1 		1 			0 				0.707107;
                                              0 		0.8 		-1 				1;
                                              0 		0.833333 	-0.833333 		1;
                                              0 		0.9 		-0.5 			1;
                                              0 		0.966667 	-0.166667 		1;
                                              0 		1 			0 				1;
                                              -0.799999 0.799999 	-1 				0.707107;
                                              -0.833334 0.833334 	-0.833334 		0.707107;
                                              -0.9 		0.9 		-0.499999 		0.707107;
                                              -0.966667 0.966667 	-0.166666 		0.707107;
                                              -1 		1 			0 				0.707107;
                                              -0.8 		0 			-1 				1;
                                              -0.833333 0 			-0.833333 		1;
                                              -0.9 		0 			-0.5 			1;
                                              -0.966667 0 			-0.166667 		1;
                                              -1 		0 			0 				1;
                                              -0.799999 -0.799999 	-1 				0.707107;
                                              -0.833334 -0.833334 	-0.833334 		0.707107;
                                              -0.9 		-0.9 		-0.499999 		0.707107;
                                              -0.966667 -0.966667 	-0.166666 		0.707107;
                                              -1 		-1 			0 				0.707107;
                                              0 		-0.8 		-1 				1;
                                              0 		-0.833333 	-0.833333 		1;
                                              0 		-0.9 		-0.5 			1;
                                              0 		-0.966667 	-0.166667 		1;
                                              0 		-1 			0 				1;
                                              0.799999 	-0.799999 	-1 				0.707107;
                                              0.833334 	-0.833334 	-0.833334 		0.707107;
                                              0.9 		-0.9 		-0.499999 		0.707107;
                                              0.966667 	-0.966667 	-0.166666 		0.707107;
                                              1 		-1 			0 				0.707107;
                                              0.8 		0 			-1 				1;
                                              0.833333 	0 			-0.833333 		1;
                                              0.9 		0 			-0.5 			1;
                                              0.966667 	0 			-0.166667 		1;
                                              1 		0 			0 				1;
                                              ];
                                          
% hub                                           
%--------------------------------------------------------------------------
surface.hub.name             = 'hub'; 
surface.hub.type             = 'surface'; 
surface.hub.frame            = 'frame_shape_hub'; 
surface.hub.numb_points      = [12 9]; 
surface.hub.curve_degree     = [3 2]; 
surface.hub.coordinates      = [      0.315084 		-0.734439 	0.3 		1;
                                      0.321929 		-0.734439 	0.335876	1;
                                      0.323581 		-0.734439 	0.411464	1;
                                      0.262213 		-0.734439 	0.499285	1;
                                      0.214073 		-0.734439 	0.597118	1;
                                      0.15917 		-0.734439 	0.747352	1;
                                      0.0202558 	-0.734439 	0.758268	1;
                                      -0.0591005 	-0.734439 	0.929302	1;
                                      -0.172279 	-0.734439 	0.993961	1;
                                      -0.308356 	-0.734439 	1.06571 	1;
                                      -0.403069 	-0.734439 	1.09068 	1;
                                      -0.464916 	-0.734439 	1.1 		1;
                                      0.315084 		0.0655614 	0.3 		0.707107;
                                      0.321929 		0.0724066 	0.335876 	0.707107;
                                      0.323582 		0.0740587 	0.411464 	0.707107;
                                      0.262212 		0.0126902 	0.499285 	0.707107;
                                      0.214072 		-0.0354499 	0.597118 	0.707107;
                                      0.15917 		-0.0903527 	0.747351 	0.707107;
                                      0.0202558 	-0.229267 	0.758269 	0.707107;
                                      -0.0591005 	-0.308624 	0.929302 	0.707107;
                                      -0.172279 	-0.421802 	0.99396 	0.707107;
                                      -0.308355 	-0.557879 	1.06571 	0.707107;
                                      -0.403069 	-0.652591 	1.09068 	0.707107;
                                      -0.464916 	-0.714438 	1.1 		0.707107;
                                      -0.484916 	0.0655613 	0.3 		1;
                                      -0.484916 	0.0724066 	0.335876 	1;
                                      -0.484916 	0.0740587 	0.411464 	1;
                                      -0.484916 	0.0126902 	0.499285 	1;
                                      -0.484916 	-0.0354499 	0.597118 	1;
                                      -0.484916 	-0.0903527 	0.747352 	1;
                                      -0.484916 	-0.229267 	0.758268 	1;
                                      -0.484916 	-0.308623 	0.929302 	1;
                                      -0.484916 	-0.421802 	0.993961 	1;
                                      -0.484916 	-0.557878 	1.06571 	1;
                                      -0.484916 	-0.652591 	1.09068 	1;
                                      -0.484916 	-0.714439 	1.1 		1;
                                      -1.28492 		0.0655614 	0.3 		0.707107;
                                      -1.29176 		0.0724066 	0.335876 	0.707107;
                                      -1.29341 		0.0740587 	0.411464 	0.707107;
                                      -1.23204 		0.0126902 	0.499285 	0.707107;
                                      -1.1839 		-0.0354499 	0.597118 	0.707107;
                                      -1.129 		-0.0903527 	0.747351 	0.707107;
                                      -0.990088 	-0.229267 	0.758269 	0.707107;
                                      -0.910732 	-0.308624 	0.929302 	0.707107;
                                      -0.797553 	-0.421802 	0.99396 	0.707107;
                                      -0.661476 	-0.557879 	1.06571 	0.707107;
                                      -0.566763 	-0.652591 	1.09068 	0.707107;
                                      -0.504916 	-0.714438 	1.1 		0.707107;
                                      -1.28492 		-0.734439 	0.3 		1;
                                      -1.29176 		-0.734439 	0.335876 	1;
                                      -1.29341 		-0.734439 	0.411464 	1;
                                      -1.23204 		-0.734439 	0.499285 	1;
                                      -1.1839 		-0.734439 	0.597118 	1;
                                      -1.129 		-0.734439 	0.747352 	1;
                                      -0.990088 	-0.734439 	0.758268 	1;
                                      -0.910732 	-0.734439 	0.929302 	1;
                                      -0.797553 	-0.734439 	0.993961 	1;
                                      -0.661476 	-0.734439 	1.06571 	1;
                                      -0.566763 	-0.734439 	1.09068 	1;
                                      -0.504916 	-0.734439 	1.1 		1;
                                      -1.28492 		-1.53444 	0.3 		0.707107;
                                      -1.29176 		-1.54128 	0.335876 	0.707107;
                                      -1.29341 		-1.54293 	0.411464 	0.707107;
                                      -1.23204 		-1.48157 	0.499285 	0.707107;
                                      -1.1839 		-1.43343 	0.597118 	0.707107;
                                      -1.129 		-1.37852 	0.747351 	0.707107;
                                      -0.990088 	-1.23961 	0.758269 	0.707107;
                                      -0.910732 	-1.16025 	0.929302 	0.707107;
                                      -0.797553 	-1.04707 	0.99396 	0.707107;
                                      -0.661476 	-0.910999 	1.06571 	0.707107;
                                      -0.566763 	-0.816285 	1.09068 	0.707107;
                                      -0.504916 	-0.754439 	1.1 		0.707107;
                                      -0.484916 	-1.53444 	0.3 		1;
                                      -0.484916 	-1.54128 	0.335876 	1;
                                      -0.484916 	-1.54294 	0.411464 	1;
                                      -0.484916 	-1.48157 	0.499285 	1;
                                      -0.484916 	-1.43343 	0.597118 	1;
                                      -0.484916 	-1.37852 	0.747352 	1;
                                      -0.484916 	-1.23961 	0.758268 	1;
                                      -0.484916 	-1.16025 	0.929302 	1;
                                      -0.484916 	-1.04708 	0.993961	1;
                                      -0.484916 	-0.910999 	1.06571 	1;
                                      -0.484916 	-0.816286 	1.09068 	1;
                                      -0.484916 	-0.754439 	1.1 		1;
                                      0.315084 		-1.53444 	0.3 		0.707107;
                                      0.321929 		-1.54128 	0.335876 	0.707107;
                                      0.323582 		-1.54293 	0.411464 	0.707107;
                                      0.262212 		-1.48157 	0.499285 	0.707107;
                                      0.214072 		-1.43343 	0.597118 	0.707107;
                                      0.15917 		-1.37852 	0.747351 	0.707107;
                                      0.0202558 	-1.23961 	0.758269 	0.707107;
                                      -0.0591005 	-1.16025 	0.929302 	0.707107;
                                      -0.172279 	-1.04707 	0.99396 	0.707107;
                                      -0.308355 	-0.910999 	1.06571 	0.707107;
                                      -0.403069 	-0.816285 	1.09068 	0.707107;
                                      -0.464916 	-0.754439 	1.1 		0.707107;
                                      0.315084 		-0.734439 	0.3 		1;
                                      0.321929 		-0.734439 	0.335876 	1;
                                      0.323581 		-0.734439 	0.411464 	1;
                                      0.262213 		-0.734439 	0.499285 	1;
                                      0.214073 		-0.734439 	0.597118 	1;
                                      0.15917 		-0.734439 	0.747352 	1;
                                      0.0202558 	-0.734439 	0.758268 	1;
                                      -0.0591005 	-0.734439 	0.929302 	1;
                                      -0.172279 	-0.734439 	0.993961 	1;
                                      -0.308356 	-0.734439 	1.06571 	1;
                                      -0.403069 	-0.734439 	1.09068 	1;
                                      -0.464916 	-0.734439 	1.1 		1;
                                      ];
                                  
                                  
% Circle                                           
%--------------------------------------------------------------------------
surface.circle.name             = 'circle'; 
surface.circle.type             = 'curve'; 
surface.circle.frame            = 'tower_frame'; 
surface.circle.numb_points      = 10; 
surface.circle.curve_degree     = 1; 
surface.circle.coordinates      = [   0  	5  	0 ;
                                      0  	5  	3 ;
                                      0  	3  	5 ;
                                      0  	-3  5 ;
                                      0  	-5  3 ;
                                      0  	-5  -3;
                                      0  	-3  -5;
                                      0  	 3  -5;
                                      0  	5  	-3;
                                      0  	5  	0 ];



% NACA                                           
%--------------------------------------------------------------------------
surface.naca.name             = 'naca'; 
surface.naca.type             = 'curve'; 
surface.naca.frame            = 'tower_frame_shape'; 
surface.naca.numb_points      = 5; 
surface.naca.curve_degree     = 1; 
surface.naca.coordinates      = [       0 	-1.2405 	0 ;
                                        0 	-0.4808 	0.087 ;
                                        0 	0 			0;
                                        0 	-0.4808 	-0.067;
                                        0 	-1.2405 	0;];



