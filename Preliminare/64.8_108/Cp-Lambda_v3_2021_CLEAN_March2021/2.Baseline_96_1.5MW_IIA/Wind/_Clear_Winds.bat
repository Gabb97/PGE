:: WARNING 
:: This will delete the following files in
:: ALL the subfolders of the present directory
FOR %%g IN (.\) DO del %%g\*.u /s
FOR %%g IN (.\) DO del %%g\*.v /s
FOR %%g IN (.\) DO del %%g\*.w /s
FOR %%g IN (.\) DO del %%g\*.sum /s