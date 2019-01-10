function structfield = ShiftParamIndex(structfield)
 structfield(366+1:366+44) = NaN; 
 structfield(45:410) = structfield(1:366); 
 structfield(1:44) = NaN;
