function salida=nansem(entrada)
entrada=entrada(~isnan(entrada));
salida=std(entrada)/sqrt(length(entrada));

end